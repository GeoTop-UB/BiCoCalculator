"use strict";

import axios from "axios";
// Why dist/sockjs? See https://github.com/sockjs/sockjs-client/issues/439
import SockJS from "sockjs-client/dist/sockjs";

export default class SageCellClient {
  constructor(config) {
    this.config = {};

    this.connected = false;

    this.config.onstatuschange = null;
    this.config.onconnect = {};
    this.config.onmessage = null;
    this.config.onerror = null;
    this.config.server = "https://sagecell.sagemath.org";
    this.config.timeout = 200;
    this.config.maxNumberOfAttempts = 10;
    this.config.intervalTime = 200;

    if (config.server) this.config.server = config.server;
    if (config.timeout) this.config.timeout = config.timeout;
    if (config.onconnect) this.config.onconnect[crypto.randomUUID()] = config.onconnect;
    if (config.onstatuschange) this.config.onstatuschange = config.onstatuschange;
    if (config.onmessage) this.config.onmessage = config.onmessage;
    if (config.onerror) this.config.onerror = config.onerror;
  }

  //Connect to kernel
  connect() {
    this.cellSessionID = crypto.randomUUID().replaceAll("-", "");
    this.connected = false;
    this.sessionID = null;
    this.listners = {};

    axios({
      method: "post",
      url: this.getKernelUrl(),
      responseType: "json",
      data: { accepted_tos: true }
    })
      .then((response) => {
        this.sessionID = response.data.id;
        this.wsURL = response.data.ws_url;

        this.sock = new SockJS(this.getSockUrl());
        this.sock.onopen = () => {
          this.connected = true;
          this.sendStatusChangeEvent("connected");
          this.sendConnectEvent();
        };

        this.sock.onmessage = (e) => {
          var data = JSON.parse(e.data.replace(this.sessionID + "/channels,", ""));
          if (data.msg_type == "execute_result" && data.content.data["text/plain"] != null) {
            var res = {
              from: data.parent_header.msg_id,
              type: "text",
              data: data.content.data["text/plain"],
              raw: data
            };
            this.sendDataEvent(res);
            this.listners[data.parent_header.msg_id]("done", res);
          }
          if (data.msg_type == "execute_reply") {
            this.listners[data.parent_header.msg_id]("done", res);
          }
          if (data.msg_type == "display_data" && data.content.data["text/plain"] != null) {
            var res = {
              from: data.parent_header.msg_id,
              type: "image",
              data: this.getImageUrl(data.content.data["text/image-filename"]),
              raw: data
            };
            this.sendDataEvent(res);
            this.listners[data.parent_header.msg_id]("done", res);
          }
          if (
            data.header.msg_type == "status" &&
            data.content.execution_state &&
            data.content.execution_state == "dead"
          ) {
            if (this.connected) {
              this.connected = false;
              this.sendStatusChangeEvent("closed");
              this.disconnect();
            }
          }
          if (data.msg_type == "error") {
            this.sendErrorEvent("sage", data.content);
            this.listners[data.parent_header.msg_id]("error", data.content);
          }
        };

        this.sock.onerror = (e) => {
          this.sendErrorEvent("sockjs", e);
        };

        this.sock.onclose = (e) => {
          if (this.connected) {
            this.connected = false;
            this.sendStatusChangeEvent("closed");
            this.disconnect();
          }
        };
      })
      .catch((err) => {
        this.sendErrorEvent("kernel_connect", err);
      });
  }

  // TODO add timeout, if no connect before this hangs forever!
  waitForOpenConnection() {
    return new Promise((resolve, reject) => {
      if (!this.connected) {
        this.config.onconnect[crypto.randomUUID()] = resolve;
      } else {
        resolve();
      }
    });
  }

  //Close connection
  disconnect() {
    this.connected = false;
    this.sessionID = null;
    this.sock.close();
    this.sock = null;
  }

  //Close and then re-open connection
  reconnect() {
    this.disconnect();
    this.connect();
  }

  //Send formula to server
  async sendCommand(id, command) {
    try {
      await this.waitForOpenConnection();
      return this.send(id, "execute_request", this.getCodeContent(command));
    } catch (err) {
      console.error(err);
    }
  }

  //Send raw command. Return promise of the response
  send(id, op, msg) {
    return new Promise((resolve, reject) => {
      if (!this.connected) {
        this.sendErrorEvent("sending_error", { error: "not connected" });
        reject({ error: "not connected" });
        return;
      }
      if (!this.sock) {
        this.sendErrorEvent("sending_error", { error: "no socket" });
        reject({ error: "no socket" });
        return;
      }

      if (!id) id = crypto.randomUUID().replaceAll("-", "");

      this.listners[id] = (status, data) => {
        if (status == "done") {
          resolve(data);
        } else {
          reject(data);
        }
      };
      this.sock.send(this.getMsgData(id, op, msg));
    });
  }

  //Get URLs
  getKernelUrl() {
    return (
      this.config.server +
      "/kernel?timeout=" +
      this.config.timeout +
      "&CellSessionID=" +
      this.cellSessionID
    );
  }
  getSockUrl() {
    return this.config.server + "/sockjs" + "?CellSessionID=" + this.cellSessionID;
  }
  getImageUrl(f) {
    return this.config.server + "/kernel/" + this.sessionID + "/files/" + f;
  }

  //Event listners
  sendErrorEvent(from, err) {
    if (this.config.onerror) this.config.onerror(from, err);
  }
  sendConnectEvent() {
    for (const [_, listener] of Object.entries(this.config.onconnect)) {
      listener();
    }
  }
  sendStatusChangeEvent(status) {
    if (this.config.onstatuschange) this.config.onstatuschange(status);
  }
  sendDataEvent(msg) {
    if (this.config.onmessage) this.config.onmessage(msg);
  }

  //Helpers methods
  getMsgData(id, msg_type, content) {
    return (
      this.sessionID +
      "/channels" +
      "," +
      JSON.stringify({
        header: {
          msg_id: id,
          session: this.cellSessionID,
          msg_type: msg_type,
          username: "username",
          version: "5.2"
        },
        content: content,
        parent_header: {},
        metadata: {},
        buffers: [],
        channel: "shell"
      })
    );
  }
  getCodeContent(code) {
    return {
      code: code,
      silent: false,
      store_history: false,
      user_expressions: {
        _sagecell_files: "sys._sage_.new_files()"
      },
      allow_stdin: false
    };
  }
}

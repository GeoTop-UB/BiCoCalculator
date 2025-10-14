import SageCellClient from "./sagecell.js";
import type { ComputeBackend } from "./types";

import bicoLib from "./bico.py.sage?raw";

// const version =
const apiUrl = "http://127.0.0.1:5001/";
const client = new SageCellClient({
  // onstatuschange: (status) => {
  //   console.log("status change", status);
  // },
  // onmessage: (msg) => {
  //   console.log("msg", msg);
  // },
  // onerror: (from, err) => {
  //   console.log("err", from, err);
  // },
  timeout: 30
});

export const computeSelfhosted: ComputeBackend = async (
  varNames,
  lieBracket,
  acsMatrix,
  acsNorm
) => {
  const response = await fetch(apiUrl, {
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json"
    },
    method: "POST",
    body: JSON.stringify({
      lie: {
        names: varNames.join(","),
        bracket: lieBracket
      },
      acs: {
        names: varNames,
        matrix: acsMatrix,
        ...(acsNorm != undefined && { norm: acsNorm })
      }
    })
  });
  return response.text();
};

export const computeSageCell: ComputeBackend = async (varNames, lieBracket, acsMatrix, acsNorm) => {
  if (!client.connected) {
    client.connect();
    await client.sendCommand(null, bicoLib);
  }
  const sLieNames = varNames.join(",");
  const sLieBracket = JSON.stringify(lieBracket);
  const sAcsMatrix = JSON.stringify(acsMatrix);
  const sAcsNames = JSON.stringify(varNames);
  const sAcsNorm = acsNorm != undefined ? JSON.stringify(acsNorm) : "None";
  const command = `compute("${sLieNames}", ${sLieBracket}, ${sAcsMatrix}, ${sAcsNames}, ${sAcsNorm})`;
  console.log(command);
  const r = await client.sendCommand(null, command);
  return r.data.substring(1, r.data.length - 1);
};

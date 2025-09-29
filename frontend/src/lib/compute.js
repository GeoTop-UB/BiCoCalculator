import SageCellClient from "./sagecell.js";
import bico from '../assets/bico.py.sage?raw';
import { makeTmpNames, computeTmpLieBracket, replaceNamesCohomology, replaceNamesZigZags } from "./compute2.js";

const apiUrl = "http://127.0.0.1:5001/";

function zigzagout(z) {
  var newz = {};
  var ns = [];
  var ms = [];
  for (const [bd, _] of Object.entries(z)) {
    const bdt = bd
      .substring(1, bd.length - 1)
      .split(",")
      .map((s) => parseInt(s.trim()));
    ns.push(bdt[0]);
    ms.push(bdt[1]);
  }
  const nsmax = Math.max(...ns);
  const nsmin = Math.min(...ns);
  const msmax = Math.max(...ms);
  const msmin = Math.min(...ms);
  for (const [bd, v] of Object.entries(z)) {
    const bdt = bd
      .substring(1, bd.length - 1)
      .split(",")
      .map((s) => parseInt(s.trim()));
    const newbd = "(" + (bdt[0] - nsmin) + ", " + (bdt[1] - msmin) + ")";
    newz[newbd] = v;
  }
  return {
    n: nsmax - nsmin + 1,
    m: msmax - msmin + 1,
    z: newz,
  };
}

function computeZigzags(d) {
  let t = {};
  let nz = {};
  let ccc = 0;
  let cc = {};
  let cco = {};

  for (const z of d) {
    if (Object.keys(z).length == 1) {
      for (const [bd, v] of Object.entries(z)) {
        if (!t[bd]) {
          t[bd] = 0;
        }
        if (!nz[bd]) {
          nz[bd] = [];
        }
        nz[bd].push({
          value: v,
          del: "0",
          delbar: "0",
          type: "point",
        });
      }
    } else {
      let tt = {};
      let nzz = {};
      for (const [bd, v] of Object.entries(z)) {
        const bdt = bd
          .substring(1, bd.length - 1)
          .split(",")
          .map((s) => parseInt(s.trim()));
        // const diag = bdt[0] + bdt[1];
        if (!t[bd]) {
          t[bd] = 0;
        }
        tt[bd] = t[bd] + 1;
        if (!nzz[bd]) {
          nzz[bd] = [];
        }

        const delk = "(" + (bdt[0] + 1) + ", " + bdt[1] + ")";
        const delbark = "(" + bdt[0] + ", " + (bdt[1] + 1) + ")";
        if (delk in z && delbark in z) {
          if (
            cc[bd] === undefined &&
            cc[delk] === undefined &&
            cc[delbark] === undefined
          ) {
            cc[bd] = ccc;
            cc[delk] = ccc;
            cc[delbark] = ccc;
            cco[ccc] = [];
            cco[ccc].push(bd);
            cco[ccc].push(delk);
            cco[ccc].push(delbark);
            ccc++;
          } else if (cc[bd] === undefined && cc[delbark] === undefined) {
            cc[bd] = cc[delk];
            cc[delbark] = cc[delk];
            cco[cc[delk]].push(bd);
            cco[cc[delk]].push(delbark);
          } else if (cc[delk] === undefined && cc[delbark] === undefined) {
            cc[delk] = cc[bd];
            cc[delbark] = cc[bd];
            cco[cc[bd]].push(delk);
            cco[cc[bd]].push(delbark);
          } else if (cc[delk] === undefined && cc[bd] === undefined) {
            cc[delk] = cc[delbark];
            cc[bd] = cc[delbark];
            cco[cc[delbark]].push(delk);
            cco[cc[delbark]].push(bd);
          } else if (
            cc[bd] != undefined &&
            cc[delk] != undefined &&
            cc[delbark] != undefined &&
            cc[bd] != cc[delk] &&
            cc[bd] != cc[delbark] &&
            cc[delbark] != cc[delk]
          ) {
            cco[cc[bd]].concat(cco[cc[delk]]);
            cco[cc[bd]].concat(cco[cc[delbark]]);
            for (const bbbd of cco[cc[delk]]) {
              cc[bbbd] = cc[bd];
            }
            for (const bbbd of cco[cc[delbark]]) {
              cc[bbbd] = cc[bd];
            }
            delete cco[cc[delk]];
            delete cco[cc[delbark]];
          } else if (
            cc[bd] != undefined &&
            cc[delk] != undefined &&
            cc[bd] != cc[delk]
          ) {
            cco[cc[bd]].concat(cco[cc[delk]]);
            for (const bbbd of cco[cc[delk]]) {
              cc[bbbd] = cc[bd];
            }
            delete cco[cc[delk]];
            if (cc[delbark] === undefined) {
              cc[delbark] = cc[bd];
              cco[cc[bd]].push(delbark);
            }
          } else if (
            cc[bd] != undefined &&
            cc[delbark] != undefined &&
            cc[bd] != cc[delbark]
          ) {
            cco[cc[bd]].concat(cco[cc[delbark]]);
            for (const bbbd of cco[cc[delbark]]) {
              cc[bbbd] = cc[bd];
            }
            delete cco[cc[delbark]];
            if (cc[delk] === undefined) {
              cc[delk] = cc[bd];
              cco[cc[bd]].push(delk);
            }
          } else if (
            cc[delk] != undefined &&
            cc[delbark] != undefined &&
            cc[delbark] != cc[delk]
          ) {
            cco[cc[delk]].concat(cco[cc[delbark]]);
            for (const bbbd of cco[cc[delbark]]) {
              cc[bbbd] = cc[delk];
            }
            delete cco[cc[delbark]];
            if (cc[bd] === undefined) {
              cc[bd] = cc[delk];
              cco[cc[delk]].push(bd);
            }
          }
          nzz[bd] = {
            value: v,
            del: z[delk],
            delbar: z[delbark],
            type: "start",
            zigzag: zigzagout(z),
          };
        } else if (delk in z) {
          if (cc[bd] === undefined && cc[delk] === undefined) {
            cc[bd] = ccc;
            cc[delk] = ccc;
            cco[ccc] = [];
            cco[ccc].push(bd);
            cco[ccc].push(delk);
            ccc++;
          } else if (cc[bd] === undefined) {
            cc[bd] = cc[delk];
            cco[cc[delk]].push(bd);
          } else if (cc[delk] === undefined) {
            cc[delk] = cc[bd];
            cco[cc[bd]].push(delk);
          } else if (cc[bd] != cc[delk]) {
            cco[cc[bd]].concat(cco[cc[delk]]);
            for (const bbbd of cco[cc[delk]]) {
              cc[bbbd] = cc[bd];
            }
            delete cco[cc[delk]];
          }
          nzz[bd] = {
            value: v,
            del: z[delk],
            delbar: "0",
            type: "start",
            zigzag: zigzagout(z),
          };
        } else if (delbark in z) {
          if (cc[bd] === undefined && cc[delbark] === undefined) {
            cc[bd] = ccc;
            cc[delbark] = ccc;
            cco[ccc] = [];
            cco[ccc].push(bd);
            cco[ccc].push(delbark);
            ccc++;
          } else if (cc[bd] === undefined) {
            cc[bd] = cc[delbark];
            cco[cc[delbark]].push(bd);
          } else if (cc[delbark] === undefined) {
            cc[delbark] = cc[bd];
            cco[cc[bd]].push(delbark);
          } else if (cc[bd] != cc[delbark]) {
            cco[cc[bd]].concat(cco[cc[delbark]]);
            for (const bbbd of cco[cc[delbark]]) {
              cc[bbbd] = cc[bd];
            }
            delete cco[cc[delbark]];
          }
          nzz[bd] = {
            value: v,
            del: "0",
            delbar: z[delbark],
            type: "start",
            zigzag: zigzagout(z),
          };
        } else {
          nzz[bd] = {
            value: v,
            del: "0",
            delbar: "0",
            type: "end",
            zigzag: zigzagout(z),
          };
        }
      }
      const ttt = Object.keys(tt).map(function (key) {
        return tt[key];
      });
      const max = Math.max(...ttt);
      for (const [bd, v] of Object.entries(nzz)) {
        t[bd] = max;
        if (!nz[bd]) {
          nz[bd] = [];
        }
        nz[bd].push({
          value: v.value,
          del: v.del,
          delbar: v.delbar,
          type: v.type,
          zigzag: v.zigzag,
          order: max - 1,
        });
      }
    }
  }

  for (const z of d) {
    if (Object.keys(z).length != 1) {
      const ttt = Object.keys(z).map(function (key) {
        return t[key];
      });
      const max = Math.max(...ttt);
      for (const bd of Object.keys(z)) {
        t[bd] = max;
      }
    }
  }

  for (const [_, ccp] of Object.entries(cco)) {
    const ttt = ccp.map(function (key) {
      return t[key];
    });
    const max = Math.max(...ttt);
    for (const ccpp of ccp) {
      t[ccpp] = max;
    }
  }

  return {
    tracks: t,
    zigzags: nz,
  };
}

// // Make *any* div with class 'compute' a Sage cell
// sagecell.makeSagecell({inputLocation: 'div.compute',
//                         evalButtonText: 'Evaluate'})
// ;
// fetch("https://raw.githubusercontent.com/GeoTop-UB/BiCo/refs/heads/main/bigraded_complexes.py.sage")
// .then(function(response) {
//   response.text().then(function(text) {
//     var client = new SageClient({
//       onstatuschange: (status) => {
//         console.log("status change", status);
//         if (status == "connected") {
//           const id = crypto.randomUUID().replaceAll("-", "");
//           // client.sendCommand(id, "");
//           client.sendCommand(id, text);
//           client.sendCommand(id, "KT = BidifferentialBigradedCommutativeAlgebraExample.KodairaThurston()");
//           client.sendCommand(id, "KT._ascii_art_aeppli_cohomology()");
//         }
//       },
//       onmessage: (msg) => {
//         console.log("msg", msg);
//       },
//       onerror: (from, err) => {
//         console.log("err", from, err);
//       },
//       timeout: 30
//     });
//     client.connect();
//   });
// });

var client = new SageCellClient({
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

async function computeSageCell(dim, tmpNames, tmpLieBracket, acsMatrix, acsNorm) {
  if (!client.connected) {
    client.connect();
    // id = crypto.randomUUID().replaceAll("-", "");
    // client.config.onconnect = async () => {
    //   if (this.config.onconnect) await this.config.onconnect();
    //   await client.sendCommand(id, bico);
    // }
    await client.sendCommand(null, bico);
  }
  const norm = acsNorm != undefined? JSON.stringify(acsNorm) : "None";
  const computeCommand = `compute(${dim}, "${tmpNames.join(",")}", ${JSON.stringify(tmpLieBracket)}, ${JSON.stringify(acsMatrix)}, ${JSON.stringify(tmpNames)}, ${norm})`;
  console.log(computeCommand);
  const r = await client.sendCommand(null, computeCommand);
  return JSON.parse(r.data.substring(1, r.data.length - 1))
}

async function computeBackend(dim, tmpNames, tmpLieBracket, acsMatrix, acsNorm) {
  const response = await fetch(apiUrl, {
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
    method: "POST",
    body: JSON.stringify({
      dim: dim,
      lie: {
        names: tmpNames.join(","),
        bracket: tmpLieBracket,
      },
      acs: {
        names: tmpNames,
        matrix: acsMatrix,
        ...(acsNorm != undefined && { norm: acsNorm }),
      },
    }),
  });
  return response.json();
}

export async function compute(dim, lieBracket, acsNames, acsMatrix, acsNorm) {
  const tmpNames = makeTmpNames(dim);
  const tmpLieBracket = computeTmpLieBracket(lieBracket, tmpNames);
  console.log(dim);
  console.log(lieBracket);
  console.log(tmpLieBracket);
  console.log(acsNames);
  console.log(tmpNames);
  console.log(acsMatrix);
  console.log(acsNorm);
  // const d = await computeSageCell(dim, tmpNames, tmpLieBracket, acsMatrix, acsNorm);
  const d = await computeBackend(dim, tmpNames, tmpLieBracket, acsMatrix, acsNorm);
  const { tracks, zigzags } = computeZigzags(replaceNamesZigZags(tmpNames, acsNames, d.zigzags));
  return {
    n: d.n,
    m: d.m,
    cohomology_aeppli: replaceNamesCohomology(tmpNames, acsNames, d.cohomology.aeppli),
    cohomology_bottchern: replaceNamesCohomology(tmpNames, acsNames, d.cohomology.bottchern),
    cohomology_delbar: replaceNamesCohomology(tmpNames, acsNames, d.cohomology.delbar),
    cohomology_dell: replaceNamesCohomology(tmpNames, acsNames, d.cohomology.dell),
    cohomology_reduced_aeppli: replaceNamesCohomology(tmpNames, acsNames, d.cohomology.reduced_aeppli),
    cohomology_reduced_bottchern: replaceNamesCohomology(tmpNames, acsNames, d.cohomology.reduced_bottchern),
    zigzags: {
      basis: zigzags,
      tracks: tracks,
    },
    // "squares": d.squares
    squares: {
      basis: {},
      tracks: {},
    },
  };
}

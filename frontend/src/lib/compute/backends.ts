import SageCellClient from "./sagecell.js";
import type { ComputeBackend } from "./types";

// const version =
const apiUrl = "http://127.0.0.1:5001/";
const client = new SageCellClient({timeout: 30});
let bicoLib: string | undefined = undefined;

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
    if (bicoLib === undefined) {
      bicoLib = await import("$lib/assets/bico.py.sage?raw").then(m => m.default);
    }
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

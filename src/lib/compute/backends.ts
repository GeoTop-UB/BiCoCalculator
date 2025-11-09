import SageCellClient from "./sagecell.js";
import type { ComputeBackend } from "./types";
import { resolve } from "$app/paths";

import { PUBLIC_SAGECELL_TIMEOUT } from "$env/static/public";

// const version =
const apiUrl: string = resolve("/api/compute/");
const client = new SageCellClient({ timeout: PUBLIC_SAGECELL_TIMEOUT });
let bicoLib: string | undefined = undefined;

export const computeSelfhosted: ComputeBackend = async (
  varNames,
  lieBracket,
  acsMatrix,
  acsNorm
) => {
  try {
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
  } catch (_) {
    throw new Error("404 from backend");
  }
};

export const computeSageCell: ComputeBackend = async (varNames, lieBracket, acsMatrix, acsNorm) => {
  if (!client.connected) {
    client.connect();
    if (bicoLib === undefined) {
      bicoLib = await import("$lib/assets/bico.py.sage?raw").then((m) => m.default);
    }
    await client.sendCommand(null, bicoLib);
  }
  const sLieNames = varNames.join(",");
  const sLieBracket = JSON.stringify(lieBracket);
  const sAcsMatrix = JSON.stringify(acsMatrix);
  const sAcsNames = JSON.stringify(varNames);
  const sAcsNorm = acsNorm != undefined ? JSON.stringify(acsNorm) : "None";
  const command = `compute("${sLieNames}", ${sLieBracket}, ${sAcsMatrix}, ${sAcsNames}, ${sAcsNorm})`;
  const r = await client.sendCommand(null, command);
  return r.data.substring(1, r.data.length - 1);
};

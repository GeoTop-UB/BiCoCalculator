import hash from "object-hash";

import type { Cohomology, ComputeBackend, LieBrackets, ZigZag } from "./types";
import { computeSageCell, computeSelfhosted } from "./backends";
import {
  computeTmpLieBracket,
  makeTmpNames,
  replaceNamesCohomology,
  replaceNamesZigZags,
  computeZigzags
} from "./utils";
import { PUBLIC_ADAPTER, PUBLIC_COMPUTATION_TIME_MIN } from "$env/static/public";

// @ts-ignore
import ktResult from "../precomputations/KT_Result.json?raw";
// @ts-ignore
import iwResult from "../precomputations/IW_Result.json?raw";

interface NamedBackends {
  [backend: string]: ComputeBackend;
}
const computeBackends: NamedBackends = {
  selfHosted: computeSelfhosted,
  sageCell: computeSageCell
};

interface PrecomputedExamples {
  [hash: string]: string;
}
const precomputedExamples: PrecomputedExamples = {
  f98765fc914692d6fd1b4062b72ecce95fedec43: ktResult, // Kodaira-Thurston
  "52be107def827888912cd0de7b3e80df05471a5f": iwResult // Iwasawa
};

interface ComputationResult {
  n: number;
  m: number;
  cohomology: {
    dell: Cohomology;
    delbar: Cohomology;
    bottchern: Cohomology;
    aeppli: Cohomology;
    reduced_aeppli: Cohomology;
    reduced_bottchern: Cohomology;
  };
  zigzags: ZigZag[];
  squares: ZigZag[];
}

async function computeCanonical(
  varNames: string[],
  lieBracket: LieBrackets,
  acsMatrix: number[][],
  acsNorm?: number[]
): Promise<ComputationResult> {
  const isStatic = PUBLIC_ADAPTER === "static";
  const enableCache = isStatic;
  const backend: string = isStatic? "sageCell" : "selfHosted";
  if (!Object.keys(computeBackends).includes(backend)) {
    throw new Error(
      `Invalid compute backend: ${backend} is not one of the available backends ${JSON.stringify(Object.keys(computeBackends))}`
    );
  }

  var result: string | null = null;
  if (!enableCache) {
    console.log(`No cache enabled, computed in backend: ${backend}`);
    result = await computeBackends[backend](varNames, lieBracket, acsMatrix, acsNorm);
  } else{
    const inputHash: string = hash({
      varNames: varNames,
      lieBracket: lieBracket,
      acsMatrix: acsMatrix,
      ...(acsNorm != undefined && { acsNorm: acsNorm })
    });
    result = window.localStorage.getItem(inputHash);
    if (result === null) {
      if (inputHash in precomputedExamples) {
        console.log("Precomputed at the server");
        result = precomputedExamples[inputHash];
      } else {
        console.log(`Computed in backend: ${backend}`);
        result = await computeBackends[backend](varNames, lieBracket, acsMatrix, acsNorm);
      }
      window.localStorage.setItem(inputHash, result);
    } else {
      console.log("Cached in local storage");
    }
  }

  return JSON.parse(result.replaceAll("\'", '"'));
}

export async function compute(
  dim: number,
  lieBracket: LieBrackets,
  acsNames: string[],
  acsMatrix: number[][],
  acsNorm?: number[]
) {
  const tmpNames = makeTmpNames(dim);
  const tmpLieBracket = computeTmpLieBracket(lieBracket, tmpNames);
  const d = await Promise.all([
    computeCanonical(tmpNames, tmpLieBracket, acsMatrix, acsNorm),
    new Promise((resolve, _) => { 
      setTimeout(resolve, PUBLIC_COMPUTATION_TIME_MIN, "Mininum timeout ended!");
    })
  ]).then((result) => result[0]);
  return {
    n: d.n,
    m: d.m,
    cohomology_aeppli: replaceNamesCohomology(tmpNames, acsNames, d.cohomology.aeppli),
    cohomology_bottchern: replaceNamesCohomology(tmpNames, acsNames, d.cohomology.bottchern),
    cohomology_delbar: replaceNamesCohomology(tmpNames, acsNames, d.cohomology.delbar),
    cohomology_dell: replaceNamesCohomology(tmpNames, acsNames, d.cohomology.dell),
    cohomology_reduced_aeppli: replaceNamesCohomology(
      tmpNames,
      acsNames,
      d.cohomology.reduced_aeppli
    ),
    cohomology_reduced_bottchern: replaceNamesCohomology(
      tmpNames,
      acsNames,
      d.cohomology.reduced_bottchern
    ),
    zigzags: computeZigzags(replaceNamesZigZags(tmpNames, acsNames, d.zigzags)),
    // "squares": d.squares
    squares: {
      basis: {},
      tracks: {}
    }
  };
}

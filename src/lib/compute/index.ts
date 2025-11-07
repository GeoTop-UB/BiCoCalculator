import hash from "object-hash";

import type {
  ComputationResult,
  CanonicalInput,
  Input,
  SerializableInput,
  NamedBackends,
  Data,
  Cohomology
} from "./types";
export type { Input, SerializableInput, ComputationResult, Data } from "./types";
import { computeSageCell, computeSelfhosted } from "./backends";
import {
  computeTmpLieBracket,
  makeTmpNames,
  replaceNamesCohomology,
  replaceNamesZigZags,
  computeZigzags
} from "./utils";
import {
  PUBLIC_ADAPTER,
  PUBLIC_COMPUTATION_TIME_MIN,
  PUBLIC_CACHE,
  PUBLIC_PRECOMPUTED_EXAMPLES
} from "$env/static/public";

import ktResult from "$lib/precomputations/KT_Result.json?raw";
import ktHash from "$lib/precomputations/KT_Hash.txt?raw";
import iwResult from "$lib/precomputations/IW_Result.json?raw";
import iwHash from "$lib/precomputations/IW_Hash.txt?raw";
import jnResult from "$lib/precomputations/JN_Result.json?raw";
import jnHash from "$lib/precomputations/JN_Hash.txt?raw";

// export const enum ExamplesID {
//   KT = "KT",
//   IW = "IW",
//   // JN = "JN"
// }
export const ExamplesID = {
  KT: "KT",
  IW: "IW",
  JN: "JN"
} as const;
export type ExamplesID = (typeof ExamplesID)[keyof typeof ExamplesID];
interface PrecomputedExamples {
  [hash: string]: {
    id: ExamplesID;
    result: string;
  };
}
export const precomputedExamples: PrecomputedExamples = {
  [ktHash]: {
    // Kodaira-Thurston
    id: ExamplesID.KT,
    result: ktResult
  },
  [iwHash]: {
    // Iwasawa
    id: ExamplesID.IW,
    result: iwResult
  },
  [jnHash]: {
    // Jonas
    id: ExamplesID.JN,
    result: jnResult
  }
};
const computeBackends: NamedBackends = {
  selfHosted: computeSelfhosted,
  sageCell: computeSageCell
};

function serializeInput(input: Input): SerializableInput {
  return {
    lie: {
      bracket: input.lie.bracket
    },
    acs: {
      matrix: input.acs.matrix,
      ...(input.acs.norm != undefined && { norm: input.acs.norm })
    }
  };
}

function makeCanonical(input: Input): CanonicalInput {
  const tmpNames = makeTmpNames(input.dim);
  const tmpLieBracket = computeTmpLieBracket(input.lie.bracket, tmpNames);
  return {
    varNames: tmpNames,
    lie: {
      bracket: tmpLieBracket
    },
    acs: {
      matrix: input.acs.matrix,
      ...(input.acs.norm != undefined && { norm: input.acs.norm })
    }
  };
}

export function hashFullInput(input: Input): string {
  return hash(input);
}

export function hashInput(input: Input): string {
  return hash(serializeInput(input));
}

async function computeCanonical(cInput: CanonicalInput, inputHash: string): Promise<string> {
  const isStatic = PUBLIC_ADAPTER === "static";
  const precomputations = PUBLIC_PRECOMPUTED_EXAMPLES == "true";
  const backend: string = isStatic ? "sageCell" : "selfHosted";
  if (!Object.keys(computeBackends).includes(backend)) {
    throw new Error(
      `Invalid compute backend: ${backend} is not one of the available backends ${JSON.stringify(Object.keys(computeBackends))}`
    );
  }

  if (precomputations && inputHash in precomputedExamples) {
    console.log("Precomputed at the server");
    return precomputedExamples[inputHash].result;
  } else {
    console.log(`Computed in backend: ${backend}`);
    return await computeBackends[backend](
      cInput.varNames,
      cInput.lie.bracket,
      cInput.acs.matrix,
      cInput.acs.norm
    );
  }
}

export function processResult(input: Input, result: ComputationResult): Data {
  const tmpNames = makeTmpNames(input.dim);
  const replaceNames = (cohomology: Cohomology) => {
    return replaceNamesCohomology(tmpNames, input.acs.names, cohomology);
  };
  return {
    n: result.n,
    m: result.m,
    cohomology_aeppli: replaceNames(result.cohomology.aeppli),
    cohomology_bottchern: replaceNames(result.cohomology.bottchern),
    cohomology_delbar: replaceNames(result.cohomology.delbar),
    cohomology_dell: replaceNames(result.cohomology.dell),
    cohomology_reduced_aeppli: replaceNames(result.cohomology.reduced_aeppli),
    cohomology_reduced_bottchern: replaceNames(result.cohomology.reduced_bottchern),
    zigzags: computeZigzags(replaceNamesZigZags(tmpNames, input.acs.names, result.zigzags)),
    // "squares": d.squares
    squares: {
      basis: {},
      tracks: {}
    }
  };
}

async function _compute(input: Input): Promise<ComputationResult> {
  const enableCache = PUBLIC_CACHE === "true";
  const inputHash: string = hashInput(input);
  // console.log(`Input has hash: ${inputHash}`);

  let result: string | null = null;
  if (enableCache) {
    console.log("Cache enabled");
    result = window.localStorage.getItem(inputHash);
  } else {
    console.log("No cache enabled");
  }

  if (result === null) {
    result = await computeCanonical(makeCanonical(input), inputHash);
    if (enableCache) {
      window.localStorage.setItem(inputHash, result);
    }
  } else {
    console.log("Cached in local storage");
  }
  return {
    hash: inputHash,
    ...JSON.parse(result)
  };
}

export async function compute(input: Input): Promise<ComputationResult> {
  return Promise.all([
    _compute(input),
    new Promise((resolve, _) => {
      setTimeout(resolve, parseInt(PUBLIC_COMPUTATION_TIME_MIN), "Mininum timeout ended!");
    })
  ]).then((result) => result[0]);
}

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
import { PUBLIC_ADAPTER, PUBLIC_COMPUTATION_TIME_MIN, PUBLIC_CACHE, PUBLIC_PRECOMPUTED_EXAMPLES } from "$env/static/public";

import ktResult from "$lib/precomputations/KT_Result.json?raw";
import ktHash from "$lib/precomputations/KT_Hash.txt?raw";
import iwResult from "$lib/precomputations/IW_Result.json?raw";
import iwHash from "$lib/precomputations/IW_Hash.txt?raw";
import jnResult from "$lib/precomputations/JN_Result.json?raw";
import jnHash from "$lib/precomputations/JN_Hash.txt?raw";

interface Input {
  dim: number;
  lie: {
    names: string[];
    bracket: LieBrackets;
  };
  acs: {
    names: string[];
    matrix: number[][];
    norm?: number[];
  };
}

interface NamedBackends {
  [backend: string]: ComputeBackend;
}
const computeBackends: NamedBackends = {
  selfHosted: computeSelfhosted,
  sageCell: computeSageCell
};

interface PrecomputedExamples {
  [hash: string]: {
    id: string;
    result: string;
  };
}
const precomputedExamples: PrecomputedExamples = {
  [ktHash]: {
    // Kodaira-Thurston
    id: "KT",
    result: ktResult
  },
  [iwHash]: {
    // Iwasawa
    id: "IW",
    result: iwResult
  },
  [jnHash]: {
    // Jonas
    id: "JN",
    result: jnResult
  }
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
  const precomputations = PUBLIC_PRECOMPUTED_EXAMPLES == "true";
  const backend: string = isStatic ? "sageCell" : "selfHosted";
  if (!Object.keys(computeBackends).includes(backend)) {
    throw new Error(
      `Invalid compute backend: ${backend} is not one of the available backends ${JSON.stringify(Object.keys(computeBackends))}`
    );
  }

  if (precomputations && inputHash in precomputedExamples) {
}

export function findExample(input: Input): string | null {
  const tmpNames = makeTmpNames(input.dim);
  const tmpLieBracket = computeTmpLieBracket(input.lie.bracket, tmpNames);
  const inputHash: string = hash({
    varNames: tmpNames,
    lieBracket: tmpLieBracket,
    acsMatrix: input.acs.matrix,
    ...(input.acs.norm != undefined && { acsNorm: input.acs.norm })
  });
  if (inputHash in precomputedExamples) {
    return precomputedExamples[inputHash].id;
  } else {
    return null;
  }
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

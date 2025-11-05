export interface LieBracket {
  [result: string]: number;
}

export interface LieBrackets {
  [bidegree: string]: LieBracket;
}

export interface Cohomology {
  [bidegree: string]: string[];
}

export interface ZigZag {
  [bidegree: string]: string;
}

export interface LocatedZigZag {
  m: number;
  n: number;
  z: ZigZag;
}

export interface ZigZagBasis {
  value: string;
  type: string;
  del: string;
  delbar: string;
  order?: number;
  zigzag?: LocatedZigZag;
}

export interface ZigZagsTracks {
  [bidegree: string]: number;
}

export interface ZigZagsBasis {
  [bidegree: string]: ZigZagBasis[];
}

export interface PostZigZag {
  tracks: ZigZagsTracks;
  basis: ZigZagsBasis;
}

export interface Input {
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

export interface SerializableInput {
  lie: {
    bracket: LieBrackets;
  };
  acs: {
    matrix: number[][];
    norm?: number[];
  };
}

export interface CanonicalInput {
  varNames: string[];
  lie: {
    bracket: LieBrackets;
  };
  acs: {
    matrix: number[][];
    norm?: number[];
  };
}

export interface ComputationResult {
  hash: string
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

export interface Data {
  n: number;
  m: number;
  cohomology_dell: Cohomology;
  cohomology_delbar: Cohomology;
  cohomology_bottchern: Cohomology;
  cohomology_aeppli: Cohomology;
  cohomology_reduced_aeppli: Cohomology;
  cohomology_reduced_bottchern: Cohomology;
  zigzags: PostZigZag;
  squares: PostZigZag;
}

export type ComputeBackend = (
  varNames: string[],
  lieBracket: LieBrackets,
  acsMatrix: number[][],
  acsNorm?: number[]
) => Promise<string>;

export interface NamedBackends {
  [backend: string]: ComputeBackend;
}

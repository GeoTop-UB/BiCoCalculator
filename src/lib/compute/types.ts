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

export type ComputeBackend = (
  varNames: string[],
  lieBracket: LieBrackets,
  acsMatrix: number[][],
  acsNorm?: number[]
) => Promise<string>;

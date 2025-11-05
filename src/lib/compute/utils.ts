import type { Cohomology, LieBracket, LieBrackets, ZigZag, PostZigZag, ZigZagBasis, ZigZagsTracks, LocatedZigZag, ZigZagsBasis } from "./types";

interface ZigZagsBasis2 {
  [bidegree: string]: ZigZagBasis;
}

interface CC {
  [bidegree: string]: number;
}

interface CCO {
  [idConnectedComponent: number]: string[];
}

export function makeTmpNames(dim: number): string[] {
  return [...Array(dim).keys()].map((i) => `v${i}`);
}

export function computeTmpLieBracket(lieBracket: LieBrackets, tmpNames: string[]): LieBrackets {
  return Object.keys(lieBracket).reduce(function (result: LieBrackets, key: string) {
    const bd = key
      .substring(1, key.length - 1)
      .split(",")
      .map((b) => parseInt(b.trim()));
    const newKey = `${tmpNames[bd[0] - 1]},${tmpNames[bd[1] - 1]}`;
    result[newKey] = Object.keys(lieBracket[key]).reduce(function (
      result2: LieBracket,
      key2: string
    ) {
      const newKey2 = tmpNames[parseInt(key2) - 1];
      result2[newKey2] = lieBracket[key][key2];
      return result2;
    }, {});
    return result;
  }, {});
}

function replaceNames(tmpNames: string[], displayNames: string[], formula: string): string {
  if (tmpNames.length != displayNames.length) {
    throw new Error("Number of temporal and display names of variables does not match");
  }

  var newFormula = formula;
  for (const i of [...Array(tmpNames.length).keys()]) {
    newFormula = newFormula.replaceAll(tmpNames[i], displayNames[i]);
  }
  newFormula = newFormula.replaceAll("-", "\\textup{\\texttt{-}}");
  newFormula = newFormula.replaceAll("+", "\\textup{\\texttt{+}}");
  newFormula = newFormula.replaceAll("*", " ");
  return newFormula;
}

export function replaceNamesCohomology(
  tmpNames: string[],
  displayNames: string[],
  cohomology: Cohomology
): Cohomology {
  return Object.keys(cohomology).reduce(function (result: Cohomology, key: string) {
    result[key] = cohomology[key].map((formula) => replaceNames(tmpNames, displayNames, formula));
    return result;
  }, {});
}

export function replaceNamesZigZags(
  tmpNames: string[],
  displayNames: string[],
  zigzags: ZigZag[]
): ZigZag[] {
  return zigzags.map((zigzag) =>
    Object.keys(zigzag).reduce(function (result: ZigZag, key: string) {
      result[key] = replaceNames(tmpNames, displayNames, zigzag[key]);
      return result;
    }, {})
  );
}

function zigzagout(z: ZigZag): LocatedZigZag {
  var newz: ZigZag = {};
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
    z: newz
  };
}

function mergeCCs(cc: CC, cco: CCO, bda: string, bdb: string) {
  const ccbdb = cc[bdb];
  cco[cc[bda]] = cco[cc[bda]].concat(cco[ccbdb]);
  for (const bbbd of cco[ccbdb]) {
    cc[bbbd] = cc[bda];
  }
  delete cco[ccbdb];
}

export function computeZigzags(d: ZigZag[]): PostZigZag {
  let t: ZigZagsTracks = {};
  let nz: ZigZagsBasis = {};
  let ccc = 0;
  let cc: CC = {};
  let cco: CCO = {};

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
          type: "point"
        });
      }
    } else {
      let tt: ZigZagsTracks = {};
      let nzz: ZigZagsBasis2 = {};
      for (const [bd, v] of Object.entries(z)) {
        const bdt = bd
          .substring(1, bd.length - 1)
          .split(",")
          .map((s) => parseInt(s.trim()));
        if (!t[bd]) {
          t[bd] = 0;
        }
        tt[bd] = t[bd] + 1;

        const delk = "(" + (bdt[0] + 1) + ", " + bdt[1] + ")";
        const delbark = "(" + bdt[0] + ", " + (bdt[1] + 1) + ")";
        if (delk in z && delbark in z) {
          if (cc[bd] === undefined && cc[delk] === undefined && cc[delbark] === undefined) {
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
            mergeCCs(cc, cco, bd, delk);
            mergeCCs(cc, cco, bd, delbark);
          } else if (cc[bd] != undefined && cc[delk] != undefined && cc[bd] != cc[delk]) {
            mergeCCs(cc, cco, bd, delk);
            if (cc[delbark] === undefined) {
              cc[delbark] = cc[bd];
              cco[cc[bd]].push(delbark);
            }
          } else if (cc[bd] != undefined && cc[delbark] != undefined && cc[bd] != cc[delbark]) {
            mergeCCs(cc, cco, bd, delbark);
            if (cc[delk] === undefined) {
              cc[delk] = cc[bd];
              cco[cc[bd]].push(delk);
            }
          } else if (cc[delk] != undefined && cc[delbark] != undefined && cc[delbark] != cc[delk]) {
            mergeCCs(cc, cco, delk, delbark);
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
            zigzag: zigzagout(z)
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
            mergeCCs(cc, cco, bd, delk);
          }
          nzz[bd] = {
            value: v,
            del: z[delk],
            delbar: "0",
            type: "start",
            zigzag: zigzagout(z)
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
            mergeCCs(cc, cco, bd, delbark);
          }
          nzz[bd] = {
            value: v,
            del: "0",
            delbar: z[delbark],
            type: "start",
            zigzag: zigzagout(z)
          };
        } else {
          nzz[bd] = {
            value: v,
            del: "0",
            delbar: "0",
            type: "end",
            zigzag: zigzagout(z)
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
          order: max - 1
        });
      }
    }
  }

  for (const z of d) {
    if (Object.keys(z).length != 1) {
      const ttt = Object.keys(z).map(function (key: string) {
        return t[key];
      });
      const max = Math.max(...ttt);
      for (const bd of Object.keys(z)) {
        t[bd] = max;
      }
    }
  }

  for (const [_, ccp] of Object.entries(cco)) {
    const ttt = ccp.map(function (key: string) {
      return t[key];
    });
    const max = Math.max(...ttt);
    for (const ccpp of ccp) {
      t[ccpp] = max;
    }
  }

  return {
    tracks: t,
    basis: nz
  };
}

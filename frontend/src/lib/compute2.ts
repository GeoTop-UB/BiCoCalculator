
interface LieBracket {
    [bidegree: string]: {
        [result: string]: number   
    }
}

interface Cohomology {
    [bidegree: string]: string[]
}

interface ZigZag {
    [bidegree: string]: string
}

export function makeTmpNames(dim: number): string[] {
  return [...Array(dim).keys()].map(i => `v${i}`);
}

export function computeTmpLieBracket(lieBracket: LieBracket, tmpNames: string[]): LieBracket {
  return Object.keys(lieBracket).reduce(function(result, key) {
    const bd = key.substring(1, key.length - 1).split(",").map((b) => parseInt(b.trim()));
    const newKey = `${tmpNames[bd[0] - 1]},${tmpNames[bd[1] - 1]}`; 
    result[newKey] = Object.keys(lieBracket[key]).reduce(function(result2, key2) {
      const newKey2 = tmpNames[parseInt(key2) - 1];
      result2[newKey2] = lieBracket[key][key2];
      return result2;
    }, {});
    return result;
  }, {})
}

export function replaceNames(tmpNames: string[], displayNames: string[], formula: string): string {
  if (tmpNames.length != displayNames.length) {
    throw new Error("Number of temporal and display names of variables does not match");
  }

  var newFormula = formula;
  for (const i of [...Array(tmpNames.length).keys()]) {
    newFormula = newFormula.replaceAll(tmpNames[i], displayNames[i]);
  }
  newFormula = newFormula.replaceAll("-", "\\textup{\\texttt{-}}");
  newFormula = newFormula.replaceAll("+", "\\textup{\\texttt{+}}");
  newFormula = newFormula.replaceAll("*", "");
  return newFormula;
}

export function replaceNamesCohomology(tmpNames, displayNames, cohomology: Cohomology): Cohomology {
  return Object.keys(cohomology).reduce(function(result, key) {
    result[key] = cohomology[key].map(formula => replaceNames(tmpNames, displayNames, formula));
    return result;
  }, {});
}

export function replaceNamesZigZags(tmpNames, displayNames, zigzags: ZigZag[]): ZigZag[] {
  return zigzags.map(zigzag => Object.keys(zigzag).reduce(function(result, key) {
    result[key] = replaceNames(tmpNames, displayNames, zigzag[key]);
    return result;
  }, {}));
}

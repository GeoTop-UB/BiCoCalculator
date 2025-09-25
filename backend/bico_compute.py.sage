#!/usr/bin/env -S sage --python
import json
from pprint import pprint

from sage.all import *

# load("backend/bigraded_complexes.py.sage")
load("https://raw.githubusercontent.com/GeoTop-UB/BiCo/refs/heads/main/bigraded_complexes.py.sage")


def compute():
    # - request -
    # content_length = self.headers['Content-Length']
    # if content_length:
    #     content_length = int(content_length)
    #     input_json = self.rfile.read(content_length)
    #     input_data = json.loads(input_json)
    # else:
    #     input_data = None
    # print(input_data)
    
    # # - response -
    # self.send_response(200)
    # self.send_header('Content-type', 'application/json')
    # self.send_header('Access-Control-Allow-Origin', '*')
    # self.end_headers()

    # def build(dim, lie_names, lie_bracket, acs_matrix, acs_names, normalization_coefficients=None):
    #     bfield = QuadraticField(-1, 'I')

    #     lie_algebra = LieAlgebra(bfield, lie_names, lie_bracket)
    #     acs = Matrix(bfield, dim, acs_matrix)

    #     return BidifferentialBigradedCommutativeAlgebra.from_nilmanifold(lie_algebra, acs, acs_names, normalization_coefficients)
    
    # dim = input_data["dim"]
    # tmp_names = [f"v{i}" for i in range(dim)]
    # # lie_names_final = input_data["lie"]["names"]
    # lie_names = ",".join(tmp_names)
    # lie_bracket = {
    #     tuple(map(lambda i: tmp_names[int(i) - 1], k[1:-1].split(","))): {
    #         tmp_names[int(kk) - 1]: vv
    #         for kk, vv in v.items()
    #     }
    #     for k, v in input_data["lie"]["bracket"].items()
    # }
    # acs_matrix = input_data["acs"]["matrix"]
    # acs_names_final = input_data["acs"]["names"]
    # acs_names = tmp_names
    # normalization_coefficients= list(map(QQ, input_data["acs"].get("norm"))) if input_data["acs"].get("norm") else None
    # pprint(dim)
    # pprint(lie_names)
    # pprint(lie_bracket)
    # pprint(acs_matrix)
    # pprint(acs_names)
    # pprint(normalization_coefficients)
    
    bbc = BidifferentialBigradedCommutativeAlgebraExample.KodairaThurston()
    # bbc = BidifferentialBigradedCommutativeAlgebraExample.Iwasawa()
    # dim = bbc.

    def replaceNames(s: str):
        # for i in range(dim):
        #     s = s.replace(tmp_names[i], acs_names_final[i])
        
        s = s.replace("-", "\\textup{\\texttt{-}}")
        s = s.replace("+", "\\textup{\\texttt{+}}")
        s = s.replace("*", "")
        return s

    def mapByBidegree(bbc : BigradedComplex, method: str):
        return {
            str(bidegree): list(map(lambda a: replaceNames(str(a)), getattr(bbc, method)(bidegree)))
            for bidegree in bbc.bidegrees()
        }
    
    def replaceNamesZigzags(a):
        return {
            str(bidegree): replaceNames(str(v))
            for (bidegree, v) in a.items()
        }

    # bbc = build(dim, lie_names, lie_bracket, acs_matrix, acs_names, normalization_coefficients)
    output_data = {
        "n": max(map(lambda t: t[0], bbc.dimension().keys())) + 1,
        "m": max(map(lambda t: t[1], bbc.dimension().keys())) + 1,
        "cohomology": {
            cohomology: mapByBidegree(bbc, f"{cohomology}_cohomology_basis")
            for cohomology in [
                "dell",
                "delbar",
                "bottchern",
                "aeppli",
                "reduced_aeppli",
                "reduced_bottchern"
            ]
        },
        "zigzags": list(map(lambda a: replaceNamesZigzags(a), bbc.zigzags_decomposition())),
        "squares": list(map(lambda a: replaceNames(str(a)), bbc.squares_decomposition()))
    }
    pprint(output_data)
    output_json = json.dumps(output_data)
    
    return output_json


if __name__ == "__main__":
    print(compute())

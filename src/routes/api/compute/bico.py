#!/usr/bin/env -S sage --python
import argparse
import json
import sys

from sage.all import *

# load("https://raw.githubusercontent.com/GeoTop-UB/BiCo/refs/heads/main/bigraded_complexes.py.sage")
load("src/lib/assets/bico.py.sage")


def build(lie_names, lie_bracket, acs_matrix, acs_names, acs_norm=None):
    bfield = QuadraticField(-1, 'I')

    lie_algebra = LieAlgebra(bfield, lie_names, lie_bracket)
    acs = Matrix(bfield, len(acs_names), acs_matrix)

    return BidifferentialBigradedCommutativeAlgebra.from_nilmanifold(lie_algebra, acs, acs_names, acs_norm)


def compute(lie_names, lie_bracket, acs_matrix, acs_names, acs_norm):
    lie_bracket = {tuple(k.split(",")): v for  k, v in lie_bracket.items()}
    acs_norm= list(map(QQ, acs_norm)) if acs_norm else None

    bbc = build(lie_names, lie_bracket, acs_matrix, acs_names, acs_norm)
    output_data = {
        "n": max(map(lambda t: t[0], bbc.dimension().keys())) + 1,
        "m": max(map(lambda t: t[1], bbc.dimension().keys())) + 1,
        "cohomology": {
            cohomology: {
                str(bidegree): list(map(lambda a: str(a), getattr(bbc, f"{cohomology}_cohomology_basis")(bidegree)))
                for bidegree in bbc.bidegrees()
            }
            for cohomology in [
                "dell",
                "delbar",
                "bottchern",
                "aeppli",
                "reduced_aeppli",
                "reduced_bottchern"
            ]
        },
        "zigzags": list(map(lambda a: {str(bidegree): str(v) for (bidegree, v) in a.items()}, bbc.zigzags_decomposition())),
        "squares": list(map(lambda a: str(a), bbc.squares_decomposition()))
    }
    return json.dumps(output_data)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("input", help="Input complex manifold to compute the BiCo results")
    args = parser.parse_args()
    input = json.loads(args.input)

    print(compute(
        input["lie"]["names"],
        input["lie"]["bracket"],
        input["acs"]["matrix"],
        input["acs"]["names"],
        input["acs"].get("norm")
    ))
    sys.stdout.flush()

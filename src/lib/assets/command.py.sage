
def build(lie_names, lie_bracket, acs_matrix, acs_names, normalization_coefficients=None):
    bfield = QuadraticField(-1, 'I')

    lie_algebra = LieAlgebra(bfield, lie_names, lie_bracket)
    acs = Matrix(bfield, len(acs_names), acs_matrix)

    return BidifferentialBigradedCommutativeAlgebra.from_nilmanifold(lie_algebra, acs, acs_names, normalization_coefficients)

def mapByBidegree(bbc : BigradedComplex, method: str):
    return {
        str(bidegree): list(map(lambda a: str(a), getattr(bbc, method)(bidegree)))
        for bidegree in bbc.bidegrees()
    }

def compute(lie_names, lie_bracket, acs_matrix, acs_names, norm):
    import json
    lie_bracket = {tuple(k.split(",")): v for  k, v in lie_bracket.items()}
    normalization_coefficients = list(map(QQ, norm)) if norm else None
    bbc = build(lie_names, lie_bracket, acs_matrix, acs_names, normalization_coefficients)
    return json.dumps({
        "n": int(max(map(lambda t: t[0], bbc.dimension().keys())) + 1),
        "m": int(max(map(lambda t: t[1], bbc.dimension().keys())) + 1),
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
        "zigzags": list(map(lambda a: {str(bidegree): str(v) for (bidegree, v) in a.items()}, bbc.zigzags_decomposition())),
        "squares": list(map(lambda a: {str(bidegree): str(v) for (bidegree, v) in a.items()}, bbc.squares_decomposition()))
    })

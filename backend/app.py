import http.server
import socketserver
import json
from pprint import pprint

from sage.all import *

# load("backend/bigraded_complexes.py.sage")
load("https://raw.githubusercontent.com/GeoTop-UB/BiCo/32aa81b039afa3ccbbb866702d1e34c0f6b288b4/bigraded_complexes.py.sage")

PORT = 5001


class MyHandler(http.server.SimpleHTTPRequestHandler):
    
    def do_POST(self):
        # - request -
        content_length = self.headers['Content-Length']
        if content_length:
            content_length = int(content_length)
            input_json = self.rfile.read(content_length)
            input_data = json.loads(input_json)
        else:
            input_data = None
        print(input_data)
        
        # - response -
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()

        def build(dim, lie_names, lie_bracket, acs_matrix, acs_names, normalization_coefficients=None):
            bfield = QuadraticField(-1, 'I')

            lie_algebra = LieAlgebra(bfield, lie_names, lie_bracket)
            acs = Matrix(bfield, dim, acs_matrix)

            return BidifferentialBigradedCommutativeAlgebra.from_nilmanifold(lie_algebra, acs, acs_names, normalization_coefficients)
        
        dim = input_data["dim"]
        tmp_names = [f"v{i}" for i in range(dim)]
        # lie_names_final = input_data["lie"]["names"]
        lie_names = ",".join(tmp_names)
        lie_bracket = {
            tuple(map(lambda i: tmp_names[int(i) - 1], k[1:-1].split(","))): {
                tmp_names[int(kk) - 1]: vv
                for kk, vv in v.items()
            }
            for k, v in input_data["lie"]["bracket"].items()
        }
        acs_matrix = input_data["acs"]["matrix"]
        acs_names_final = input_data["acs"]["names"]
        acs_names = tmp_names
        normalization_coefficients= list(map(QQ, input_data["acs"].get("norm"))) if input_data["acs"].get("norm") else None
        pprint(dim)
        pprint(lie_names)
        pprint(lie_bracket)
        pprint(acs_matrix)
        pprint(acs_names)
        pprint(normalization_coefficients)

        def replaceNames(s: str):
            for i in range(dim):
                s = s.replace(tmp_names[i], acs_names_final[i])
            
            s = s.replace("*", "")
            return s

        def mapByBidegree(bbc : BigradedComplex, method: str):
            return {
                str(bidegree): list(map(lambda a: replaceNames(str(a)), getattr(bbc, method)(bidegree)))
                for bidegree in bbc.bidegrees()
            }

        bbc = build(dim, lie_names, lie_bracket, acs_matrix, acs_names, normalization_coefficients)
        # bbc = BidifferentialBigradedCommutativeAlgebraExample.KodairaThurston()
        # bbc = BidifferentialBigradedCommutativeAlgebraExample.Iwasawa()
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
            # TODO
            # "zigzags": mapByBidegree(bbc, "zigzags_basis"),
            "zigzags": mapByBidegree(bbc, "squares_basis"),
            "squares": mapByBidegree(bbc, "squares_basis")
        }
        pprint(output_data)
        output_json = json.dumps(output_data)
        
        self.wfile.write(output_json.encode('utf-8'))


with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
    try:
        print(f"Starting http://0.0.0.0:{PORT}")
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("Stopping by Ctrl+C")
    finally:
        httpd.server_close()

# from flask import Flask
# from flask_cors import CORS, cross_origin

# app = Flask(__name__)
# cors = CORS(app) # allow CORS for all domains on all routes.
# app.config['CORS_HEADERS'] = 'Content-Type'

# @app.route("/")
# @cross_origin()
# def hello():
#     return {
#         "message": "Nix!",
#     }

# def run():
#     app.run(host="0.0.0.0", port=5001)

# if __name__ == "__main__":
#     run()
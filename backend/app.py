import http.server
import socketserver
import json

from sage.all import *

# load("backend/bigraded_complexes.py.sage")
load("https://raw.githubusercontent.com/GeoTop-UB/BiCo/32aa81b039afa3ccbbb866702d1e34c0f6b288b4/bigraded_complexes.py.sage")


PORT = 5001

class MyHandler(http.server.SimpleHTTPRequestHandler):
    
    def do_GET(self):
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

        KT = BidifferentialBigradedCommutativeAlgebraExample.KodairaThurston()
        output_data = {
            'status': 'OK', 
            'result': 'HELLO WORLD!',
            "message": "Nix!",
            # "aeppli": KT._ascii_art_aeppli_cohomology()
            "aeppli_dict": {str(bidegree): str(KT.delbar_cohomology_basis(bidegree)) for bidegree in KT.bidegrees()},
            "aeppli": str({bidegree: KT.delbar_cohomology_basis(bidegree) for bidegree in KT.bidegrees()}[(1, 1)])
        }
        output_json = json.dumps(output_data)
        
        self.wfile.write(output_json.encode('utf-8'))


Handler = MyHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
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
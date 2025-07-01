from flask import Flask, current_app

app = Flask(__name__)

@app.route("/")
def hello():
    return current_app.send_static_file('index.html')

def run():
    app.run(host="0.0.0.0", port=5000)

if __name__ == "__main__":
    run()

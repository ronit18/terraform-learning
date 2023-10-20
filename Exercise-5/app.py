from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
	return f"Hello, TF from {os.uname()[1]}!"

if __name__ == "__main__":
	app.run(host="0.0.0.0",port=80)

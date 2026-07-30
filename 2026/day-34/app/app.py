from flask import Flask
import os
import psycopg2
import redis

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Flask running with Docker Compose!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
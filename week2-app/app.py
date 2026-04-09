import os
from flask import Flask, jsonify
import socket

app = Flask(__name__)

@app.route('/')
def home():
    return "🚀 DevOps Day 4: Multi-service stack!"

@app.route('/health')
def health():
    return "OK", 200

@app.route('/db-check')
def db_check():
    host = os.getenv('DB_HOST', 'db')
    port = int(os.getenv('DB_PORT', 5432))
    try:
        with socket.create_connection((host, port), timeout=3):
            return jsonify({"status": "connected", "host": host, "port": port})
    except Exception as e:
        return jsonify({"status": "failed", "error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
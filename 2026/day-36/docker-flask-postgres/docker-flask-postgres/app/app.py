import os
import time
import psycopg2
from psycopg2 import OperationalError
from flask import Flask, render_template, request, redirect, url_for
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB", "appdb")
DB_USER = os.getenv("POSTGRES_USER", "appuser")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD", "apppassword")


def get_connection(retries=10, delay=3):
    """
    Try to connect to PostgreSQL, retrying a few times.
    This handles the case where Flask starts before Postgres is ready.
    """
    last_error = None
    for attempt in range(1, retries + 1):
        try:
            conn = psycopg2.connect(
                host=DB_HOST,
                port=DB_PORT,
                dbname=DB_NAME,
                user=DB_USER,
                password=DB_PASSWORD,
            )
            return conn
        except OperationalError as e:
            last_error = e
            print(f"[DB] Attempt {attempt}/{retries} failed: {e}")
            time.sleep(delay)
    raise last_error


def init_db():
    """Create the table if it doesn't already exist."""
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS messages (
            id SERIAL PRIMARY KEY,
            content TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT NOW()
        );
        """
    )
    conn.commit()
    cur.close()
    conn.close()


@app.route("/", methods=["GET"])
def index():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, content, created_at FROM messages ORDER BY id DESC;")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return render_template("index.html", messages=rows)


@app.route("/add", methods=["POST"])
def add_message():
    content = request.form.get("content", "").strip()
    if content:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("INSERT INTO messages (content) VALUES (%s);", (content,))
        conn.commit()
        cur.close()
        conn.close()
    return redirect(url_for("index"))


@app.route("/health", methods=["GET"])
def health():
    """Simple health check endpoint used by Docker healthcheck / monitoring."""
    try:
        conn = get_connection(retries=1, delay=0)
        conn.close()
        return {"status": "ok", "db": "connected"}, 200
    except Exception as e:
        return {"status": "error", "db": str(e)}, 500


# Ensure the table exists whether we're run via `python app.py`
# (dev) or via gunicorn (production, inside Docker).
init_db()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)

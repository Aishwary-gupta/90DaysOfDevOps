# Docker Flask + PostgreSQL Application

A production-style, multi-container application demonstrating Flask + PostgreSQL
running under Docker Compose, with persistent storage, internal networking,
and a non-root container user.

## Project Structure

```text
docker-flask-postgres/
│
├── app/
│   ├── app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── templates/
│   │      └── index.html
│   └── static/
│
├── docker-compose.yml
├── .env
└── README.md
```

## What It Does

- Flask connects to a PostgreSQL container using the service name `db`
  (Docker's internal DNS — no hardcoded IPs).
- On startup, it creates a `messages` table if one doesn't exist.
- The homepage lets you add a message and shows all stored messages,
  proving data is being written to and read from Postgres.
- `/health` returns a JSON status you can use for monitoring or Docker
  healthchecks.
- Postgres data is stored in a named volume (`postgres_data`), so it
  survives `docker compose down`.
- The Flask container runs as a non-root user and serves the app via
  `gunicorn` instead of the Flask dev server.

## Prerequisites

- Docker
- Docker Compose (bundled with modern Docker Desktop / Docker Engine)

## Setup & Run

1. Clone or copy this project, then move into it:

   ```bash
   cd docker-flask-postgres
   ```

2. (Optional) Edit `.env` to change the database name, user, or password.
   Never commit real credentials — this `.env` is for local/dev use.

3. Build the images:

   ```bash
   docker compose build
   ```

4. Start everything:

   ```bash
   docker compose up
   ```

   Or in detached mode:

   ```bash
   docker compose up -d
   ```

5. Open the app:

   ```text
   http://localhost:5000
   ```

## Verifying Things Work

Check running containers:

```bash
docker ps
```

Check logs:

```bash
docker compose logs -f
```

Check health:

```bash
curl http://localhost:5000/health
```

## Testing Data Persistence

1. Add a few messages via the web page.
2. Stop everything:

   ```bash
   docker compose down
   ```

3. Start it again:

   ```bash
   docker compose up
   ```

4. Refresh the page — your messages should still be there, because they
   live in the `postgres_data` named volume, not inside the container.

To wipe the database completely (including the volume):

```bash
docker compose down -v
```

## Rebuilding After Code Changes

```bash
docker compose up --build
```

## Pushing the Image to Docker Hub

```bash
docker build -t YOUR_DOCKERHUB_USERNAME/flask-postgres-app:1.0 ./app
docker push YOUR_DOCKERHUB_USERNAME/flask-postgres-app:1.0
```

Anyone can then run your image without needing the source code, as long
as they also run a Postgres container (or point it at their own database)
and set the matching environment variables.

## Key Concepts Demonstrated

- Production-ready Dockerfile with layer caching (dependencies installed
  before app code is copied)
- Multi-container orchestration with Docker Compose
- Named volumes for persistent data
- Docker's internal networking / service discovery (`db` instead of an IP)
- Environment variables and secrets kept out of source code
- Running the container process as a non-root user
- Health checks and `depends_on: condition: service_healthy` to ensure
  Flask waits for Postgres to be ready
- Building and publishing a Docker image

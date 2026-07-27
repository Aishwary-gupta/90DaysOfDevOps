# Day 34 – Docker Compose: Real-World Multi-Container Apps

## Overview

Today I built a production-like multi-container application using Docker Compose. Instead of running individual containers manually, I used a single `docker-compose.yml` file to define and manage the entire application stack.

## Technologies Used

- Docker
- Docker Compose
- Python Flask
- PostgreSQL
- Redis

## Project Architecture

```
Browser
    │
    ▼
Flask Web App
   │
   ├──────────► PostgreSQL Database
   │
   └──────────► Redis Cache
```

## Topics Covered

- Multi-container applications
- Docker Compose services
- Building custom images using Dockerfiles
- `depends_on`
- Health checks
- Restart policies
- Named volumes
- Custom networks
- Labels
- Environment variables
- Scaling services

## Docker Compose Features Used

### Services
Defined three services:
- Flask Web Application
- PostgreSQL Database
- Redis Cache

### Build
Built the Flask application from a custom Dockerfile using:

```yaml
build: ./app
```

### Health Check

Configured PostgreSQL health checks using:

```yaml
healthcheck:
```

This ensures the application waits until the database is ready.

### Restart Policies

- `restart: always`
- `restart: on-failure`

Used to improve container reliability.

### Named Volume

Stored PostgreSQL data using a persistent named volume.

### Custom Network

Created a dedicated backend network so containers communicate securely using service names.

### Environment Variables

Stored database credentials inside a `.env` file instead of hardcoding them.

## Docker Compose Commands Used

```bash
docker compose up
docker compose up -d
docker compose up --build
docker compose down
docker compose ps
docker compose logs
docker compose logs -f
docker compose exec web bash
docker compose restart
docker compose stop
docker compose start
docker compose up --scale web=3
```

## Key Learnings

- Docker Compose manages multiple containers from a single YAML file.
- Services communicate using service names instead of IP addresses.
- Health checks ensure dependent services start only after prerequisites are ready.
- Named volumes preserve database data even after containers are removed.
- Custom networks improve isolation and communication.
- Restart policies improve application resilience.
- Building images directly through Compose simplifies deployment.

## Outcome

Successfully deployed a production-style application stack consisting of a Flask web application, PostgreSQL database, and Redis cache using Docker Compose with health checks, persistent storage, custom networking, and restart policies.

## Author

**Aishwary Gupta**

90 Days of DevOps Challenge

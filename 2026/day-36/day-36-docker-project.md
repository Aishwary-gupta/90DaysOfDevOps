# Day 36 – Docker Project: Dockerize a Full Application

## Overview

This project is part of my **90 Days of DevOps** journey.

Today I applied everything I learned about Docker by Dockerizing a complete application from scratch. Instead of working with individual containers, I created a production-like setup using Docker, Docker Compose, custom networks, persistent volumes, environment variables, health checks, and Docker Hub.

---

## Objective

The objective of this project was to package an entire application into containers so it can run consistently on any machine without worrying about software installation or dependency conflicts.

---

## Topics Covered

- Dockerizing a complete application
- Writing production-ready Dockerfiles
- Multi-stage Docker builds
- Non-root users
- Docker Compose
- Custom Docker Networks
- Named Volumes
- Environment Variables
- Health Checks
- Docker Hub
- Image Versioning
- Docker Best Practices
- Containerized Deployment

---

## Project Structure

```text
day-36/
│
├── app/
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── app.py
│   └── .dockerignore
│
├── docker-compose.yml
├── .env
└── day-36-docker-project.md
```

---

## Application Used

For this project, I Dockerized a complete web application consisting of:

- Flask Application
- PostgreSQL Database
- Docker Compose
- Docker Network
- Persistent Database Volume

---

## Docker Commands Used

```bash
docker build -t flask-app:v1 .

docker images

docker run flask-app:v1

docker compose up

docker compose up -d

docker compose down

docker compose ps

docker compose logs

docker compose logs -f

docker compose up --build

docker tag flask-app:v1 username/flask-app:v1

docker login

docker push username/flask-app:v1

docker pull username/flask-app:v1

docker image ls

docker container ls

docker network ls

docker volume ls
```

---

## Dockerfile Features

The Dockerfile includes:

- Lightweight base image
- Multi-stage build
- Working directory
- Dependency installation
- Copy application files
- Non-root user
- Environment variables
- Default startup command

Example instructions used:

```Dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python","app.py"]
```

---

## Docker Compose Features

Docker Compose was used to manage multiple services together.

Services included:

- Flask Application
- PostgreSQL Database

Compose Features:

- build
- image
- ports
- environment
- depends_on
- healthcheck
- restart policy
- named volumes
- custom network

---

## Environment Variables

Application configuration was moved outside the code using a `.env` file.

Example:

```env
POSTGRES_DB=mydb
POSTGRES_USER=admin
POSTGRES_PASSWORD=password

DB_HOST=db
DB_PORT=5432
```

---

## Networking

Created a custom Docker network so containers can communicate securely.

Example:

```yaml
networks:
  app-network:
```

The application accesses PostgreSQL using the service name instead of an IP address.

---

## Persistent Storage

A named Docker volume was created to preserve database data even if containers are removed.

Example:

```yaml
volumes:
  postgres-data:
```

---

## Health Checks

Health checks ensure the database is fully ready before the application starts.

Example:

```yaml
healthcheck:
  test: ["CMD","pg_isready","-U","admin"]
```

---

## Docker Hub

After successfully testing the application locally:

- Logged into Docker Hub
- Tagged the image
- Pushed the image
- Pulled the image again for verification

Example:

```bash
docker tag flask-app:v1 username/flask-app:v1

docker push username/flask-app:v1
```

---

## Challenges Faced

- Configuring application-to-database communication
- Managing environment variables
- Understanding Docker networking
- Keeping the image size small
- Testing a completely fresh deployment

---

## Key Learnings

- Docker can package an entire application into portable containers.
- Docker Compose simplifies multi-container application management.
- Environment variables improve security and flexibility.
- Named volumes prevent data loss.
- Docker networks allow containers to communicate without exposing unnecessary ports.
- Health checks make deployments more reliable.
- Multi-stage builds produce smaller and more secure images.
- Publishing images to Docker Hub makes applications easy to share and deploy.

---

## Outcome

Successfully Dockerized a complete application with:

- Dockerfile
- Docker Compose
- PostgreSQL Database
- Environment Variables
- Named Volumes
- Custom Network
- Health Checks
- Docker Hub Image

The application can now be deployed consistently on any system using Docker Compose.

---

## Skills Gained

- Docker
- Docker Compose
- Docker Networking
- Docker Volumes
- Dockerfile
- Multi-stage Builds
- Image Optimization
- Docker Hub
- Containerized Deployment
- DevOps Fundamentals

---

## Repository

This project is part of my **90 Days of DevOps** challenge where I practice DevOps concepts through hands-on labs and real-world projects every day.

---

## Author

**Aishwary Gupta**

90 Days of DevOps Challenge

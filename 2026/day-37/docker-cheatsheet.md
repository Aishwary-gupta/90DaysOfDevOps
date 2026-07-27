# Day 37 – Docker Revision & Cheat Sheet

## Overview

This project is part of my **90 Days of DevOps** journey.

Today was dedicated to revising everything I learned from Docker Days 29–36. Instead of learning new concepts, I focused on strengthening my understanding of Docker fundamentals, Dockerfiles, networking, volumes, Docker Compose, multi-stage builds, and Docker Hub.

The goal was to build a personal Docker Cheat Sheet that I can quickly reference during projects, interviews, and day-to-day DevOps work.

---

## Topics Revised

- Docker Fundamentals
- Docker Architecture
- Docker Images
- Docker Containers
- Dockerfile
- Image Layers
- Docker Cache
- CMD vs ENTRYPOINT
- Docker Volumes
- Bind Mounts
- Docker Networks
- Docker Compose
- Environment Variables
- Health Checks
- Multi-Stage Builds
- Docker Hub
- Image Optimization
- Docker Cleanup Commands

---

## Project Structure

```text
day-37/
│
├── docker-cheatsheet.md
└── day-37-revision.md
```

---

# Docker Cheat Sheet

## Container Commands

```bash
docker run image
```
Run a new container from an image.

```bash
docker run -it ubuntu
```
Run a container in interactive mode.

```bash
docker run -d nginx
```
Run a container in detached mode.

```bash
docker ps
```
List running containers.

```bash
docker ps -a
```
List all containers.

```bash
docker stop container_name
```
Stop a running container.

```bash
docker start container_name
```
Start a stopped container.

```bash
docker restart container_name
```
Restart a container.

```bash
docker kill container_name
```
Force stop a container.

```bash
docker rm container_name
```
Remove a container.

```bash
docker exec -it container_name bash
```
Open a shell inside a running container.

```bash
docker logs container_name
```
View container logs.

```bash
docker logs -f container_name
```
Follow container logs in real time.

---

## Image Commands

```bash
docker images
```
List all images.

```bash
docker pull nginx
```
Download an image.

```bash
docker build -t myimage:v1 .
```
Build an image from a Dockerfile.

```bash
docker tag myimage:v1 username/myimage:v1
```
Tag an image.

```bash
docker push username/myimage:v1
```
Upload an image to Docker Hub.

```bash
docker rmi image_name
```
Delete an image.

```bash
docker image inspect image_name
```
View image details.

```bash
docker image history image_name
```
View image layers.

---

## Volume Commands

```bash
docker volume create volume_name
```
Create a named volume.

```bash
docker volume ls
```
List volumes.

```bash
docker volume inspect volume_name
```
Inspect a volume.

```bash
docker volume rm volume_name
```
Remove a volume.

---

## Network Commands

```bash
docker network ls
```
List networks.

```bash
docker network create app-network
```
Create a custom network.

```bash
docker network inspect app-network
```
Inspect a network.

```bash
docker network connect app-network container_name
```
Connect a container to a network.

---

## Docker Compose Commands

```bash
docker compose up
```
Start all services.

```bash
docker compose up -d
```
Run services in detached mode.

```bash
docker compose down
```
Stop and remove services.

```bash
docker compose down -v
```
Remove services and volumes.

```bash
docker compose ps
```
List compose services.

```bash
docker compose logs
```
View logs.

```bash
docker compose logs -f
```
Follow logs.

```bash
docker compose up --build
```
Rebuild images and start services.

---

## Cleanup Commands

```bash
docker system df
```
View Docker disk usage.

```bash
docker system prune
```
Remove unused Docker resources.

```bash
docker image prune
```
Remove unused images.

```bash
docker container prune
```
Remove stopped containers.

```bash
docker volume prune
```
Remove unused volumes.

```bash
docker network prune
```
Remove unused networks.

---

## Dockerfile Instructions

### FROM

Defines the base image.

```Dockerfile
FROM python:3.12-slim
```

---

### WORKDIR

Sets the working directory.

```Dockerfile
WORKDIR /app
```

---

### COPY

Copies files from host to image.

```Dockerfile
COPY . .
```

---

### RUN

Executes commands while building the image.

```Dockerfile
RUN pip install -r requirements.txt
```

---

### EXPOSE

Documents the application port.

```Dockerfile
EXPOSE 5000
```

---

### CMD

Defines the default command executed when the container starts.

```Dockerfile
CMD ["python","app.py"]
```

---

### ENTRYPOINT

Defines the main executable for the container.

```Dockerfile
ENTRYPOINT ["python"]
```

---

## Quick Revision

### Image vs Container

Image is a blueprint.

Container is a running instance of that blueprint.

---

### Docker Volume

Stores data outside containers.

Data survives container deletion.

---

### Bind Mount

Shares files between the host and container.

Useful during development.

---

### Docker Network

Allows containers to communicate securely using service names instead of IP addresses.

---

### Multi-Stage Build

Uses multiple build stages to create smaller and more secure production images.

---

### CMD vs ENTRYPOINT

CMD provides the default command.

ENTRYPOINT defines the fixed executable.

---

### Docker Compose

Runs multiple containers together using a single YAML configuration file.

---

## Key Learnings

- Docker packages applications with all dependencies into portable containers.
- Images are immutable blueprints, while containers are running instances.
- Docker Compose simplifies multi-container deployments.
- Volumes provide persistent storage.
- Networks enable secure container-to-container communication.
- Multi-stage builds reduce image size significantly.
- Docker Hub makes sharing and deploying images easy.
- Image layer caching speeds up future builds.

---

## Outcome

Successfully revised all Docker concepts from Days 29–36 and created a practical Docker Cheat Sheet for interviews, real-world projects, and quick reference.

---

## Skills Strengthened

- Docker
- Dockerfile
- Docker Compose
- Docker Networking
- Docker Volumes
- Docker Hub
- Image Optimization
- Multi-Stage Builds
- Container Lifecycle
- DevOps Fundamentals

---

## Repository

This project is part of my **90 Days of DevOps** challenge where I practice DevOps concepts through hands-on labs and real-world projects every day.

---

## Author

**Aishwary Gupta**

90 Days of DevOps Challenge

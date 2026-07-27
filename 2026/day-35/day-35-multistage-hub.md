# Day 35 – Multi-Stage Builds & Docker Hub

## Overview

Today I learned how to optimize Docker images using Multi-Stage Builds and publish them to Docker Hub.

Instead of shipping large images with build tools and unnecessary dependencies, I built lightweight production-ready images by separating the build stage from the runtime stage.

## Topics Covered

- Docker Multi-Stage Builds
- Docker Hub
- Docker Image Tagging
- Image Versioning
- Docker Login
- Docker Push & Pull
- Minimal Base Images
- Non-root Containers
- Image Optimization
- Docker Best Practices

## Single Stage vs Multi-Stage

### Single Stage Build

- Build tools remain inside the image
- Larger image size
- Slower deployments

### Multi-Stage Build

- Builder image compiles the application
- Only compiled files are copied to the final image
- Smaller, faster, and more secure images

## Dockerfiles Created

### Single Stage Dockerfile

- Used `node:20`
- Installed dependencies
- Copied application source code
- Started the application

### Multi-Stage Dockerfile

- Builder stage using `node:20`
- Runtime stage using `node:20-alpine`
- Copied only the required application files
- Reduced final image size

## Docker Commands Used

```bash
docker build
docker images
docker login
docker tag
docker push
docker pull
docker rmi
```

## Docker Hub

Successfully:

- Logged into Docker Hub
- Tagged Docker image
- Pushed image to Docker Hub
- Pulled image back for verification
- Explored repository tags and versioning

Docker Hub Repository:

```
https://hub.docker.com/r/<your-username>/<repository-name>
```

## Docker Image Best Practices

- Use Multi-Stage Builds
- Use Alpine or other minimal base images
- Avoid using `latest` tags
- Run containers as non-root users
- Combine RUN commands to reduce image layers
- Keep images lightweight for faster deployments

## Key Learnings

- Multi-Stage Builds dramatically reduce Docker image size.
- Docker Hub is used to store and distribute container images.
- Image tags help manage application versions.
- Smaller images improve deployment speed and security.
- Running containers as non-root users is a production best practice.

## Outcome

Successfully created optimized Docker images using Multi-Stage Builds and published them to Docker Hub following production-ready Docker best practices.

## Author

**Aishwary Gupta**

90 Days of DevOps Challenge

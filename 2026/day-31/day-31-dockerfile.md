# Day 31 – Dockerfile: Build Your Own Images

## Overview

Today I learned how to build my own Docker images using Dockerfiles instead of relying only on images from Docker Hub.

I explored the most commonly used Dockerfile instructions, understood the difference between `CMD` and `ENTRYPOINT`, deployed a static website using Nginx, and learned how Docker layer caching speeds up image builds.

---

# Objectives

- Understand what a Dockerfile is
- Build custom Docker images
- Learn common Dockerfile instructions
- Understand CMD vs ENTRYPOINT
- Deploy a static website using Nginx
- Learn about `.dockerignore`
- Understand Docker build cache

---

# Task 1 – My First Dockerfile

## Dockerfile

```dockerfile
FROM ubuntu:latest

RUN apt update && apt install -y curl

CMD ["echo","Hello from my custom image!"]
```

## Build Image

```bash
docker build -t my-ubuntu:v1 .
```

## Run Container

```bash
docker run my-ubuntu:v1
```

### Output

```
Hello from my custom image!
```

### What I Learned

- `FROM` specifies the base image.
- `RUN` executes commands while building the image.
- `CMD` specifies the default command executed when the container starts.

---

# Task 2 – Dockerfile Instructions

## hello.txt

```
Welcome to Docker
```

## Dockerfile

```dockerfile
FROM ubuntu:latest

RUN apt update && apt install -y curl

WORKDIR /app

COPY hello.txt .

EXPOSE 8080

CMD ["cat","hello.txt"]
```

## Build

```bash
docker build -t docker-demo:v1 .
```

## Run

```bash
docker run docker-demo:v1
```

### Output

```
Welcome to Docker
```

### Dockerfile Instructions

| Instruction | Purpose |
|------------|---------|
| FROM | Defines the base image |
| RUN | Executes commands during image build |
| COPY | Copies files from host to image |
| WORKDIR | Sets the working directory |
| EXPOSE | Documents the application's port |
| CMD | Defines the default command |

---

# Task 3 – CMD vs ENTRYPOINT

## CMD Example

```dockerfile
FROM alpine

CMD ["echo","hello"]
```

Run

```bash
docker run cmd-demo
```

Output

```
hello
```

Run with another command

```bash
docker run cmd-demo ls
```

Result

The `CMD` instruction is replaced by the new command.

---

## ENTRYPOINT Example

```dockerfile
FROM alpine

ENTRYPOINT ["echo"]
```

Run

```bash
docker run entry-demo Hello DevOps
```

Output

```
Hello DevOps
```

### CMD vs ENTRYPOINT

| CMD | ENTRYPOINT |
|------|------------|
| Default command | Fixed executable |
| Can be overridden | Cannot be replaced easily |
| Used for optional defaults | Used for the main application |

---

# Task 4 – Deploy Static Website

## index.html

```html
<!DOCTYPE html>
<html>

<head>
    <title>Docker Demo</title>
</head>

<body>

<h1>Hello DevOps!</h1>

<p>Welcome to my Docker website.</p>

</body>

</html>
```

## Dockerfile

```dockerfile
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/

EXPOSE 80
```

## Build

```bash
docker build -t my-website:v1 .
```

## Run

```bash
docker run -d -p 8080:80 my-website:v1
```

Open

```
http://localhost:8080
```

The custom webpage is successfully served by Nginx.

---

# Task 5 – .dockerignore

## .dockerignore

```
node_modules
.git
*.md
.env
```

### Why use .dockerignore?

- Reduces image size
- Speeds up build process
- Prevents sensitive files from entering images
- Keeps Docker build context clean

---

# Task 6 – Docker Layer Cache

Build image

```bash
docker build -t cache-demo:v1 .
```

Modify one file and rebuild.

Docker reused previously built layers and rebuilt only the modified layer.

### Why Layer Order Matters

Docker caches every instruction.

If an early instruction changes, Docker rebuilds all following layers.

Therefore:

- Frequently changing files should be copied near the end.
- Stable instructions should remain near the top.

This greatly improves build performance.

---

# Docker Commands Used

```bash
docker build -t image-name .

docker images

docker run image-name

docker run -d -p 8080:80 image-name

docker ps

docker logs container-name

docker exec -it container-name bash
```

---

# Project Structure

```
day-31/
│
├── Dockerfile
├── index.html
├── hello.txt
├── .dockerignore
└── day-31-dockerfile.md
```

---

# Key Learnings

- Dockerfiles are used to build custom Docker images.
- Every Dockerfile instruction creates a new image layer.
- Docker uses cached layers to speed up rebuilds.
- `CMD` provides the default command for a container.
- `ENTRYPOINT` defines the main executable of a container.
- `.dockerignore` prevents unnecessary files from being included in the build context.
- Nginx can be used to serve static websites directly from a Docker container.

---

# Interview Questions

## What is a Dockerfile?

A Dockerfile is a text file containing instructions that Docker follows to build a Docker image.

---

## Difference between Image and Container

An Image is a read-only template.

A Container is a running instance of that image.

---

## Difference between CMD and ENTRYPOINT

CMD provides default arguments or commands.

ENTRYPOINT specifies the executable that always runs when the container starts.

---

## Why does Docker use layers?

Layers reduce storage usage and improve build speed through caching.

---

## Why use .dockerignore?

It excludes unnecessary files from the build context, reducing image size and improving security.

---

# Conclusion

Today I learned how Docker images are created using Dockerfiles and how each instruction contributes to the final image. I also deployed a static website with Nginx, explored Docker layer caching, and understood the practical differences between `CMD` and `ENTRYPOINT`.

This knowledge forms the foundation for building production-ready containerized applications.

---

**Author**

**Aishwary Gupta**

**90 Days of DevOps Challenge**

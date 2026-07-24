# Day 29 – Docker Basics

## Objective

Learn the fundamentals of Docker by understanding containers, Docker architecture, installing Docker, and running containers.

---

# What is Docker?

Docker is an open-source containerization platform that allows developers to package applications along with all their dependencies into lightweight, portable containers. Containers ensure that applications run consistently across different environments.

### Why do we need Docker?

- Eliminates the "It works on my machine" problem.
- Makes application deployment consistent across environments.
- Provides isolated environments for applications.
- Uses fewer resources than virtual machines.
- Simplifies application deployment and scaling.

---

# What is a Container?

A container is a lightweight, standalone package that contains:

- Application source code
- Runtime
- Libraries
- Dependencies
- Configuration files

Containers share the host operating system kernel while remaining isolated from one another.

---

# Containers vs Virtual Machines

| Virtual Machines | Containers |
|------------------|------------|
| Includes a complete operating system | Shares the host operating system kernel |
| Large in size | Lightweight |
| Slower startup | Starts within seconds |
| Requires more CPU and RAM | Uses fewer resources |
| Managed through a hypervisor | Managed through Docker Engine |

---

# Docker Architecture

Docker consists of four major components:

## Docker Client

The Docker Client is the command-line interface where users execute Docker commands.

Example:

```bash
docker run nginx
```

---

## Docker Daemon

The Docker Daemon (`dockerd`) is the background service responsible for:

- Building images
- Pulling images
- Running containers
- Managing Docker objects

---

## Docker Images

A Docker Image is a read-only template used to create containers.

Examples:

- nginx
- ubuntu
- mysql
- redis
- node

---

## Docker Containers

A container is a running instance of a Docker Image.

Multiple containers can be created from the same image.

---

## Docker Registry

Docker Hub is the default public registry that stores Docker images.

Docker downloads images from Docker Hub if they are not available locally.

---

# Docker Architecture Flow

```
Docker Client
      |
      | docker commands
      v
Docker Daemon
      |
      +----------------------+
      |                      |
Pull Images            Create Containers
      |                      |
      +----------+-----------+
                 |
            Docker Hub
```

---

# Installing Docker (Ubuntu)

Update packages

```bash
sudo apt update
```

Install Docker

```bash
sudo apt install docker.io -y
```

Enable Docker

```bash
sudo systemctl enable docker
```

Start Docker

```bash
sudo systemctl start docker
```

Verify installation

```bash
docker --version
```

Check Docker service

```bash
sudo systemctl status docker
```

---

# Running the Hello World Container

```bash
docker run hello-world
```

### What happens?

1. Docker checks if the image exists locally.
2. If not found, Docker downloads it from Docker Hub.
3. Docker creates a container from the image.
4. The container executes.
5. Docker displays the success message.
6. The container exits automatically.

---

# Running an Nginx Container

Run in foreground

```bash
docker run nginx
```

Run in detached mode

```bash
docker run -d nginx
```

---

# Running an Ubuntu Container

Interactive mode

```bash
docker run -it ubuntu
```

Useful commands inside the container

```bash
pwd
ls
whoami
cat /etc/os-release
```

Exit

```bash
exit
```

---

# Listing Containers

Running containers

```bash
docker ps
```

All containers

```bash
docker ps -a
```

---

# Naming Containers

Instead of random names

```bash
docker run -d --name webserver nginx
```

View running containers

```bash
docker ps
```

---

# Port Mapping

Expose container port 80 to host port 8080

```bash
docker run -d -p 8080:80 --name nginx-server nginx
```

Access in browser

```
http://localhost:8080
```

---

# Viewing Logs

```bash
docker logs nginx-server
```

Useful for debugging running applications.

---

# Executing Commands Inside a Container

Using Bash

```bash
docker exec -it nginx-server bash
```

If Bash is unavailable

```bash
docker exec -it nginx-server sh
```

Exit

```bash
exit
```

---

# Stopping a Container

```bash
docker stop nginx-server
```

---

# Starting a Container

```bash
docker start nginx-server
```

---

# Restarting a Container

```bash
docker restart nginx-server
```

---

# Removing a Container

```bash
docker rm nginx-server
```

---

# Viewing Docker Images

```bash
docker images
```

---

# Pulling Images

```bash
docker pull ubuntu
```

```bash
docker pull nginx
```

---

# Common Docker Commands

| Command | Description |
|----------|-------------|
| `docker --version` | Display Docker version |
| `docker info` | Display Docker system information |
| `docker images` | List available images |
| `docker pull <image>` | Download an image |
| `docker run <image>` | Run a container |
| `docker run -d <image>` | Run container in detached mode |
| `docker run -it <image>` | Run container interactively |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker stop <container>` | Stop a container |
| `docker start <container>` | Start a stopped container |
| `docker restart <container>` | Restart a container |
| `docker rm <container>` | Remove a container |
| `docker logs <container>` | Display container logs |
| `docker exec -it <container> bash` | Access a running container |
| `docker inspect <container>` | Display detailed container information |

---

# Key Learnings

1. Docker packages applications and dependencies into lightweight containers for consistent deployment.

2. Containers are faster and more resource-efficient than virtual machines because they share the host operating system kernel.

3. Docker follows a client-server architecture consisting of the Docker Client, Docker Daemon, Docker Images, Containers, and Docker Hub.

4. Images are templates, while containers are running instances of those images.

5. Docker provides simple commands to create, manage, inspect, stop, and remove containers.

---

# Conclusion

Docker is one of the fundamental technologies in modern DevOps. It simplifies application deployment by ensuring that applications run consistently across development, testing, and production environments. Understanding Docker basics is the first step toward learning Dockerfiles, Docker Compose, Kubernetes, and container orchestration.

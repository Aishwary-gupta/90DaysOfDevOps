# Day 30 – Docker Images & Container Lifecycle

## Objective

The goal of this lab is to understand how Docker images and containers work, how Docker stores images using layers, and how a container moves through different lifecycle states.

---

# Docker Images

A Docker image is a read-only template that contains everything required to run an application, including:

- Application source code
- Runtime environment
- System libraries
- Dependencies
- Configuration files

Images are used to create containers.

---

# Images vs Containers

| Docker Image | Docker Container |
|--------------|------------------|
| Blueprint or template | Running instance of an image |
| Read-only | Read and write |
| Cannot execute by itself | Executes the application |
| Used to create containers | Created from images |

Relationship:

```
Docker Image
      │
      ▼
docker run
      │
      ▼
Docker Container
```

---

# Task 1 – Docker Images

## Pull Images

```bash
docker pull nginx
docker pull ubuntu
docker pull alpine
```

---

## List Images

```bash
docker images
```

Example Output

```
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE

nginx        latest    xxxxxxxxxxxx   2 weeks ago   193MB
ubuntu       latest    xxxxxxxxxxxx   3 weeks ago   79MB
alpine       latest    xxxxxxxxxxxx   1 month ago   8MB
```

---

## Why is Alpine Smaller?

Ubuntu contains:

- GNU utilities
- Package manager
- Additional libraries
- Documentation

Alpine Linux contains:

- BusyBox utilities
- Minimal libraries
- Very small operating system

Because of its lightweight design, Alpine images download faster, consume less storage, and start more quickly.

---

## Inspect an Image

```bash
docker image inspect nginx
```

Useful information available:

- Image ID
- Creation date
- Operating System
- Architecture
- Environment variables
- Entrypoint
- Working directory
- Labels

---

## Remove an Image

```bash
docker rmi ubuntu
```

---

# Docker Image Layers

Docker images are built from multiple read-only layers.

Each Dockerfile instruction creates a new layer.

Example:

```
Base Ubuntu Image
        │
        ▼
Install Python
        │
        ▼
Install Flask
        │
        ▼
Copy Application
        │
        ▼
Final Docker Image
```

Benefits:

- Faster downloads
- Layer caching
- Reduced storage usage
- Faster image builds

---

## View Image History

```bash
docker image history nginx
```

Example Output

```
IMAGE          CREATED          CREATED BY                  SIZE

xxxxxxx        2 weeks ago      CMD ["nginx"]               0B
xxxxxxx        2 weeks ago      COPY                        5KB
xxxxxxx        2 weeks ago      RUN apt install nginx       45MB
xxxxxxx        3 weeks ago      Base Layer                  120MB
```

---

## Why Some Layers Show 0B

Layers with **0B** usually represent metadata changes such as:

- CMD
- ENTRYPOINT
- ENV
- LABEL
- EXPOSE

These instructions modify image configuration but do not add files.

---

# Container Lifecycle

A Docker container passes through multiple states during its lifetime.

```
Create
   │
   ▼
Created
   │
Start
   ▼
Running
   │
Pause
   ▼
Paused
   │
Unpause
   ▼
Running
   │
Stop
   ▼
Exited
   │
Restart
   ▼
Running
   │
Kill
   ▼
Exited
   │
Remove
   ▼
Deleted
```

---

## Create a Container

Creates a container without starting it.

```bash
docker create --name web nginx
```

---

## Start Container

```bash
docker start web
```

---

## Pause Container

```bash
docker pause web
```

Check status

```bash
docker ps
```

Status

```
Paused
```

---

## Unpause Container

```bash
docker unpause web
```

---

## Stop Container

```bash
docker stop web
```

---

## Restart Container

```bash
docker restart web
```

---

## Kill Container

Immediately terminates the container.

```bash
docker kill web
```

---

## Remove Container

```bash
docker rm web
```

---

# Working with Running Containers

Run Nginx

```bash
docker run -d --name nginx-server -p 8080:80 nginx
```

---

## View Logs

```bash
docker logs nginx-server
```

---

## Follow Logs

```bash
docker logs -f nginx-server
```

---

## Enter Container

```bash
docker exec -it nginx-server bash
```

If Bash is unavailable

```bash
docker exec -it nginx-server sh
```

Useful commands

```bash
pwd

ls

cat /etc/os-release

ps aux
```

Exit

```bash
exit
```

---

## Run a Single Command

```bash
docker exec nginx-server ls /
```

---

## Inspect Container

```bash
docker inspect nginx-server
```

Useful information

- Container ID
- Container IP Address
- Mounted Volumes
- Port Mapping
- Environment Variables
- Restart Policy
- Network Information

---

# Cleanup

## Stop All Running Containers

```bash
docker stop $(docker ps -q)
```

---

## Remove All Stopped Containers

```bash
docker container prune
```

or

```bash
docker rm $(docker ps -aq)
```

---

## Remove Unused Images

```bash
docker image prune
```

Remove everything unused

```bash
docker system prune -a
```

---

## Check Docker Disk Usage

```bash
docker system df
```

Example

```
TYPE            TOTAL     ACTIVE    SIZE

Images          5         2         850MB
Containers      3         1         25MB
Local Volumes   2         1         300MB
Build Cache     0         0         0B
```

---

# Common Commands

| Command | Description |
|----------|-------------|
| `docker pull` | Download an image |
| `docker images` | List images |
| `docker image inspect` | Inspect an image |
| `docker image history` | View image layers |
| `docker create` | Create container without starting |
| `docker start` | Start container |
| `docker stop` | Stop container |
| `docker restart` | Restart container |
| `docker pause` | Pause container |
| `docker unpause` | Resume container |
| `docker kill` | Force stop container |
| `docker rm` | Remove container |
| `docker logs` | Display container logs |
| `docker logs -f` | Follow logs in real time |
| `docker exec` | Execute commands inside container |
| `docker inspect` | Display detailed information |
| `docker system df` | Display Docker disk usage |
| `docker system prune` | Remove unused Docker resources |

---

# Key Learnings

1. Docker images are read-only templates used to create containers.

2. Containers are running instances of Docker images with their own isolated filesystem and processes.

3. Docker images are composed of multiple reusable layers, making image builds faster and storage-efficient.

4. Containers move through different lifecycle states such as Created, Running, Paused, Exited, and Removed.

5. Docker provides powerful commands to inspect, manage, troubleshoot, and clean up images and containers.

---

# Conclusion

Understanding Docker images, image layers, and the container lifecycle is essential before creating custom Docker images with Dockerfiles. These concepts form the foundation for Docker Compose, container orchestration, Kubernetes, and modern DevOps workflows.

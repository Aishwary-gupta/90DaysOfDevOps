# Day 32 – Docker Volumes & Networking

## Overview

This project is part of my **90 Days of DevOps** journey.

On Day 32, I explored two fundamental Docker concepts: **Volumes** and **Networking**. Containers are designed to be temporary, so any data stored inside them is lost when they are removed. Docker Volumes solve this problem by providing persistent storage. I also learned how containers communicate with each other using Docker Networks and why custom bridge networks are preferred in real-world applications.

---

## Objectives

- Understand why containers lose data
- Learn Docker Volumes for persistent storage
- Create and inspect named volumes
- Understand Bind Mounts
- Learn Docker Networking
- Create custom bridge networks
- Enable communication between containers
- Connect applications and databases using Docker Networks

---

## Project Structure

```text
day-32/
└── day-32-volumes-networking.md
```

---

# Task 1 – Understanding Data Persistence

## Objective

Understand why data disappears when a container is removed.

### Steps Performed

- Started a MySQL/PostgreSQL container
- Created sample data inside the database
- Stopped and removed the container
- Created a new container without any volume

### Observation

The previously created data was no longer available.

### Why?

Containers have a writable layer that exists only while the container exists. When the container is removed, its writable layer is also deleted, causing all stored data to be lost.

---

# Task 2 – Named Volumes

## Objective

Store database data permanently outside the container.

### Steps Performed

- Created a Docker named volume
- Attached the volume to a database container
- Inserted sample data
- Removed the container
- Started a new container using the same volume

### Verification Commands

```bash
docker volume ls
docker volume inspect my-volume
```

### Observation

The database data was still available after recreating the container.

### Learning

Named volumes are managed by Docker and remain on the host machine even after containers are deleted.

---

# Task 3 – Bind Mounts

## Objective

Mount a local directory into a container.

### Steps Performed

- Created a local folder containing `index.html`
- Started an Nginx container
- Mounted the folder into `/usr/share/nginx/html`
- Opened the webpage
- Modified the HTML file on the host
- Refreshed the browser

### Observation

The changes appeared immediately without rebuilding the container.

### Named Volume vs Bind Mount

| Named Volume | Bind Mount |
|--------------|------------|
| Managed by Docker | Managed by Host OS |
| Stores persistent data | Shares local files directly |
| Used for databases | Used during development |
| Docker controls location | User controls location |

---

# Task 4 – Docker Networking Basics

## Objective

Understand how Docker networks allow container communication.

### Steps Performed

- Listed available Docker networks
- Inspected the default bridge network
- Started two containers on the default bridge
- Tested communication using IP addresses
- Tested communication using container names

### Observation

Containers on the default bridge network communicate using IP addresses, but name-based communication is limited.

### Commands Used

```bash
docker network ls
docker network inspect bridge
```

---

# Task 5 – Custom Bridge Network

## Objective

Enable automatic DNS-based communication between containers.

### Steps Performed

- Created a custom bridge network
- Started two containers on the custom network
- Pinged one container using its name

### Commands Used

```bash
docker network create my-app-net
docker run --network my-app-net
```

### Observation

Containers communicated successfully using container names.

### Learning

Docker automatically provides an internal DNS service on custom bridge networks, allowing containers to discover each other by service name instead of IP addresses.

---

# Task 6 – Combining Volumes and Networks

## Objective

Deploy an application and database together.

### Steps Performed

- Created a custom network
- Created a named volume
- Started a database container using the volume
- Started an application container on the same network
- Connected to the database using the container name

### Result

The application successfully communicated with the database while the database stored data permanently using the Docker volume.

---

# Docker Commands Practiced

```bash
docker volume create my-volume
docker volume ls
docker volume inspect my-volume

docker network ls
docker network inspect bridge
docker network create my-app-net

docker run -v my-volume:/var/lib/mysql
docker run -v C:\website:/usr/share/nginx/html

docker exec -it container_name bash
docker exec container1 ping container2
```

---

# Key Learnings

- Containers are temporary and lose their writable layer when removed.
- Docker Volumes provide persistent storage independent of containers.
- Bind Mounts allow direct access to host machine files.
- Docker Networks enable communication between containers.
- Custom bridge networks provide automatic DNS resolution.
- Databases should always use volumes to prevent data loss.
- Applications communicate with databases using container names instead of IP addresses.

---

# Real-World Use Cases

| Feature | Example |
|----------|---------|
| Named Volume | MySQL, PostgreSQL, MongoDB data |
| Bind Mount | Web development and live code editing |
| Custom Network | Communication between frontend, backend, and database |
| Docker DNS | Connecting application containers using service names |

---

# Outcome

Successfully implemented Docker Volumes for persistent storage and Docker Networks for container communication. Built a simple multi-container environment where an application connected to a database using a custom bridge network while maintaining persistent data through Docker Volumes.

---

# Screenshots

Add screenshots for:

- Docker volume list
- Docker volume inspect
- Docker network list
- Docker network inspect
- Nginx bind mount output
- Custom bridge network
- Ping between containers
- Database persistence demonstration

---

# Conclusion

Docker Volumes and Networking are essential concepts for building production-ready containerized applications. Volumes ensure important data survives container removal, while custom bridge networks allow containers to communicate securely using built-in DNS. Together, these features form the foundation of modern multi-container applications.

---

## Author

**Aishwary Gupta**

**90 Days of DevOps Challenge**

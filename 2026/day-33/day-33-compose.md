# Day 33 – Docker Compose: Multi-Container Basics

## Overview

Today I learned Docker Compose, a tool used to define and run multi-container Docker applications using a single YAML configuration file.

Instead of running multiple `docker run` commands manually, Docker Compose allows all services, networks, volumes, and environment variables to be managed from one file.

---

# Objectives

- Understand Docker Compose
- Create a compose file
- Run multiple containers
- Connect WordPress with MySQL
- Use named volumes
- Use environment variables
- Learn common compose commands

---

# What is Docker Compose?

Docker Compose is a tool that allows multiple Docker containers to be defined and managed using a single YAML file (`docker-compose.yml`).

Instead of running containers individually, all services can be started with one command.

```
docker compose up
```

---

# Why Docker Compose?

Without Compose

```
docker network create app-network

docker volume create mysql-data

docker run mysql ...

docker run wordpress ...

docker run nginx ...
```

Many commands are required.

With Compose

```
docker compose up
```

Everything starts automatically.

---

# Task 1 – Verify Docker Compose

## Check Version

```bash
docker compose version
```

Example Output

```
Docker Compose version v2.x.x
```

---

# Task 2 – First Compose File

## Project Structure

```
compose-basics/

└── docker-compose.yml
```

## docker-compose.yml

```yaml
version: "3.9"

services:

  nginx:
    image: nginx:latest
    container_name: nginx-server

    ports:
      - "8080:80"
```

---

## Start

```bash
docker compose up
```

Detached mode

```bash
docker compose up -d
```

---

## Browser

```
http://localhost:8080
```

Nginx welcome page should appear.

---

## Stop

```bash
docker compose down
```

---

# Task 3 – WordPress + MySQL

## Project Structure

```
wordpress-compose/

├── docker-compose.yml
└── .env
```

---

## docker-compose.yml

```yaml
version: "3.9"

services:

  db:

    image: mysql:8

    container_name: mysql-db

    restart: always

    environment:

      MYSQL_ROOT_PASSWORD: root123

      MYSQL_DATABASE: wordpress

      MYSQL_USER: wpuser

      MYSQL_PASSWORD: password

    volumes:

      - mysql_data:/var/lib/mysql

  wordpress:

    image: wordpress:latest

    container_name: wordpress

    restart: always

    depends_on:
      - db

    ports:

      - "8081:80"

    environment:

      WORDPRESS_DB_HOST: db

      WORDPRESS_DB_USER: wpuser

      WORDPRESS_DB_PASSWORD: password

      WORDPRESS_DB_NAME: wordpress

volumes:

  mysql_data:
```

---

## Start

```bash
docker compose up -d
```

---

Browser

```
http://localhost:8081
```

WordPress installation page opens.

---

## Verify Volume

Stop

```bash
docker compose down
```

Start again

```bash
docker compose up -d
```

WordPress data still exists because MySQL data is stored inside a named Docker volume.

---

# Task 4 – Compose Commands

## Start

```bash
docker compose up
```

---

Detached Mode

```bash
docker compose up -d
```

---

View Running Services

```bash
docker compose ps
```

---

View All Logs

```bash
docker compose logs
```

---

Follow Logs

```bash
docker compose logs -f
```

---

Specific Service Logs

```bash
docker compose logs wordpress
```

---

Stop Services

```bash
docker compose stop
```

---

Start Again

```bash
docker compose start
```

---

Remove Everything

```bash
docker compose down
```

---

Remove Everything Including Volumes

```bash
docker compose down -v
```

---

Rebuild Images

```bash
docker compose up --build
```

---

# Task 5 – Environment Variables

## .env

```
MYSQL_ROOT_PASSWORD=root123

MYSQL_DATABASE=wordpress

MYSQL_USER=wpuser

MYSQL_PASSWORD=password
```

---

docker-compose.yml

```yaml
environment:

  MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}

  MYSQL_DATABASE: ${MYSQL_DATABASE}

  MYSQL_USER: ${MYSQL_USER}

  MYSQL_PASSWORD: ${MYSQL_PASSWORD}
```

Docker Compose automatically reads the `.env` file.

---

# Docker Compose Commands

```bash
docker compose version

docker compose up

docker compose up -d

docker compose down

docker compose ps

docker compose logs

docker compose logs -f

docker compose logs wordpress

docker compose start

docker compose stop

docker compose restart

docker compose up --build

docker compose down -v
```

---

# Key Learnings

- Docker Compose manages multiple containers using one YAML file.
- Compose automatically creates a network for all services.
- Service names become DNS names inside the network.
- Named volumes preserve data after containers are removed.
- Environment variables make compose files reusable.
- One command can start an entire application stack.

---

# Interview Questions

## What is Docker Compose?

Docker Compose is a tool that defines and manages multi-container Docker applications using a YAML configuration file.

---

## Why use Docker Compose?

It simplifies container management by starting all services, networks, and volumes with a single command.

---

## Why doesn't WordPress use localhost for MySQL?

Because each container has its own localhost.

Containers communicate using Docker's internal network.

WordPress connects to MySQL using the service name:

```
db
```

---

## What happens when docker compose up runs?

Compose

- Creates a network
- Creates required volumes
- Pulls missing images
- Creates containers
- Starts all services

---

## Difference between docker compose stop and down

stop

- Stops containers
- Containers remain

down

- Stops containers
- Removes containers
- Removes networks

Volumes remain unless `-v` is used.

---

## Why use a .env file?

- Keeps secrets outside compose files
- Makes configuration reusable
- Simplifies environment changes

---

# Conclusion

Today I learned how Docker Compose simplifies multi-container applications by defining services in a single YAML file. I successfully deployed Nginx and a WordPress-MySQL application, explored Docker networks, named volumes, environment variables, and the most commonly used Compose commands.

---

**Author**

**Aishwary Gupta**

**90 Days of DevOps Challenge**

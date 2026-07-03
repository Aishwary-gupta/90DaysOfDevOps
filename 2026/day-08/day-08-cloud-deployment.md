# Day 08 – Cloud Server Setup: Docker, Nginx & Web Deployment

## Objective

Deploy a web server on an AWS EC2 instance using Docker and Nginx, configure remote access, and collect container logs.

---

# Cloud Environment

* Cloud Provider: AWS EC2
* Operating System: Ubuntu Server 24.04 LTS
* Instance Type: t2.micro
* Web Server: Nginx (Docker Container)

---

# Commands Used

## Connect to Server

```bash
chmod 400 devops-day08.pem
ssh -i devops-day08.pem ubuntu@<PUBLIC_IP>
```

## Update Server

```bash
sudo apt update
sudo apt upgrade -y
```

## Install Docker

```bash
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
docker --version
```

## Pull Nginx Image

```bash
sudo docker pull nginx
```

## Run Nginx Container

```bash
sudo docker run -d --name nginx-server -p 80:80 nginx
```

## Verify Running Container

```bash
sudo docker ps
```

## Collect Logs

```bash
sudo docker logs nginx-server > nginx-logs.txt
cat nginx-logs.txt
```

---

# Challenges Faced

* Configured the EC2 Security Group to allow HTTP traffic on port 80.
* Verified that the Docker service was running before starting the container.
* Ensured the correct public IP address was used while accessing the application.

---

# What I Learned

* How to launch and connect to an AWS EC2 instance using SSH.
* How Docker simplifies application deployment through containers.
* How to deploy an Nginx web server inside a Docker container.
* How to expose applications using port mapping.
* How to collect and review container logs for troubleshooting.

---

# Screenshots Included

\day-08\Screenshot 2026-07-03 093244.png
\day-08\Screenshot 2026-07-03 093050.png


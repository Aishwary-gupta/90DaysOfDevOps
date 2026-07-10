# Day 15 – Networking Concepts: DNS, IP, Subnets & Ports

## Objective

Understand the core networking concepts required for DevOps, including DNS resolution, IPv4 addressing, CIDR notation, subnetting, and common network ports.

---

## Task 1 – DNS

### What happens when you type `google.com`?

1. The browser sends a DNS query to resolve the domain name.
2. The DNS server returns the IPv4 address (A record).
3. The browser establishes a TCP connection to the resolved IP.
4. An HTTP or HTTPS request is sent, and the server responds with the webpage.

### Common DNS Records

* **A** – Maps a domain name to an IPv4 address.
* **AAAA** – Maps a domain name to an IPv6 address.
* **CNAME** – Creates an alias for another domain.
* **MX** – Specifies the mail server for a domain.
* **NS** – Identifies the authoritative name servers.

### Command

```bash
dig google.com
```

**Observation:** Identified the A record and TTL value from the ANSWER SECTION.

---

## Task 2 – IP Addressing

### IPv4

An IPv4 address is a 32-bit address written as four decimal numbers separated by dots (for example, `192.168.1.10`).

### Public vs Private IP

* Public IP: Accessible from the Internet (example: `3.111.38.241`).
* Private IP: Used within private networks (example: `192.168.1.100`).

### Private IP Ranges

* `10.0.0.0/8`
* `172.16.0.0/12`
* `192.168.0.0/16`

### Command

```bash
ip addr show
```

**Observation:** Verified that the assigned local IP belongs to a private address range.

---

## Task 3 – CIDR & Subnetting

Subnetting divides a larger network into smaller, manageable networks for better organization, security, and efficient IP allocation.

| CIDR | Subnet Mask     | Total IPs | Usable Hosts |
| ---- | --------------- | --------- | ------------ |
| /24  | 255.255.255.0   | 256       | 254          |
| /16  | 255.255.0.0     | 65,536    | 65,534       |
| /28  | 255.255.255.240 | 16        | 14           |

---

## Task 4 – Ports

A port identifies a specific service running on an IP address.

| Port  | Service |
| ----- | ------- |
| 22    | SSH     |
| 80    | HTTP    |
| 443   | HTTPS   |
| 53    | DNS     |
| 3306  | MySQL   |
| 6379  | Redis   |
| 27017 | MongoDB |

### Command

```bash
sudo ss -tulpn
```

**Observation:** Matched active listening ports with their respective services.

---

## Task 5 – Putting It Together

### `curl http://myapp.com:8080`

This request involves DNS resolution, TCP connection establishment, IP routing, and HTTP communication over port 8080.

### Database Connection Issue

If an application cannot reach `10.0.1.50:3306`, I would first verify network connectivity, ensure the database service is running, check that port 3306 is listening, and confirm firewall or security group rules allow the connection.

---

## What I Learned

* DNS translates domain names into IP addresses before communication begins.
* CIDR notation determines network size and available host addresses.
* Ports allow multiple services to run on the same IP address.
* Public and private IP addresses serve different purposes in networking.
* Understanding networking fundamentals is essential for troubleshooting cloud infrastructure.


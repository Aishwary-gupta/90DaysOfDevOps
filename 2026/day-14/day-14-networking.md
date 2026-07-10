# Day 14 – Networking Fundamentals & Hands-on Checks

## Objective

Learn the fundamentals of networking by understanding the OSI and TCP/IP models and performing basic network troubleshooting using common Linux commands.

---

## Networking Concepts

### OSI Model

* Seven-layer reference model for understanding network communication.
* Helps identify where communication issues occur.

### TCP/IP Model

* Four-layer practical networking model used on the Internet.
* Maps closely to how Linux systems communicate.

### Protocols

* IP → Internet Layer
* TCP/UDP → Transport Layer
* HTTP/HTTPS → Application Layer
* DNS → Application Layer

Example:

`curl https://example.com` → HTTP → TCP → IP → Ethernet

---

## Commands Used

```bash
hostname -I
ip addr show

ping google.com

traceroute google.com

sudo ss -tulpn

dig google.com

curl -I https://google.com

netstat -an | head

nc -zv localhost 22
```

---

## Observations

* Verified the local IP address using `hostname -I`.
* Checked connectivity and latency with `ping`.
* Observed the network path using `traceroute`.
* Listed listening services and open ports with `ss`.
* Verified DNS resolution using `dig`.
* Confirmed HTTP response using `curl -I`.
* Reviewed active network connections using `netstat`.
* Tested local port availability using `nc`.

---

## Reflection

### Fastest troubleshooting command

`ping` provides the quickest indication of whether a remote system is reachable.

### If DNS fails

Investigate the Application layer by checking DNS configuration and using `dig` or `nslookup`.

### If HTTP 500 appears

Check the web server, application logs, and backend services because the network path is already working.

### Follow-up Checks

* `systemctl status nginx`
* `journalctl -u nginx -n 50`

---

## What I Learned

* The OSI model helps identify where network issues occur.
* TCP provides reliable communication, while UDP prioritizes speed.
* DNS converts domain names into IP addresses.
* Tools such as `ping`, `curl`, `ss`, and `dig` are essential for network troubleshooting.
* A structured troubleshooting approach helps reduce downtime during incidents.


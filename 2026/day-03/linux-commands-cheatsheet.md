#  Day 03 - Linux Commands Cheat Sheet

##  Objective

Build confidence with commonly used Linux commands for file management, process monitoring, networking, and troubleshooting.

---

#  File System

| Command  | Usage                                |
| -------- | ------------------------------------ |
| `pwd`    | Show current directory               |
| `ls -la` | List all files including hidden ones |
| `cd`     | Change directory                     |
| `find`   | Search for files                     |
| `tree`   | Display directory structure          |

---

#  File Operations

| Command   | Usage                          |
| --------- | ------------------------------ |
| `touch`   | Create a new file              |
| `mkdir`   | Create a new directory         |
| `cp`      | Copy files                     |
| `mv`      | Move or rename files           |
| `rm`      | Delete files                   |
| `cat`     | Display file contents          |
| `tail -f` | Monitor log files in real time |

---

#  Process Management

| Command  | Usage                        |
| -------- | ---------------------------- |
| `ps aux` | View all running processes   |
| `top`    | Real-time process monitoring |
| `htop`   | Interactive process viewer   |
| `pidof`  | Find a process ID            |
| `kill`   | Terminate a process          |

---

#  System Monitoring

| Command   | Usage                       |
| --------- | --------------------------- |
| `df -h`   | Check disk usage            |
| `du -sh`  | Check folder size           |
| `free -h` | Display memory usage        |
| `uptime`  | Show system uptime and load |
| `lscpu`   | Display CPU information     |

---

#  Networking

| Command     | Usage                     |
| ----------- | ------------------------- |
| `ping`      | Test network connectivity |
| `ip addr`   | Show IP addresses         |
| `curl`      | Test web servers and APIs |
| `dig`       | DNS lookup                |
| `ss -tulpn` | Show listening ports      |

---

#  Logs

| Command                   | Usage                            |
| ------------------------- | -------------------------------- |
| `journalctl`              | View system logs                 |
| `journalctl -u <service>` | View logs for a specific service |
| `journalctl -f`           | Follow logs in real time         |

---

##  Key Takeaways

* Linux commands are the foundation of DevOps troubleshooting.
* Process, networking, and log commands help identify production issues quickly.
* Mastering a small set of frequently used commands is more valuable than memorizing hundreds of commands.


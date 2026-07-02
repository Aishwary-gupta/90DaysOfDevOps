# Day 07 – Linux File System Hierarchy & Scenario-Based Practice

## Objective

Understand the Linux File System Hierarchy (FHS) and practice troubleshooting common Linux scenarios using a structured approach.

---

# Linux File System Hierarchy

| Directory  | Purpose                                              | I would use this when...                             |
| ---------- | ---------------------------------------------------- | ---------------------------------------------------- |
| `/`        | Root of the Linux filesystem.                        | Navigating the filesystem.                           |
| `/home`    | Stores user home directories and personal files.     | Managing user projects and documents.                |
| `/root`    | Home directory of the root user.                     | Performing administrative tasks.                     |
| `/etc`     | Stores system configuration files.                   | Editing configurations and troubleshooting services. |
| `/var/log` | Contains system and application log files.           | Investigating failures and debugging issues.         |
| `/tmp`     | Temporary storage for applications and users.        | Creating temporary files during testing.             |
| `/bin`     | Essential system binaries and commands.              | Running core Linux utilities.                        |
| `/usr/bin` | Additional user commands and installed applications. | Using development tools and utilities.               |
| `/opt`     | Optional third-party software.                       | Managing manually installed applications.            |

---

# Hands-on Commands

```bash
ls -l /
ls -l /home
sudo ls -l /root
ls -l /etc
ls -l /var/log
ls -l /tmp
du -sh /var/log/* 2>/dev/null | sort -h | tail -5
cat /etc/hostname
ls -la ~
```

---

# Scenario 1 – Service Not Starting

1. `systemctl status myapp` – Check service status.
2. `journalctl -u myapp -n 50` – Read recent logs.
3. `systemctl is-enabled myapp` – Verify startup configuration.
4. `systemctl restart myapp` – Restart after identifying the issue.

---

# Scenario 2 – High CPU Usage

1. `top` – Monitor CPU usage.
2. `ps aux --sort=-%cpu | head -10` – Find CPU-intensive processes.
3. `pgrep <process>` – Get the process ID.
4. `ps -p <PID> -f` – Inspect the process.

---

# Scenario 3 – Finding Service Logs

1. `systemctl status docker`
2. `journalctl -u docker -n 50`
3. `journalctl -u docker -f`

---

# Scenario 4 – File Permission Issue

1. `ls -l backup.sh`
2. `chmod +x backup.sh`
3. `ls -l backup.sh`
4. `./backup.sh`

---

# Key Learnings

* Configuration files are stored in `/etc`.
* Logs are primarily stored in `/var/log` or accessed through `journalctl`.
* User files are stored in `/home`, while the root user has a separate home directory at `/root`.
* Understanding the Linux filesystem helps locate logs, configurations, and binaries quickly during troubleshooting.
* Following a structured troubleshooting workflow reduces downtime and avoids unnecessary changes.


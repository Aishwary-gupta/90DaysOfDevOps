# 🐧 Day 02 - Linux Architecture, Processes & systemd

## 🎯 Objective

Understand how Linux works internally by learning about its architecture, process management, and the role of `systemd` in managing services.

---

# 🏗️ Linux Architecture

Linux consists of three major layers:

## 1. Hardware

Physical components such as:

* CPU
* RAM
* Storage (HDD/SSD)
* Network Interface Card
* Keyboard & Mouse

---

## 2. Kernel

The **Kernel** is the core of the Linux operating system.

### Responsibilities

* Memory Management
* Process Scheduling
* Device Management
* File System Management
* Networking
* Security & Permissions

Applications communicate with the hardware through the kernel using **System Calls**.

---

## 3. User Space

Contains all user applications and utilities.

Examples:

* Bash
* Docker
* Git
* Python
* Nginx
* VS Code
* SSH

---

# ⚙️ Linux Boot Process

```text
Power On
   ↓
BIOS / UEFI
   ↓
GRUB Bootloader
   ↓
Linux Kernel
   ↓
systemd (PID 1)
   ↓
System Services
   ↓
User Login
```

---

# 🔄 Processes in Linux

A **Process** is a running instance of a program.

Each process has:

* Process ID (PID)
* Parent Process ID (PPID)
* Owner
* Priority
* Current State

---

# 📌 Process States

| State | Meaning                                         |
| ----- | ----------------------------------------------- |
| R     | Running                                         |
| S     | Sleeping (waiting for an event)                 |
| D     | Uninterruptible Sleep (usually waiting for I/O) |
| T     | Stopped                                         |
| Z     | Zombie                                          |
| X     | Dead                                            |

---

# 🚀 systemd

`systemd` is the first userspace process started by Linux (PID 1).

It is responsible for:

* Starting system services
* Stopping services
* Restarting failed services
* Managing boot process
* Collecting logs using journalctl
* Automatically starting services during boot

---

# 🛠️ Daily Commands Every DevOps Engineer Uses

```bash
ps aux
top
systemctl status <service>
journalctl -u <service>
kill <PID>
```

Other useful commands:

```bash
pstree
htop
free -h
uptime
lscpu
vmstat
pidof
pgrep
journalctl -f
```

---

# 💡 Key Learnings

* The Kernel manages all communication between software and hardware.
* Every running application is a process identified by a unique PID.
* Processes are created by parent processes and managed by the kernel.
* `systemd` acts as the service manager and controls system startup.
* `journalctl` is the primary tool for viewing service logs.
* Understanding processes and services is essential for troubleshooting Linux servers in production.

---

# 📚 Conclusion

Today's learning built the foundation for Linux administration and DevOps. Understanding Linux architecture, process management, and `systemd` will help in debugging services, monitoring system health, and managing production servers efficiently.


# Linux Troubleshooting Runbook – Day 05

## Objective

Perform a structured Linux troubleshooting drill by collecting system health information, inspecting a service, reviewing logs, and documenting findings in a reusable runbook.

---

# Target Service / Process

**Service:** `cron`

**Environment:** Ubuntu 22.04.5 LTS running on VMware Workstation (`aishwary-virtual-machine`)

---

# Environment Basics

## Command

```bash
uname -a
```

**Observation**

Verified the Linux kernel version, system architecture, and hostname to establish the environment before troubleshooting.

---

## Command

```bash
cat /etc/os-release
```

**Observation**

Confirmed the operating system as Ubuntu 22.04.5 LTS. Knowing the exact distribution helps identify service locations, package versions, and logging behavior.

---

# Filesystem Sanity

## Commands

```bash
mkdir /tmp/runbook-demo

cp /etc/hosts /tmp/runbook-demo/hosts-copy

ls -l /tmp/runbook-demo
```

**Observation**

Initially encountered a copy command syntax mistake, corrected it, and successfully created the directory and copied the file. This confirmed that the filesystem was writable and functioning correctly.

---

# CPU & Memory Snapshot

## Command

```bash
top
```

**Observation**

* CPU utilization remained low.
* System load average stayed within healthy limits.
* No abnormal processes consuming excessive CPU resources.
* `gnome-shell` was the highest CPU consumer, which is expected for a desktop environment.

---

## Command

```bash
free -h
```

**Observation**

* Total memory: approximately 1.9 GiB
* Swap usage: approximately 316 MiB
* Available memory remained sufficient.

The system is healthy, although increasing VM memory could improve performance for heavier workloads.

---

# Disk & Storage Snapshot

## Command

```bash
df -h
```

**Observation**

The root filesystem was approximately 76% utilized with around 4.4 GB of free space remaining.

ISO images appeared as 100% full because they are mounted as read-only media, which is expected behavior.

---

## Command

```bash
du -sh /var/log
```

**Observation**

The `/var/log` directory occupied approximately 159 MB.

Some directories required elevated permissions, indicating that future investigations should use `sudo` for complete results.

---

# Network Snapshot

## Command

```bash
ss -tulpn
```

**Observation**

Only local services were listening on loopback addresses.

No unnecessary services were exposed externally, indicating a secure default network configuration.

---

# Log Review

## Command

```bash
journalctl -u cron -n 50
```

**Observation**

No log entries were returned.

On Ubuntu, cron activity is typically written to `/var/log/syslog` rather than the system journal.

Alternative command:

```bash
grep CRON /var/log/syslog | tail -n 50
```

This highlights the importance of understanding where services write logs on different Linux distributions.

---

# Quick Findings

* CPU utilization remained healthy.
* Memory usage was acceptable, although swap was being used.
* Root filesystem usage reached approximately 76%, making disk utilization the primary resource to monitor.
* Network exposure was minimal because only loopback services were listening.
* Cron logs were not available through `journalctl` and required checking `/var/log/syslog`.

---

# If This Worsens

### Disk Usage

* Identify large directories using:

```bash
du -sh /* 2>/dev/null | sort -rh | head
```

* Remove unnecessary files or expand disk capacity if usage exceeds 85–90%.

---

### Memory Pressure

Monitor the highest memory-consuming processes:

```bash
ps -eo pid,pmem,comm --sort=-pmem | head
```

Increase the VM's allocated RAM if swap usage continues to grow.

---

### Cron Troubleshooting

Monitor cron activity directly from syslog:

```bash
grep CRON /var/log/syslog | tail -f
```

If a cron job appears stuck, inspect it using:

```bash
strace -p <PID>
```

---

# Key Learnings

* Always gather evidence before taking corrective action.
* Review CPU, memory, disk, network, and logs before restarting services.
* Different Linux distributions store service logs in different locations.
* Small observations made during troubleshooting can prevent larger production incidents.
* A structured runbook improves consistency and reduces troubleshooting time during real incidents.


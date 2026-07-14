# Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab

## Overview

Today's objective was to build practical Bash automation scripts that simulate real-world DevOps maintenance tasks. I created scripts for log rotation, automated backups, and learned how to schedule recurring jobs using cron.

---

## Scripts Created

### 1. log_rotate.sh

- Accepts a log directory as an argument
- Compresses `.log` files older than 7 days using `gzip`
- Deletes compressed `.gz` files older than 30 days
- Validates the provided directory before execution
- Displays the number of files compressed and deleted

---

### 2. backup.sh

- Accepts source and destination directories
- Creates timestamped `.tar.gz` backups
- Verifies successful archive creation
- Displays archive size
- Removes backups older than 14 days

---

### 3. maintenance.sh

- Executes both log rotation and backup tasks
- Stores execution logs with timestamps
- Can be scheduled using cron for automated maintenance

---

## Cron Schedule Examples

Daily log rotation (2:00 AM)

0 2 * * * /path/to/log_rotate.sh /var/log/myapp

Weekly backup (Sunday 3:00 AM)

0 3 * * 0 /path/to/backup.sh /home/project /home/backups

Health check every 5 minutes

*/5 * * * * /path/to/health_check.sh

Daily maintenance

0 1 * * * /path/to/maintenance.sh

---

## Commands Used

- find
- gzip
- tar
- crontab
- date
- chmod
- mkdir
- ls
- echo

---

## Key Learnings

- Automated log rotation helps prevent disk space issues.
- Timestamped backups provide a reliable recovery mechanism.
- Cron automates repetitive maintenance tasks without manual intervention.
- Bash scripting can automate routine server administration efficiently.
- Validating inputs and handling errors makes scripts safer for production use.

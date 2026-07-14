#!/bin/bash

set -euo pipefail

LOGFILE="$HOME/maintenance.log"

LOG_DIRECTORY="$HOME/day19/logs"
SOURCE_DIRECTORY="$HOME/day19/source"
BACKUP_DIRECTORY="$HOME/day19/backups"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

log_message "Maintenance Started"

./log_rotate.sh "$LOG_DIRECTORY" >> "$LOGFILE" 2>&1

./backup.sh "$SOURCE_DIRECTORY" "$BACKUP_DIRECTORY" >> "$LOGFILE" 2>&1

log_message "Maintenance Completed"

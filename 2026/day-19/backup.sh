#!/bin/bash

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_directory> <backup_directory>"
    exit 1
fi

SOURCE="$1"
DEST="$2"

if [ ! -d "$SOURCE" ]; then
    echo "Source directory does not exist."
    exit 1
fi

mkdir -p "$DEST"

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

ARCHIVE="$DEST/backup-$TIMESTAMP.tar.gz"

echo "Creating backup..."

tar -czf "$ARCHIVE" "$SOURCE"

if [ -f "$ARCHIVE" ]; then
    echo "Backup created successfully."
    echo "Archive : $ARCHIVE"
    du -h "$ARCHIVE"
else
    echo "Backup failed."
    exit 1
fi

echo
echo "Removing backups older than 14 days..."

find "$DEST" -type f -name "*.tar.gz" -mtime +14 -delete

echo "Backup process completed."

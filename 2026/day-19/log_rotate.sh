#!/bin/bash

set -euo pipefail

LOG_DIR="$1"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_directory>"
    exit 1
fi

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory '$LOG_DIR' does not exist."
    exit 1
fi

compressed=0
deleted=0

echo "Starting log rotation..."

while IFS= read -r file
do
    gzip "$file"
    ((compressed++))
done < <(find "$LOG_DIR" -type f -name "*.log" -mtime +7)

while IFS= read -r file
do
    rm -f "$file"
    ((deleted++))
done < <(find "$LOG_DIR" -type f -name "*.gz" -mtime +30)

echo "----------------------------------"
echo "Compressed : $compressed file(s)"
echo "Deleted    : $deleted file(s)"
echo "Log rotation completed."

#!/bin/bash
# lib/logger.sh

log_message() {
    local message="$1"
    clean_message="$(printf '%s\n' "$message" | tr -d '\r')"
    echo "$clean_message" >> "$LOG_FILE"
}

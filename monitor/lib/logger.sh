#!/bin/bash
# lib/logger.sh

log_message() {
    local message="$1"
      echo "$message" >> "$LOG_FILE"
}

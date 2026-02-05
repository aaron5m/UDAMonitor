#!/usr/bin/env bash
set -euo pipefail

#######################################
# UDAMonitor - Basic Uptime Check Script
# Purpose: Check URL availability and log status
#######################################

SCRIPT_DIR=$(dirname "$(realpath "$0")")

#source helpers
SCRIPT_DIR=$(dirname "$0")
source "$SCRIPT_DIR/../lib/logger.sh"
source "$SCRIPT_DIR/../lib/http_check.sh"

LOG_FILE="$SCRIPT_DIR/../logs/monitor.log"
TEMP_LOG="$SCRIPT_DIR/../tmp/temp_headers.log"

URL="${1:-}"

if [[ -z "$URL" ]]; then
    echo "No URL provided"
    exit 1
fi

msg="$(check_url "$URL")"
log_message "$msg"

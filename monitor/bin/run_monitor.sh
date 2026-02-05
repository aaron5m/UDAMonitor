#!/usr/bin/env bash
set -euo pipefail

#######################################
# UDAMonitor - Basic Uptime Check Script
# Purpose: Check URL availability and log status
#######################################

SCRIPT_DIR=$(dirname "$(realpath "$0")")

#source helpers
SCRIPT_DIR=$(dirname "$0")
#source "$SCRIPT_DIR/../lib/logger.sh"
source "$SCRIPT_DIR/../lib/http_check.sh"
source "$SCRIPT_DIR/../lib/parse_urls.sh"

LOG_FILE="$SCRIPT_DIR/../logs/monitor.log"
TEMP_LOG="$SCRIPT_DIR/../tmp/temp_headers.log"
URL_FILE="$SCRIPT_DIR/../config/urls.txt"

# Parse Urls and intervals
result=$(parse_urls "$URL_FILE")
urls_str="${result%%|*}"
intervals_str="${result##*|}"

# Convert strings back to arrays
IFS=' ' read -r -a urls <<< "$urls_str"
IFS=' ' read -r -a intervals <<< "$intervals_str"

for i in "${!urls[@]}"; do
    echo "${urls[$i]}"
    check_url "${urls[$i]}"
    # log_message "${urls[$i]} - HTTP $status" "$LOG_FILE"
done

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

# Convert a URL into a safe log filename
url_to_logfile() {
    local url="$1"
    local filename
    local prefix=""

    # Detect scheme
    if [[ "$url" == https://* ]]; then
        prefix="s-"
        filename="${url#https://}"
    elif [[ "$url" == http://* ]]; then
        filename="${url#http://}"
    else
        # No scheme (edge case)
        filename="$url"
    fi

    # Replace dots with dashes
    filename="${filename//./-}"

    # Replace remaining unsafe characters with underscores
    filename="$(echo "$filename" | sed 's|[:/?&=]|_|g')"

    # Emit final filename
    echo "${prefix}${filename}.log"
}

# Prepare log file and temp file
URL="${1:-}"
LOG_FILE="$SCRIPT_DIR/../logs/$(url_to_logfile "$URL")"

if [[ -z "$URL" ]]; then
    echo "No URL provided"
    exit 1
fi

# Run the http check and log the output and cleanup the tmp file
msg="$(check_url "$URL")"
log_message "$msg"

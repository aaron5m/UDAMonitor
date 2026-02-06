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

    # Strip scheme (http:// or https://)
    filename="${url#http://}"
    filename="${filename#https://}"

    # Replace dots with dashes and any remaining unsafe chars with underscores
    filename="${filename//./-}"
    filename="$(echo "$filename" | sed 's|[:/?&=]|_|g')"

    # Append .log
    echo "$filename.log"
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

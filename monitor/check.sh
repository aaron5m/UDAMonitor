#!/usr/bin/env bash
set -euo pipefail

#######################################
# UDAMonitor - Basic Uptime Check Script
# Purpose: Check URL availability and log status
#######################################

URL="${1:-}"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/monitor.log"
TEMP_LOG="$LOG_DIR/temp_headers.log"

#######################################
# Helpers
#######################################

usage() {
  echo "Usage: $0 <url>"
  exit 1
}

ensure_log_dir() {
  mkdir -p "$LOG_DIR"
}

fetch_headers() {
  curl -s -L -D "$TEMP_LOG" -o /dev/null "$URL"
}

extract_http_statuses() {
  grep -Eo '^HTTP/[0-9\.]+\s+[0-9]{3}' "$TEMP_LOG" \
    | awk '{print $2}'
}

extract_redirect_locations() {
  grep -Ei '^Location:' "$TEMP_LOG" \
    | awk '{print $2}'
}

extract_final_status() {
  extract_http_statuses | tail -n 1
}

count_redirects() {
  local total
  total="$(extract_http_statuses | wc -l)"
  echo $(( total - 1 ))  # subtract final response
}

log_result() {
  local timestamp status state redirects

  timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
  status="$1"
  redirects="$2"

  if [ "$status" -eq 200 ]; then
    state="UP"
  else
    state="DOWN"
  fi

  echo "$timestamp | $URL | $state | HTTP $status | redirects=$redirects" \
   >> "$LOG_FILE"
}

cleanup() {
  rm -f "$TEMP_LOG"
}

#######################################
# Main
#######################################

if [ -z "$URL" ]; then
  usage
fi

ensure_log_dir
fetch_headers

HTTP_STATUS="$(extract_final_status)"
REDIRECT_COUNT="$(count_redirects)"

if [[ ! "$HTTP_STATUS" =~ ^[0-9]+$ ]]; then
  echo "ERROR: Could not determine HTTP status"
  cleanup
  exit 1
fi

log_result "$HTTP_STATUS" "$REDIRECT_COUNT"
cleanup

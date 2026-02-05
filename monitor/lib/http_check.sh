#!/bin/bash
# lib/http_check.sh

#######################################
# Helpers
#######################################

fetch_headers() {
  curl -s -L -D "$TEMP_LOG" -o /dev/null "$1"
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

#######################################
# Main Utility
#######################################

check_url() {
    local url timestamp status redirects
    url="$1"
    timestamp="$(date +"%Y-%m-%d %H:%M:%S")"

    fetch_headers "$url"
    status="$(extract_final_status)"
    redirects="$(count_redirects)"

    echo "$timestamp | $url | HTTP $status | redirects=$redirects"
}

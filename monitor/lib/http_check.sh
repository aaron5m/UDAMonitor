#!/bin/bash
# lib/http_check.sh

#######################################
# Helpers
#######################################

TEMP_LOG="$SCRIPT_DIR/../tmp/temp_headers.log"

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

extract_final_url() {
  extract_redirect_locations | tail -n 1
}

count_redirects() {
  local total
  total="$(extract_http_statuses | wc -l)"
  echo $(( total - 1 ))  # subtract final response
}

# Builds arrays of redirect statuses and locations from the TEMP_LOG
# Exports two global arrays: REDIRECT_STATUSES and REDIRECT_LOCATIONS
build_redirects_array() {
    REDIRECT_STATUSES=()
    REDIRECT_LOCATIONS=()

    while IFS= read -r line; do
        [[ -n "$line" ]] && REDIRECT_STATUSES+=("$line")
    done < <(extract_http_statuses)

    while IFS= read -r line; do
        [[ -n "$line" ]] && REDIRECT_LOCATIONS+=("$line")
    done < <(extract_redirect_locations)
}


cleanup() {
  rm -f "$TEMP_LOG"
}

#######################################
# Main Utility
#######################################

check_url() {
    local url="$1"
    local timestamp
    timestamp="$(date +"%Y-%m-%dT%H:%M:%S")"

    # Temporary arrays for this check
    local redirect_count final_status final_url err_msg
    err_msg=""

    # Try to fetch headers and follow redirects
    if ! fetch_headers "$url"; then
        err_msg="error=failed_to_fetch_headers"
        final_status="N/A"
        final_url="$url"
    else
        # Build arrays of redirect statuses and locations
        build_redirects_array
        redirect_count="$(count_redirects)"

        if (( ${#REDIRECT_STATUSES[@]} > 0 )); then
            final_status="$(extract_final_status)"
        else
            final_status="N/A"
        fi

        if (( ${#REDIRECT_LOCATIONS[@]} > 0 )); then
            final_url="$(extract_final_url)"
        else
            final_url="$url"
        fi

    fi

    # Echo in line-based key=value format
    echo "timestamp=$timestamp url=$url final_url=$final_url final_status=$final_status redirect_count=$redirect_count ${err_msg}"

    cleanup
}




#!/bin/bash
# lib/http_check.sh

#######################################
# Helpers
#######################################

TEMP_LOG="$SCRIPT_DIR/../tmp/temp_headers.log"

fetch_headers() {
    local url="$1"
    # curl -s = silent, -L = follow redirects, -D = write headers to TEMP_LOG, -o /dev/null = discard body
    # -w = write out total time (latency) at end
    curl -s -L -D "$TEMP_LOG" -o /dev/null -w "%{time_total}" "$url"
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
    local redirect_count final_status final_url err_msg redirect_locations redirect_statuses delimiter
    err_msg=""
    redirect_locations=""
    redirect_statuses=""
    delimiter="|"
    
    # Fetch headers and measure latency
    latency=$(fetch_headers "$url") || {
        err_msg="failed_to_fetch_headers"
        final_status="N/A"
        final_url="$url"
        redirect_count=0
        latency="N/A"
    }

    # If fetch was successful, build redirect arrays
    if [[ -z "$err_msg" ]]; then
    
        redirect_count="$(count_redirects)"
        final_status="$(extract_final_status)"

        build_redirects_array
        
        if (( ${#REDIRECT_LOCATIONS[@]} > 0 )); then
            final_url="$(extract_final_url)"
            redirect_locations=$(IFS="$delimiter"; echo "${REDIRECT_LOCATIONS[*]}")
            redirect_statuses=$(IFS="$delimiter"; echo "${REDIRECT_STATUSES[*]}")

        else
            final_url="$url"
        fi

    fi
    
    #Echo in line-based key=value format
    echo "timestamp=$timestamp url=$url final_url=$final_url final_status=$final_status redirect_count=$redirect_count latency=$latency redirect_locations=$redirect_locations redirect_statuses=$redirect_statuses err_msg=$err_msg"

    cleanup
}




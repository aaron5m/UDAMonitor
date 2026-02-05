#!/bin/bash
# lib/parse_urls.sh

parse_urls() {
    local url_file="$1"
    local urls=()
    local intervals=()

    while read -r line || [[ -n "$line" ]]; do
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue

        url=$(echo "$line" | awk '{print $1}')
        interval=$(echo "$line" | awk '{print $2}')

        urls+=("$url")
        intervals+=("$interval")
    done < "$url_file"

    # Return arrays by printing with a delimiter
    # Use | as delimiter; caller will split
    echo "${urls[*]}|${intervals[*]}"
}

#!/usr/bin/env bash
# lib/parse_urls.sh

parse_urls() {
    local url_file="$1"

    while read -r url interval; do
        [[ -z "$url" ]] && continue
        [[ "$url" =~ ^# ]] && continue
        
        if [[ -z "$interval" ]]; then
            echo "Invalid entry in $url_file: missing interval for $url" >&2
            continue
        fi

        echo "$url $interval"
    done < "$url_file"
}

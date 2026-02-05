#!/usr/bin/env bash
# lib/verify_runtime_dirs.sh

verify_runtime_dirs() {
    local base_dir="$1"

    for dir in "$base_dir/logs" "$base_dir/tmp"; do
        if [[ ! -d "$dir" ]]; then
            echo "Creating directory: $dir"
            mkdir -p "$dir"
        fi

        if [[ ! -w "$dir" ]]; then
            echo "ERROR: Directory not writable: $dir" >&2
            exit 1
        fi
    done
}


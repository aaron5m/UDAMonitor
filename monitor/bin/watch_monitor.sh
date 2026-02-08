#!/usr/bin/env bash
set -euo pipefail

#######################################
# UDAMonitor - Log Viewer
# Human-friendly console output
# whipped together for fun
#######################################


SCRIPT_DIR=$(dirname "$(realpath "$0")")
LOG_DIR="$SCRIPT_DIR/../logs"
LINES=5

if [[ ! -d "$LOG_DIR" ]]; then
    echo "Log directory not found: $LOG_DIR"
    exit 1
fi

shopt -s nullglob
log_files=("$LOG_DIR"/*.log)
shopt -u nullglob

if (( ${#log_files[@]} == 0 )); then
    echo "No log files found."
    exit 0
fi

echo -e "\n"

for logfile in "${log_files[@]}"; do
    filename="$(basename "$logfile")"

    echo "================================================================"
    echo " Site: $filename (5 most recent log entries)"
    echo "================================================================"

    tail -n "$LINES" "$logfile" \
        | tr -d '\r' \
        | awk '
            {
                ts = url = final_url = status = latency = "?"

                for (i = 1; i <= NF; i++) {
                    split($i, kv, "=")
                    key = kv[1]
                    value = substr($i, length(key) + 2)

                    if (key == "timestamp")        ts = value
                    else if (key == "url")         url = value
                    else if (key == "final_url")   final_url = value
                    else if (key == "final_status") status = value
                    else if (key == "latency")     latency = value
                    else if (key == "redirect_statuses")     statuses = value
                    else if (key == "err_msg")     err_msg = value
                }

                gsub("T", " at ", ts)
                gsub(/[^|]*$/, "", statuses)

                #printf "\n" ts "\n"
                printf "\033[1m%s\033[0m\n", ts
                #printf " \033[1;37;40m %s \033[0m", url
                printf "\033[1;37;40m%s\033[0m", url
                printf " -> " statuses
                printf "\033[1;37;40m %s \033[0m\n", status
                printf "  -> " final_url " in "
                printf "\033[1m%s\033[0m", latency
                printf " seconds " err_msg "\n"

            }
        '
        
    echo
done


#!/usr/bin/env bash
set -euo pipefail

#######################################
# UDAMonitor - Setup Script
# Installs or updates cron jobs
#######################################

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Step 0: remove any existing UDAMonitor cron jobs
chmod +x "$SCRIPT_DIR/stop_monitor.sh"
"$SCRIPT_DIR/stop_monitor.sh"

# Helpers
source "$SCRIPT_DIR/../lib/parse_urls.sh"

URL_FILE="$SCRIPT_DIR/../config/urls.txt"
RUN_SCRIPT="$SCRIPT_DIR/run_monitor.sh"
CRON_TMP="$SCRIPT_DIR/../tmp/udamonitor_cron.$$"

chmod +x "$RUN_SCRIPT"

# Load existing crontab (or empty)
crontab -l 2>/dev/null > "$CRON_TMP" || true

parse_urls "$URL_FILE" | while read -r url interval; do
    marker="#UDAMonitor:$url"
    new_job="*/$interval * * * * $RUN_SCRIPT $url $marker"

    if grep -q "$marker" "$CRON_TMP"; then
        existing_interval=$(grep "$marker" "$CRON_TMP" | awk '{print $1}' | cut -d'/' -f2)

        if [[ "$existing_interval" == "$interval" ]]; then
            echo "Cron job for $url already up to date"
            continue
        else
            echo "Updating cron job for $url ($existing_interval → $interval)"
            grep -v "$marker" "$CRON_TMP" > "${CRON_TMP}.new"
            mv "${CRON_TMP}.new" "$CRON_TMP"
        fi
    else
        echo "Adding cron job for $url (every $interval minutes)"
    fi

    echo "$new_job" >> "$CRON_TMP"
done

crontab "$CRON_TMP"
rm "$CRON_TMP"

echo "UDAMonitor cron jobs installed/updated."



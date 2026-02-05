#!/usr/bin/env bash
set -euo pipefail

#######################################
# UDAMonitor - Teardown Script
# Removes all UDAMonitor cron jobs
#######################################

SCRIPT_DIR=$(dirname "$(realpath "$0")")

CRON_TMP="$SCRIPT_DIR/../tmp/udamonitor_cron.$$"

# Load current crontab (or empty)
crontab -l 2>/dev/null > "$CRON_TMP" || true

# Remove UDAMonitor jobs
grep -v -E "#UDAMonitor:" "$CRON_TMP" > "${CRON_TMP}.new" || true

# Install updated crontab or remove if empty
if [[ -s "${CRON_TMP}.new" ]]; then
    crontab "${CRON_TMP}.new"
else
    crontab -r 2>/dev/null || true
fi

rm -f "$CRON_TMP" "${CRON_TMP}.new"

echo "UDAMonitor cron jobs removed."



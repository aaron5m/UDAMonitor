#!/usr/bin/env bash
set -euo pipefail

#######################################
# UDAMonitor - Basic Uptime Check Script
# Purpose: Check URL availability and log status
#######################################

URL="${1:-}"
SCRIPT_DIR=$(dirname "$(realpath "$0")")

#######################################
# Helpers
#######################################

usage() {
  echo "Usage: $0 <url>"
  exit 1
}

#######################################
# Main
#######################################

if [ -z "$URL" ]; then
  usage
fi

cron_exists=$(crontab -l 2>/dev/null || true)
if [ -z "$cron_exists" ]; then
  echo "You have no cron jobs."
  exit
fi

crontab -l | grep -v "$SCRIPT_DIR/start_monitor.sh" | crontab -
echo "Cron job has been removed."

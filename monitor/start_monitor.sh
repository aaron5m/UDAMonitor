#!/usr/bin/env bash
set -euo pipefail

#######################################
# UDAMonitor - Basic Uptime Check Script
# Purpose: Check URL availability and log status
#######################################

URL="${1:-}"
minutes="${2:-}"
CRON_ADD_INTERVAL="*/$minutes * * * * $PWD/start_udamonitor.sh"

#######################################
# Helpers
#######################################

usage() {
  echo "Usage: $0 <url> <minutes>"
  exit 1
}

set_or_ensure_cron() {
  local interval cron_exists job_exists
  interval="$CRON_ADD_INTERVAL"
  cron_exists=$(crontab -l 2>/dev/null || true)
  
  if [ -z "$cron_exists" ]; then
    (echo "$interval") | crontab -
    # Add the cron job if it doesn't exist
    #((crontab -l 2>/dev/null || true); echo "$interval") | crontab -
    echo "Cron job has been set up to run every $minutes minutes."
  else
    job_exists=$(crontab -l | grep "$PWD/start_udamonitor.sh")
    if [ -z "$job_exists" ]; then
      (crontab -l 2>/dev/null; echo "$interval") | crontab -
    else
      echo "Cron job is already set up."
    fi
  fi
}

run_checker() {
  local website
  website="$1"
  bash check.sh "$website"
}

#######################################
# Main
#######################################

if [[ -z "$URL" ]] || [[ -z "$minutes" ]]; then
  usage
fi

set_or_ensure_cron

exit
run_checker "$URL"

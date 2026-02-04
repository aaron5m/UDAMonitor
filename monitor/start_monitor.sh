#!/usr/bin/env bash
set -euo pipefail

#######################################
# UDAMonitor - Basic Uptime Check Script
# Purpose: Check URL availability and log status
#######################################

URL="${1:-}"

#######################################
# Helpers
#######################################

usage() {
  echo "Usage: $0 <url>"
  exit 1
}

run_checker() {
  local website
  website="$1"
  bash check.sh "$website"
}

#######################################
# Main
#######################################

if [ -z "$URL" ]; then
  usage
fi

run_checker "$URL"

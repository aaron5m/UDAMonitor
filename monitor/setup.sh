#!/usr/bin/env bash
set -euo pipefail

#######################################
# UDAMonitor - Basic Uptime Check Script
# Purpose: Check URL availability and log status
#######################################

SCRIPT_DIR=$(dirname "$(realpath "$0")")
chmod 755 "$SCRIPT_DIR"

chmod +x "$SCRIPT_DIR/start_monitor.sh"
chmod +x "$SCRIPT_DIR/check.sh"
chmod +x "$SCRIPT_DIR/stop_monitor.sh"

chmod 755 "$SCRIPT_DIR/logs/monitor.log"



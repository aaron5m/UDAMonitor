#!/bin/bash

# UDAMonitor - Simple uptime check script

# URL to check (first argument passed to the script)
URL=$1

# Check if URL is provided
if [ -z "$URL" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

# Log file
LOG_FILE="logs/uptime_log.txt"

# Temporary file to capture the curl verbose output
TEMP_LOG="logs/temp_log.txt"

# Perform the uptime check, following redirects and logging verbose output
curl -s -D "$TEMP_LOG" -o /dev/null -L "$URL"

# Check the final status code from the verbose output
HTTP_STATUS=$(grep -Eo '^HTTP/[0-9\.]+\s+[0-9]{3}' "$TEMP_LOG" | tail -n 1 | awk '{print $2}')

# Get the current timestamp
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Log the result (either up or down based on HTTP status)
if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "$TIMESTAMP - $URL - Status: UP (HTTP $HTTP_STATUS)" >> $LOG_FILE
else
    echo "$TIMESTAMP - $URL - Status: DOWN (HTTP $HTTP_STATUS)" >> $LOG_FILE
fi

# Log redirects (Location headers)
echo "Redirect Chain:" >> $LOG_FILE
grep "Location:" $TEMP_LOG >> $LOG_FILE

# Clean up the temporary log file
rm $TEMP_LOG

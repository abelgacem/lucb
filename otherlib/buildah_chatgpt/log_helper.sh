#!/bin/bash

# purpose: Log messages
# args: log_level, message
log_message() {
    local log_level="$1"
    local message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${log_level}: ${message}"
}

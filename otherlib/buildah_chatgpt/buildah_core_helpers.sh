#!/bin/bash

# purpose: Detect the operating system
# args: NONE
luc_detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [[ "$(uname)" == "Darwin" ]]; then
        echo "macos"  # Specific to macOS
    else
        log_message "ERROR" "Unsupported OS"
        exit 1
    fi
}

# purpose: Create a user in the container
# args: container_name, username
create_user() {
    local container_name="$1"
    local username="$2"

    log_message "INFO" "Creating user '${username}' in container '${container_name}'"
    buildah run "${container_name}" useradd -m -s /bin/bash "${username}"
}

# purpose: Create a workspace directory structure
# args: container_name, username
create_workspace() {
    local container_name="$1"
    local username="$2"

    log_message "INFO" "Creating workspace in container '${container_name}' for user '${username}'"
    buildah run "${container_name}" mkdir -p "/home/${username}/wkspc"
}

# purpose: Log messages with a timestamp
# args: log_level, message
log_message() {
    local log_level="$1"
    local message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${log_level}: ${message}"
}

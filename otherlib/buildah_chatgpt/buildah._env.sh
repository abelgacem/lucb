#!/bin/bash

# Global environment variables for Buildah image creation process

# # Default image name
# export IMAGE_NAME="dev-image"

# # Base registry URL
# export REGISTRY_URL="docker.io"

# # Default base image
# export BASE_IMAGE="ubuntu:20.04"

# # Version or tag for the image
# export IMAGE_VERSION="latest"

# # Default buildah flags
# export BUILD_FLAGS="--no-cache"

# # Other useful environment variables
# export LOG_FILE="/var/log/buildah_image_creation.log"

# Define variable sLIB if folder name differs
export lLIB="buildah"

# Define description variable
export lDESC="create container image by wrapping buildah CLI"

# Check if Buildah CLI exists
lCLI='buildah'
lECHOVAL=$(luc_core_check_cli_is_installed $lCLI)
lRETVAL=$?
if [ 0 -ne "$lRETVAL" ]; then
    echo "$lECHOVAL"
    return 1
fi

# Define environment variable for image root list
export luc_EV_CIMB_IMAGE_ROOT_LIST="
    ubuntu:25.04
    rockylinux:9.3
    almalinux:9.5
    alpine:3.21
    gcr.io/kaniko-project/executor:v1.23.2
    registry:2.8.3
"

return 0









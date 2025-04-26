#!/bin/bash

# purpose: Create and configure container images using Buildah
# args: image_name, base_image

luc_buildah_image_create() {
    local image_name="$1"
    local base_image="$2"

    log_message "INFO" "Creating image '${image_name}' based on '${base_image}'"
    buildah from --name "${image_name}" "${base_image}"
}

luc_buildah_image_finalize() {
    local container_name="$1"
    local image_name="$2"

    log_message "INFO" "Committing container '${container_name}' to image '${image_name}'"
    buildah commit "${container_name}" "${image_name}"
}


# Function to check if an image exists using buildah
# purpose: Checks if a given image exists in the Buildah local image store
# args: $1 - image name (e.g., "ubuntu:latest")
function image_exists() {
  local image="$1"
  buildah inspect "$image" &>/dev/null
  if [ $? -ne 0 ]; then
    log_message "ERROR: Image '$image' does not exist." "ERROR"
    exit 1
  else
    log_message "INFO: Image '$image' exists." "INFO"
  fi
}


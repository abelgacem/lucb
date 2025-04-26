#!/bin/bash

# Include the helper functions and the image creation logic
source buildah_image_helpers.sh
source buildah.image.create.sh

# Function to create a development image
# purpose: Creates a dev image based on a given base image and environment-specific configurations
# args: $1 - base image (e.g., ubuntu:20.04)
function create_dev_image() {
  local environment="dev"
  local image_name="dev"
  local base_image="$1"
  
  create_image "$environment" "$image_name" "$base_image"
}

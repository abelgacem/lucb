#!/bin/bash
source buildah._env.sh
source buildah_image_helpers.sh
source buildah_core_helpers.sh

# purpose: Generic function to create a Buildah-based image
# args: image_name, base_image, user(optional), workspace(optional)
luc_buildah_generic_create() {
    local image_name="$1"
    local base_image="$2"
    local user="$3"
    local workspace="$4"

    log_message "INFO" "Creating generic image '${image_name}' based on '${base_image}'"

    # Create the base container
    luc_buildah_image_create "$image_name" "$base_image"

    # If user is provided, create it
    if [[ -n "$user" ]]; then
        create_user "$image_name" "$user"
    fi

    # If workspace is provided, create it
    if [[ -n "$workspace" ]]; then
        create_workspace "$image_name" "$user"
    fi

    # Finalize image
    luc_buildah_image_finalize "$image_name" "$image_name-custom"

    log_message "SUCCESS" "Image '${image_name}' successfully created."
}

# Example usage
# luc_buildah_generic_create "custom-image" "ubuntu:25.04" "developer" "/home/developer/wkspc"

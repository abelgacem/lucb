#!/bin/bash
source buildah._env.sh
source buildah_image_helpers.sh
source buildah_core_helpers.sh

# purpose: Create a golden image
# args: image_name, base_image
luc_buildah_image_create_golden() {
    local image_name="$1"
    local base_image="$2"

    luc_buildah_image_create "$image_name" "$base_image"
    create_user "$image_name" "developer"
    create_workspace "$image_name" "developer"
    luc_buildah_image_finalize "$image_name" "$image_name-golden"
}

luc_buildah_image_create_golden "golden-image" "ubuntu:25.04"

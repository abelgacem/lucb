#purpose: containerized cli to test image building
mmx_old_cil_kaniko_image_test_build () { 
  local lIMAGE=${gsIMAGE_KANIKO}
  lFOLDER_HOST_DOCKERFILE="/tmp/kaniko"
  lFOLDER_CONT_DOCKERFILE="/workspace"
  #
  luc_core_echo "info" "build a test image"
  luc_core_echo "info" "- using Dockerfile: ${lFOLDER_HOST_DOCKERFILE}/Dockerfile"
  luc_core_echo "info" "- using kaniko image: $lIMAGE"
  #
  docker run -it --rm  \
     -v "${lFOLDER_HOST_DOCKERFILE}":"${lFOLDER_CONT_DOCKERFILE}" \
     $lIMAGE \
     --dockerfile "${lFOLDER_CONT_DOCKERFILE}/Dockerfile" \
     --context dir://${lFOLDER_CONT_DOCKERFILE}/  \
     --no-push
}


#purpose: build and push image to a private registry
mmx_old_cil_kaniko_image_buildandpush () { 
  local lIMAGE=${gsIMAGE_KANIKO}
  local lREGISTRY=${gsSERVICE_REGISTRY_IP}:${gsSERVICE_REGISTRY_HOST_PORT}
  local lVOLUME_REGISTRY="${gsNAME_REGISTRY_DOCKER_VOLUME}"
  local lFOLDER_HOST_DOCKERFILE="/tmp/kaniko"
  local lFOLDER_CONT_DOCKERFILE="/workspace"
  local lIMLAGE_FULL_NAME='alpine:latest'
  
  # check dependency: registry service is running
  luc_core_echo "info" "check registry service is running"
  mmx_old_cil_registry_service_check || {
    luc_core_echo "warn" "registry service is not running"
    return 1
    } && {
    luc_core_echo "done" "registry service is running"
  }
  # 
  luc_core_echo "info" "build and push image to registry"
  luc_core_echo "info" "- using Dockerfile: ${lFOLDER_HOST_DOCKERFILE}/Dockerfile"
  luc_core_echo "info" "- using kaniko image: $lIMAGE"
  luc_core_echo "info" "- using registry: $lREGISTRY"
  #
  docker run -it --rm  \
     -v "${lFOLDER_HOST_DOCKERFILE}":"${lFOLDER_CONT_DOCKERFILE}" \
     -v "${lVOLUME_REGISTRY}":"/var/lib/registry" \
     --network host  \
     $lIMAGE \
     --dockerfile "${lFOLDER_CONT_DOCKERFILE}/Dockerfile" \
     --context dir://${lFOLDER_CONT_DOCKERFILE}/  \
     --destination "$lREGISTRY/${lIMLAGE_FULL_NAME}"
}

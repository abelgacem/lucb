# purpose : check registry service is running
mmx_old_cil_registry_service_check() {
  local lNAME_CONTAINER_REGISTRY_SERVICE="${gsNAME_CONT_SERVICE_REGISTRY_DOCKER}"
  docker container inspect "${lNAME_CONTAINER_REGISTRY_SERVICE}" &> /dev/null && return 0 || return 1
}
# purpose : start local private docker registry
mmx_old_cil_registry_service_start() {
  # define var
  local lIMAGE="${gsIMAGE_DOCKER_REGISTRY}"    
  local lVOLUME_REGISTRY="${gsNAME_REGISTRY_DOCKER_VOLUME}"
  local lNAME_CONTAINER_REGISTRY_SERVICE="${gsNAME_CONT_SERVICE_REGISTRY_DOCKER}"
  
  # create volume
  mmx_old_cil_registry_volume_create

  # create container if not created
  luc_core_echo "info" "Create container registry service"
  luc_core_echo "info" "- using registry image: $lIMAGE"
  luc_core_echo "info" "- using docker volume:  ${lVOLUME_REGISTRY}"
  # check container already exists else create
  docker container inspect "${lNAME_CONTAINER_REGISTRY_SERVICE}" &> /dev/null && {
    luc_core_echo "done" "- already done"
    luc_core_echo "done" "- status service is $(docker inspect -f '{{.State.Status}}' ${lNAME_CONTAINER_REGISTRY_SERVICE})"
    } || {
    docker run -d -p ${gsSERVICE_REGISTRY_HOST_PORT}:${gsSERVICE_REGISTRY_CONT_PORT} \
      -v mx-docker-registry:/var/lib/registry \
      --name ${gsNAME_CONT_SERVICE_REGISTRY_DOCKER}  \
      --restart always         \
      $lIMAGE
    luc_core_echo "info" "service started" 
  }
}

mmx_old_cil_registry_service_stop() {
  local lNAME_CONTAINER_REGISTRY_SERVICE="${gsNAME_CONT_SERVICE_REGISTRY_DOCKER}"

  luc_core_echo "info" "Stop container registry service"
  luc_core_echo "info" "- using container service: ${lNAME_CONTAINER_REGISTRY_SERVICE}"
  # check container already exists else create
  docker container inspect "${lNAME_CONTAINER_REGISTRY_SERVICE}" &> /dev/null && {
    docker container stop ${lNAME_CONTAINER_REGISTRY_SERVICE}
    docker container rm   ${lNAME_CONTAINER_REGISTRY_SERVICE}
    luc_core_echo "info" "registry service stopped"
  } || {
    luc_core_echo "done" "- already done"
  }
}

mmx_old_cil_registry_volume_delete() {
  # declare var  
  local lVOLUME_REGISTRY="${gsNAME_REGISTRY_DOCKER_VOLUME}" 
  #
  luc_core_echo "info" "Delete volume: ${lVOLUME_REGISTRY}" 
  mmx_docker_volume_delete ${lVOLUME_REGISTRY} && {
    luc_core_echo "done" "- done"
    } || {
    luc_core_echo "warn" "- volume not created" 
    return 1
  }
}

mmx_old_cil_registry_volume_create() {
  # declare var  
  local lVOLUME_REGISTRY="${gsNAME_REGISTRY_DOCKER_VOLUME}" 
  #
  # create volume if not exists
  luc_core_echo "info" "Create volume: ${lVOLUME_REGISTRY}" 
  mmx_docker_volume_create ${lVOLUME_REGISTRY} && {
    luc_core_echo "done" "- done" 
    } || {
    luc_core_echo "warn" "- volume not created" 
    return 1
  }
}

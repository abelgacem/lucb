luc_docker_volume_create () { 
  # define var from input
  lNAME_VOLUME="$1"
  
  # check areg is provided
  [ -z "$1" ] && return 1 ;

  # create volume oinly if it not exists
  docker volume ls -q -f name="$lNAME_VOLUME" | grep -q "$lNAME_VOLUME" || {
    docker volume create "$lNAME_VOLUME"
    return 0
  }
}

luc_docker_volume_delete () { 
  # define var from input
  lNAME_VOLUME="$1"
  
  # check areg is provided
  [ -z "$1" ] && return 1 ;

  # delete volume only if it exists
  docker volume ls -q -f name="$lNAME_VOLUME" | grep -q "$lNAME_VOLUME" && {
    docker volume rm "$lNAME_VOLUME"
    return 0
  }
}

luc_docker_volume_list () { 
  docker volume list
}


  # # check volume if not exists
  # luc_core_echo "info" "Create volume: ${lVOLUME_REGISTRY}"
  # docker volume ls -q -f name="$lVOLUME_REGISTRY" | grep -q "$lVOLUME_REGISTRY" && {
  #   luc_core_echo "inf2" "- already done"
  #   } || {
  #   docker volume create "$VOLUME_NAME"
  #   luc_core_echo "info" "volume created" 
  # }

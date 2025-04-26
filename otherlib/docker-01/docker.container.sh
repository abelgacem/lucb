#!/bin/bash

luc_docker_container_delete_all() {
  # before
  docker container list
  # confirm
  lMSG01="delete all docker containers"
  lMSG02="all docker containers deleted"
  read -p "mx > WARNING    > $lMSG01 (y) ? " lUSER_INPUT && [ ! "y" == "${lUSER_INPUT}" ] && echo "done nothing" && return
  echo "mx > INFO    > $lMSG02" 
  # delete
  docker container rm -f $(docker container list -aq)
  # after
  docker container list
}

luc_docker_container_enter () {
  ## from method:input
  lCONTAINER_SHORT_ID="$1"

  [ $# -eq 0 ] && {
    echo 
    echo "name:      ${FUNCNAME[0]}"
    echo "purpose:   enter in a docker container and run a shell"
    echo "input \$1: image name"
    echo "input \$1: can be >"
    echo "$(docker container list  --format "{{.Image}} : {{.Names}} : {{.ID}}")"
    echo 
    return
  }

  # define var
  local lLIST_CONTAINER=$(docker container list -a --format {{.Names}}:{{.ID}})
  local lLIST_IMAGE=$(    docker container list -a --format {{.Image}}:{{.ID}})

  # check: container exists
  local lCONTAINER_ID="$(cut -d':' -f2 <<< "${lLIST_CONTAINER}" | grep ^${lCONTAINER_SHORT_ID})"
  [ -z "$lCONTAINER_ID" ] && echo "mx > WARNING > provided container id not exists: $lCONTAINER_SHORT_ID" && return

  # define var
  local lIMAGE_NAME="$(    grep ${lCONTAINER_ID} <<< "${lLIST_IMAGE}"    | cut -d':' -f1-2 )"
  local lCONTAINER_NAME="$(grep ${lCONTAINER_ID} <<< "${lLIST_CONTAINER}"| cut -d':' -f1 )"
  local lIMAGE_OS="$(docker inspect --format '{{json .Config.Env}}' "$lIMAGE_NAME" | jq -r '.[]' | grep "gdk_NAME_OS" | cut -d'=' -f2)"
  [ "alpine" == "$lIMAGE_OS" ] && lIMAGE_SHELL="/bin/sh" || lIMAGE_SHELL="/bin/bash"

  # debug info
  echo "mx > debug > lIMAGE_NAME     = $lIMAGE_NAME"
  echo "mx > debug > lCONTAINER_NAME = $lCONTAINER_NAME"
  echo "mx > debug > lIMAGE_OS       = $lIMAGE_OS"
  echo "mx > debug > lIMAGE_SHELL    = $lIMAGE_SHELL"
  # cli
  local lCLI="docker exec -it ${lCONTAINER_ID} ${lIMAGE_SHELL} -l"
  # play cli 
  # echo $lCLI
  eval $lCLI
}  

luc_docker_container_list() {
  docker container list -a
}

luc_docker_container_stop() {
  lNAME_CONTAINER="$1"
  
  # check areg is provided
  [ -z "$1" ] && return 1 ;

  # check container already exists else stop
  docker container inspect "${lNAME_CONTAINER_REGISTRY_SERVICE}" &> /dev/null && {
    docker container stop ${lNAME_CONTAINER_REGISTRY_SERVICE}
    docker container rm   ${lNAME_CONTAINER_REGISTRY_SERVICE}
    return O
  }
  return O
}

# shortcut
luc_cim_create_container() { luc_cim_container_create "$@"; }
luc_cim_enter_container()  { luc_cim_container_enter  "$@";  }
luc_cim_delete_container() { luc_cim_delete "--container" "$@"; }
luc_cim_container_delete() { luc_cim_delete "--container" "$@"; }
luc_cim_container_property_get() { luc_cim_property_get "--container" "$@"; }

# purpose: create a container from an image
# args: <CONTAINER_NAME> <IMAGE_SID> [OPTIONS]
luc_cim_container_create() {
  local lCONTAINER_NAME="$1"
  local lIMAGE_SID="$2"
  local lIMAGE_ID='' 
  local lOPTIONS='' 
  local lUSAGE_MSG="$(luc_core_method_name_get) <CONTAINER_NAME> <IMAGE_SID> [OPTIONS]"
  local lCIM_TOOL=''
  local lRUNNING_CDE=''

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1

  # info
  luc_core_echo "purp" "create a $lCIM_TOOL container from a $lCIM_TOOL image"

  # checkorexit args are provided
  [ -z "$lIMAGE_SID" ]       ||
  [ -z "$lCONTAINER_NAME" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12 test -v /tmp/luc:/test:ro" 
    return 1
  }

  # checkorexit image exists
  lECHOVAL=$(luc_cim_id_get --image  $lIMAGE_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ID="$lECHOVAL"

  # lookup field according to tool
  [ "$lCIM_TOOL" == "docker" ]  && {
    lACTION='run'
    lOPTION_DAEMON='-d'
    lRUNNING_CDE='tail -f /dev/null'
    lFIELD_NAME='Names'
  }
  [ "$lCIM_TOOL" == "buildah" ] && {
    lACTION='from'
    lOPTION_DAEMON=''
    lFIELD_NAME='ContainerName'
  }
  [ "$lCIM_TOOL" == "podman" ] && {
    lACTION='create'
    lOPTION_DAEMON=''
    lFIELD_NAME='ContainerName'
  }
  
  # checkorexit container not exists
  lECHOVAL=$($lCIM_TOOL ps --all --format "{{.${lFIELD_NAME}}}" | grep "^${lCONTAINER_NAME}"); lRETVAL=$?  
  [ ! -z "$lECHOVAL" ] && luc_core_echo "warn" "container ${lCONTAINER_NAME} already exists - will not recreate it"  && return 1

  # get the OPTIONS
  shift 2;lOPTIONS="$@"

  # info
  luc_core_echo "debu" "CLI > $lCIM_TOOL $lACTION --name ${lCONTAINER_NAME} ${lOPTION_DAEMON} $lOPTIONS $lIMAGE_ID ${lRUNNING_CDE}"
  # createorexit container
  lEHOVAL=$($lCIM_TOOL $lACTION --name ${lCONTAINER_NAME} ${lOPTION_DAEMON} $lOPTIONS $lIMAGE_ID ${lRUNNING_CDE} 2>&1); lRETVAL=$?
  [ "$lRETVAL" -eq 0 ] && {
    luc_core_echo "done" "Created container ${lCONTAINER_NAME} from image $lIMAGE_ID ($(luc_cim_property_get --image $lIMAGE_SIDfullname))"  
    return 0
  } || {
    luc_core_echo "warn" "cannot create container ${lCONTAINER_NAME} > $lEHOVAL"
    return 1
  }
}

# purpose: enter a container
# args: <CONTAINER_SID> [OPTIONS]
luc_cim_container_enter() {
  local lCONTAINER_SID="$1"
  local lUSAGE_MSG="$(luc_core_method_name_get) <CONTAINER_SID> [OPTIONS]"
  local lCIM_TOOL=''
  local lOPTIONS=''

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1

  # info
  luc_core_echo "purp" "enter a $lCIM_TOOL container"

  # checkorexit args are provided
  [ -z "$lCONTAINER_SID" ]       ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12"
    return 1
  }

  # checkorexit container exists
  lECHOVAL=$(luc_cim_id_get --container  $lCONTAINER_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_ID="$lECHOVAL"

  # TODO: getorexit container SHELL
  lECHOVAL=$(luc_cim_property_get --container  ${lCONTAINER_SID} SHELL); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lSHELL="$lECHOVAL"

  # getorexit container NAME
  lECHOVAL=$(luc_cim_property_get --container ${lCONTAINER_SID} name); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_NAME="$lECHOVAL"

  # getorexit container STATE
  lECHOVAL=$(luc_cim_property_get --container  ${lCONTAINER_SID} ISRUNNING); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_ISRUNNING="$lECHOVAL"

  # get OPTIONS
  shift 1; lOPTIONS=$@

  # info
  luc_core_echo "info" "enter container ${lCONTAINER_SID} ($lCONTAINER_NAME)"

  # when docker
  [ "$lCIM_TOOL" == "docker" ]  && {
    # if running container
    [ "$lCONTAINER_ISRUNNING" == "true" ] && {
      luc_core_echo "step" "enter running container ${lCONTAINER_SID}"
      luc_core_echo "debu" "lSHELL=$lSHELL"
      $lCIM_TOOL exec -it ${lCONTAINER_SID} $lSHELL -l
    } || {
    # if not running container
      local lIMAGE_NAME="temp$(luc_core_id_get 5):temp"
      # createorexit image
      luc_core_echo "info" "task > create temporary image > $lIMAGE_NAME"
      lECHOVAL=$(luc_cim_image_create ${lIMAGE_NAME} ${lCONTAINER_SID}); lRETVAL=$?  
      [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1
      # get - image:id
      lIMAGE_ID=$($lCIM_TOOL images -q ${lIMAGE_NAME})
      # enterorexit image
      luc_core_echo "info" "task > enter temporary image > $lIMAGE_NAME"
      luc_cim_image_enter $lIMAGE_ID
      # info      
      luc_core_echo "info" "task > delete temporary image > $lIMAGE_NAME"
      luc_cim_image_delete ${lIMAGE_NAME}
    }
  }

  # when buildah
  [ "$lCIM_TOOL" == "buildah" ] && {
    $lCIM_TOOL run $lOPTIONS -t ${lCONTAINER_SID} $lSHELL -l
  }  

  # when podman
  [ "$lCIM_TOOL" == "podman" ] && {
    luc_core_echo "debu" "podman exec $lOPTIONS -t ${lCONTAINER_SID} $lSHELL -l"  
    $lCIM_TOOL exec $lOPTIONS -t ${lCONTAINER_SID} $lSHELL -l
  }
  # info
  luc_core_echo "info" "exit from $lCIM_TOOL container ${lCONTAINER_SID}"
  return 0
}

# purpose: check a container exists
# args: <lCONTAINER_NAME>
luc_cim_container_check_exists() {
  local lCONTAINER_NAME="$1"
  local lUSAGE_MSG="$(luc_core_method_name_get) <lCONTAINER_NAME>"
  local lCIM_TOOL=''

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1

  # checkorexit args are provided
  [ -z "$lCONTAINER_NAME" ]       ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) ab12" 
    return 1
  }

  # lookup field according to object type
  [ "$lCIM_TOOL" == "docker" ]  && {
    lFIELD_NAME='Names'
    lFIELD_CONTAINERID='ID'
  }
  [ "$lCIM_TOOL" == "buildah" ] && {
    lFIELD_NAME='ContainerName'
    lFIELD_CONTAINERID='ContainerID'
  }

  # checkorexit container exists
  lRESULT=$($lCIM_TOOL ps --all --format "{{.${lFIELD_NAME}}}" | grep -w "^${lCONTAINER_NAME}" 2>/dev/null)
  [ -z "$lRESULT" ] && luc_core_echo "warn" "container not exists : ${lCONTAINER_NAME} "  && return 1
  
  # return
  return 0
}

# purpose: play a cli inside a container
# note: Docker: the container must be running
# args: <lCONTAINER_SID> <lCLI>
luc_cim_container_cli_play() {
  local lCONTAINER_SID="$1"
  local lCLI="$2"
  local lUSAGE_MSG="$(luc_core_method_name_get) <lCONTAINER_SID> <lCLI>"
  local lCIM_TOOL=''
  luc_core_echo "purp" "$(luc_core_method_name_get) > play CLI in [running] container"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  # luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1

  # lookup field according to tool
  [ "$lCIM_TOOL" == "docker" ]  && {
    lACTION='exec'
  }
  [ "$lCIM_TOOL" == "buildah" ] && {
    lACTION='run'
  }

  # checkorexit args are provided
  [ -z "$lCONTAINER_SID" ]       ||
  [ -z "$lCLI" ]       ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) ef12 /usr/local/bin/start" 
    return 1
  }
  # checkorexit container exists
  lECHOVAL=$(luc_cim_id_get --container  $lCONTAINER_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_ID="$lECHOVAL"

  # getorexit container NAME
  lECHOVAL=$(luc_cim_property_get --container  ${lCONTAINER_SID} NAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_NAME="$lECHOVAL"

  # getorexit container STATE - for docker
  lECHOVAL=$(luc_cim_property_get --container  ${lCONTAINER_SID} ISRUNNING); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_ISRUNNING="$lECHOVAL"

  # TODO : getorexit container SHELL via custom label
  lECHOVAL=$(luc_cim_property_get --container  ${lCONTAINER_SID} SHELL); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_SHELL="$lECHOVAL"

  # lCONTAINER_SHELL="/bin/bash"
  $lCIM_TOOL $lACTION ${lCONTAINER_SID} ${lCONTAINER_SHELL} -c "$lCLI"
  return $?
}


# docker run --name test  -d       ubuntu:latest tail -f /dev/null  
# docker run --name testo -d --label "os.shell=/bin/bash" 20e tail -f /dev/null

# purpose: create a running container from an image and a dummy loop as pid 1 process
# args: <CONTAINER_NAME> <IMAGE_SID> [OPTIONS]
luc_cimv2_container_create() {

  local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_NAME> <IMAGE_SID> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) test 12 -v /tmp/luc:/test:ro" 
  local lCONTAINER_NAME="$1"
  local lIMAGE_SID="$2"
  local lDUMMY_LOOP="${luc_EV_CIMV2_DUMMY_LOOP}"  
  local lCIM_TOOL=''
  shift 2; local lOPTIONS="$@"; 
  
  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1
  # purpose
  luc_core_echo "purp" "create a $lCIM_TOOL running container from an image"

  # checkorexit args are provided
  [ -z "$lIMAGE_SID"      ] ||
  [ -z "$lCONTAINER_NAME" ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  lECHOVAL=$(luc_cimv2_check_exists --image  $lIMAGE_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ID="$lECHOVAL"

  # getorexit image FULLNAME
  lECHOVAL=$(luc_cimv2_property_get --image  $lIMAGE_SIDFULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_FULLNAME="$lECHOVAL"

  # getorexit image SHELL
  lECHOVAL=$(luc_cimv2_property_get --image  $lIMAGE_SIDSHELL); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SHELL="$lECHOVAL"

  # info
  luc_core_echo "info" "image     : $lIMAGE_ID / $lIMAGE_FULLNAME"
  luc_core_echo "info" "container : $lCONTAINER_NAME"
  luc_core_echo "info" "shell     : $lIMAGE_SHELL"
  luc_core_echo "info" "options   : $lOPTIONS"

  
  # create running container
  lECHOVAL=$($lCIM_TOOL run $lOPTIONS --name $lCONTAINER_NAME -d $lIMAGE_SID $lDUMMY_LOOP 2>&1);lRETVAL=$?


  # getorexit container id
  lCONTAINER_ID=$($lCIM_TOOL inspect --type container --format {{.ID}} ${lCONTAINER_NAME})
  lCONTAINER_SID="${lCONTAINER_ID:0:5}"

  # checkorexit container is created
  [ "$lRETVAL" -eq 0 ] && {
    luc_core_echo "done" "created container $lCONTAINER_NAME ($lCONTAINER_SID) from image $lIMAGE_FULLNAME ($lIMAGE_ID)"  
    return 0
  } || {
    luc_core_echo "warn" "cannot create container $lCONTAINER_NAME > $lECHOVAL"
    return 1
  }
}    

# purpose: enter a running container
# args: <CONTAINER_SID> [OPTIONS]
luc_cimv2_container_enter() {
  local lCONTAINER_SID="$1"
  local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_SID> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) ab12 -v /tmp/luc:/test:U,ro" 
  local lRETVAL
  shift 1; local lOPTIONS="$@"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1
  # purpose
  luc_core_echo "purp" "interactive enter a running $lCIM_TOOL container"

  # checkorexit container exists
  lECHOVAL=$(luc_cimv2_check_exists --container $lCONTAINER_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1
  
  # getorexit container shell
  lECHOVAL=$(luc_cimv2_property_get --container $lCONTAINER_SID SHELL); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_SHELL="$lECHOVAL"

  # info
  luc_core_echo "info" "csid  : $lCONTAINER_SID"
  luc_core_echo "info" "shell : $lCONTAINER_SHELL"
  
  # enter the container
  $lCIM_TOOL exec $lOPTIONS -it $lCONTAINER_SID $lCONTAINER_SHELL -l
  
  # return  
  luc_core_echo "done" "exit running container $lCONTAINER_SID. but container still running"
  return 0  
}

# purpose: play a cli inside a running container
# args: <CONTAINER_SID> <CLI>
luc_cimv2_container_cli_play() {
  local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_SID> <CLI>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) test 12 -v /tmp/luc:/test:ro" 
  local lCONTAINER_SID="$1"
  local lCLI="$2"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1
  # purpose
  luc_core_echo "purp" "use $lCIM_TOOL to play a CLI in a running container"

  # checkorexit args are provided
  [ -z "$lCONTAINER_SID"     ] ||
  [ -z "$lCLI"      ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit container exists
  lECHOVAL=$(luc_cimv2_check_exists --container $lCONTAINER_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1
  
  # getorexit container shell
  lECHOVAL=$(luc_cimv2_property_get --container $lCONTAINER_SID SHELL); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_SHELL="$lECHOVAL"

  # checkorexit container is running
  lECHOVAL=$(luc_cimv2_property_get --container $lCONTAINER_SID state:running); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_STATE_RUNNING="$lECHOVAL"
  [ ! "true" == "$lCONTAINER_STATE_RUNNING" ] && luc_core_echo "warn" "Continer must be running: $lCONTAINER_SID" && return 1

  # info
  luc_core_echo "info" "csid    : $lCONTAINER_SID"
  luc_core_echo "info" "shell   : $lCONTAINER_SHELL"
  luc_core_echo "info" "CLI     : $lCLI"
  luc_core_echo "info" "running : $lCONTAINER_STATE_RUNNING"

  $lCIM_TOOL exec ${lCONTAINER_SID} ${lCONTAINER_SHELL} -c "$lCLI"
  
  return 0
}

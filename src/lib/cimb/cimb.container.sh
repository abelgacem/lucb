# shortcuts
luc_cimb_container_list() { luc_cimb_list; }

# purpose: buildah check a container exists
# note: no other echo inside the code - helper function - the return value and code are used
# args   : <CONTAINER_SID>
# return : O if exist, an integer otherwise
luc_cimb_container_check_exists() {
  local lMSG_PURPOSE="check a container exits"  
  local lMSG_USAGE="$(luc_core_method_name_get) <IMAGE_SID>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lOBJECT_SID="$1"

  # checkorexit args are provided
  [ -z "$lOBJECT_SID" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # get ID(s) found
  lECHOVAL=$(buildah containers --all --format "{{.ContainerID}}" | grep "^${lOBJECT_SID}"); lRETVAL=$?

  # get nb ID(s) found
  lNBID="$(echo $lECHOVAL | wc -w)"
  
  # when no ID found
  [ 0 -ne "$lRETVAL" ] && {
    luc_core_echo "warn" "no container found with sid: $lOBJECT_SID. Choose 1 among:" 
    buildah containers --all
    return 2
  }
  # when several ID(s) found
  [  0 -eq "$lRETVAL" ] && [ 2 -le "$lNBID" ] && {
    luc_core_echo "caut" "multiple imagess found starting with sid: $lOBJECT_SID. Choose 1 among:" 
    buildah containers --all
    return 3
  }
  # when exactly 1 ID found
  echo $lECHOVAL; return 0 
}

# purpose: buildah enter [interactively] a container
# args   : <CONTAINER_SID> [OPTIONS]

luc_cimb_container_enter() {
  local lMSG_PURPOSE="buildah enter [interactive] a container"  
  local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_SID> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12 -v xxx,yyy:ro" 
  local lCONTAINER_SID="$1"
  shift 1; local lOPTIONS="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  # checkorexit args are provided
  [ -z "$lCONTAINER_SID" ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit object exists
  lECHOVAL=$(luc_cimb_container_check_exists $lCONTAINER_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2

  # getorexit container shell
  lECHOVAL=$(luc_cimb_property_get --container $lCONTAINER_SID SHELL); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lCONTAINER_SHELL="$lECHOVAL"

  # getorexit container name
  lECHOVAL=$(luc_cimb_property_get --container $lCONTAINER_SID NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lCONTAINER_NAME="$lECHOVAL"

  # info
  luc_core_echo "debu" "lCONTAINER      : $lCONTAINER_NAME ($lCONTAINER_SID)"
  luc_core_echo "debu" "lCONTAINER_SHELL: $lCONTAINER_SHELL"
  luc_core_echo "debu" "lOPTIONS        : $lOPTIONS"
  luc_core_echo "debu" "CLI             : buildah run -t $lCONTAINER_SID $lCONTAINER_SHELL -l"
  
  # enter the container
  buildah run -t $lOPTIONS $lCONTAINER_SID $lCONTAINER_SHELL -l
  
  # return
  return 0 
} # function


# purpose: run a CLI in a buildah container
# args: <CONTAINER_SID> <CLI> [OPTIONS]
luc_cimb_container_cli_run() {
  local lMSG_PURPOSE="run a CLI in buildah container"  
  local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_SID> <CLI> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 77 printenv | set | 'id -un'" 
  local lCONTAINER_SID="$1"
  local lCLI="$2"
  shift 2; local lOPTIONS="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lCONTAINER_SID" ] ||
  [ -z "$lCLI" ] ||
    [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit container exists
  lECHOVAL=$(luc_cimb_container_check_exists $lCONTAINER_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2

  # getorexit container shell
  lECHOVAL=$(luc_cimb_property_get --container $lCONTAINER_SID SHELL); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lCONTAINER_SHELL="$lECHOVAL"

  # getorexit container name
  lECHOVAL=$(luc_cimb_property_get --container $lCONTAINER_SID NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lCONTAINER_NAME="$lECHOVAL"

  ###### INFO 
  luc_core_echo "debu" "lCONTAINER_NAME  : $lCONTAINER_NAME ($lCONTAINER_SID)"
  luc_core_echo "debu" "lCONTAINER_SHELL : $lCONTAINER_SHELL"
  luc_core_echo "debu" "lCLI             : $lCLI"
  luc_core_echo "debu" "lOPTIONS         : $lOPTIONS"
  luc_core_echo "debu" "CLI              : buildah run $lOPTIONS $lCONTAINER_SID $lCONTAINER_SHELL -c \"$lCLI\""

  ###### ACION: run the CLI in container
  luc_core_echo "step" "CLI sent to container, output is"
  lECHOVAL=$(buildah run $lOPTIONS $lCONTAINER_SID $lCONTAINER_SHELL -c "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 3 || echo "$lECHOVAL"
  
  # return
  return 0 
}

# purpose: buildah create container from an image
# args: <CONTAINER_NAME> <IMAGE_SID> [OPTIONS]
luc_cimb_container_create() {
  local lMSG_PURPOSE="buildah create a container from an image"  
  local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_NAME> <IMAGE_SID> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) aeb34e -v xxx:yyy,U,ro" 
  local lCONTAINER_NAME="$1"
  local lIMAGE_SRC_SID="$2"
  shift 2; local lOPTIONS="$@"
  
  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  ###### INFO                 ##########################
  luc_core_echo "info" "image     SRC    : $lIMAGE_SRC_SID"
  luc_core_echo "info" "container DST    : $lCONTAINER_NAME"
  luc_core_echo "debu" "lOPTIONS        : $lOPTIONS"

  ###### PREREQUISIT          ##########################
  # checkorexit args are provided
  [ -z "$lIMAGE_SRC_SID" ] ||
  [ -z "$lCONTAINER_NAME" ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  
  # checkorexit image exists
  lECHOVAL=$(luc_cimb_image_check_exists $lIMAGE_SRC_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2

  # getorexit image NAME
  lECHOVAL=$(luc_cimb_property_get --image $lIMAGE_SRC_SID FULLNAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" &&  return 1 || lIMAGE_NAME=$lECHOVAL

  ###### CHECK / INFO            ######################
  # checkorexit container does not exists
  # luc_core_echo "debu" "TODO: check the creation of the temporary container"
  luc_core_echo "debu" "CLI             : buildah from --name $lCONTAINER_NAME  $lOPTIONS $lIMAGE_SRC_SID"

  ###### ACION: CREATE CONTAINER ####################
  # create the container
  lEHOVAL=$(buildah from --name $lCONTAINER_NAME  $lOPTIONS $lIMAGE_SRC_SID  2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lEHOVAL"  &&  return 1

  ###### CHECK PROVISIONING ##################### 
  # getorexit container SID
  lECHOVAL=$(luc_cimb_sid_get --container $lCONTAINER_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" &&  return 1 || lCONTAINER_SID=$lECHOVAL
  
  ###### RETURN                 #####################
  luc_core_echo "done" "created container $lCONTAINER_NAME ($lCONTAINER_SID) from image $lIMAGE_NAME ($lIMAGE_SRC_SID)"
  return 0
} # function

# purpose: buildah delete all or some containers
# args: --all | --temp | <OBJECT_SID1> <OBJECT_SID2> ...
luc_cimb_container_delete() {
  local lMSG_PURPOSE="buildah delete all or some containers"  
  local lMSG_USAGE="$(luc_core_method_name_get) --all | --temp | <OBJECT_SID1> <OBJECT_SID2> ..."  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) aeb34e" 
  local lOBJECT_SID="$1"
  local lOBJECT_LIST="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  # checkorexit args are provided
  [ -z "$lOBJECT_SID"      ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 3

  # define the list of containers to delete
  # when --all
  [ "$lOBJECT_SID" == "--all"  ] && {
    lMSG="all containers"
    lOBJECT_LIST="--all"
  }
  # when --temp
  [ "$lOBJECT_SID" == "--temp"  ] && {
    lMSG="temporary containers"
    lOBJECT_LIST=$(buildah ps --all --quiet --filter 'name=temp-')
  }
  # when a list is provided
  [ "$lOBJECT_SID" != "--all"  ] && [ "$lOBJECT_SID" != "--temp" ] && {
    lMSG="provided containers"
    lOBJECT_LIST="$@"
  }
  # delete the containers
  luc_core_echo "info" "deleted $lMSG"
  buildah rm $lOBJECT_LIST
  return 0
} # function

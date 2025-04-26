# purpose: library to manage containers and container images
# constraint: must work for both docker and buildah

# shortcut


# purpose: display infos on tool and objects
# args: NONE
luc_cim_info_display() {
  # define var
  local lUSAGE_MSG="$(luc_core_method_name_get) [–help]"
  local lCIM_TOOL=''

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  luc_core_check_cli_is_installed podman && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1

  # checkorexit args are provided
  [ "--help" == "$1" ] && 
  luc_core_echo "usag" "$lUSAGE_MSG" && return 1

  # info
  luc_core_echo "purp" "display infos on $lCIM_TOOL and $lCIM_TOOL's objects"

  # info
  luc_core_echo "info" "global infos"
  $lCIM_TOOL info
  # info
  luc_core_echo "info" "version"
  $lCIM_TOOL version
  
} # function


# purpose: get the id of a container or image
# note: output and return are used
# note: helper function
# args: lOBJECT_TYPE lCNTR_OR_IMG_SID
luc_cim_id_get() {
  # define var
  local lOBJECT_TYPE="$1"
  local lCNTR_OR_IMG_SID="$2"
  local lUSAGE_MSG="$(luc_core_method_name_get) (--image|--container) <lCNTR_OR_IMG_SID>"
  local lCIM_TOOL=''

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1

  # checkorexit args are provided
  [ -z "$lOBJECT_TYPE" ]          ||
  [ -z "$lCNTR_OR_IMG_SID" ]   ||
  [ "$lOBJECT_TYPE" == "--help" ] && 
  luc_core_echo "usag" "$lUSAGE_MSG" && return 1

  # checkorexit type is managed
  [ "${lOBJECT_TYPE}" != "--image" ] && [ "$lOBJECT_TYPE" != "--container" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" && return 1
  }
  
  # lookup field according to object type
  [ "$lOBJECT_TYPE" == "--image" ]  && {
    lTOOL_ACTION='images'
    lFIELD_NAME='ID'
  }
  [ "$lOBJECT_TYPE" == "--container" ] && {
    lTOOL_ACTION='ps'
    lFIELD_NAME='ID'
    ([ "$lCIM_TOOL" == "buildah" ] || [ "$lCIM_TOOL" == "podman" ]) && lFIELD_NAME='ContainerID'
  }


  # Get image/container:IDs. Possible combinaison
  # - buildah ps     --format {{.ContainerID}}
  # - buildah images --format {{.ID}}
  # - docker  images --format {{.ID}}
  # - docker  ps     --format {{.ID}}
  lCNTR_OR_IMG_IDs=$($lCIM_TOOL ${lTOOL_ACTION} --all --format "{{.${lFIELD_NAME}}}" | grep "^${lCNTR_OR_IMG_SID}" 2>/dev/null)
    
  # Usecase > lIMAGE_ID is empty
  [ -z "$lCNTR_OR_IMG_IDs" ] && {
    luc_core_echo "warn" "No $lCIM_TOOL ${lOBJECT_TYPE/--/} found with ID: ${lCNTR_OR_IMG_SID}. Choose 1 among:"
    $lCIM_TOOL ${lTOOL_ACTION} --all
    return 2    
  }

  # Usecase > lIMAGE_ID = N lines
  [ "$(echo "${lCNTR_OR_IMG_IDs}" | wc -w)" -gt 1 ] && {
    luc_core_echo "caut" "Several ${lOBJECT_TYPE/--/} found with ID: ${lCNTR_OR_IMG_SID}. Choose 1 among:" 
    $lCIM_TOOL ${lTOOL_ACTION} --all
    return 3
  }

  # Usecase > lIMAGE_ID = 1 line
  [ "$(echo ${lCNTR_OR_IMG_IDs} | wc -w)" -eq 1 ] && echo ${lCNTR_OR_IMG_IDs} && return 0

  
} # function

# purpose: list containers and images
# args: NONE
luc_cim_list() {
  local  lCIM_TOOL=''
  
  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1
  
  # info
  luc_core_echo "purp" "list locally stored $lCIM_TOOL images and containers"

  # do
  luc_core_echo "info" "list of $lCIM_TOOL images"
  $lCIM_TOOL images --all

  # do
  luc_core_echo "info" "list of $lCIM_TOOL dangling images"
  $lCIM_TOOL images --filter dangling=true

  # do
  luc_core_echo "info" "list of $lCIM_TOOL containers"
  $lCIM_TOOL ps --all

}


# purpose: delete all or one or more containers or images
# args: <OBJECT_TYPE> <OBJECT_SIDs>
luc_cim_delete() {
  local lOBJECT_TYPE="$1"
  local lOBJECT_SID="$2"
  local lCIM_TOOL=''
  local lOBJECT_LIST='' lCLI_DELETE_OPTION=''
  local lUSAGE_MSG="$(luc_core_method_name_get) --help|--container|--image --dangling|--all|--temp|<obj_id1> <obj_id2>"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1

  # info
  luc_core_echo "purp"  "delete one or more $lCIM_TOOL containers/images with no confirmation"
  
  # checkorexit args are provided or is help
  [ -z "$lOBJECT_TYPE" ]          ||
  [ -z "$lOBJECT_SID" ]          ||
  [ "--help" == "$1" ] && {    
    luc_core_echo "usag" "$lUSAGE_MSG"
    luc_core_echo "exam" "$(luc_core_method_name_get) --image --all"
    luc_core_echo "exam" "$(luc_core_method_name_get) --container --temp"
    return 1
  }

  # checkorexit args are managed
  [ "$lOBJECT_TYPE" != "--image"     ]  && 
  [ "$lOBJECT_TYPE" != "--container" ]  && 
  luc_core_echo "usag" "$lUSAGE_MSG"    && return 1
  
  # lookup field according to object_type
  [ "$lOBJECT_TYPE" == "--container" ] && {
      lCLI_DELETE='rm'
      lCLI_LIST='ps'
  }
  [ "$lOBJECT_TYPE" == "--image" ] && {
      lCLI_DELETE='rmi'
      lCLI_LIST='images'
  }

  # lookup field according to tool
  [ "$lCIM_TOOL" == "docker" ] && {
      lCLI_DELETE_OPTION='--force'
  }

  # get cli flogs
  shift 1; lOBJECT_LIST=$@
  # define vars when --all
  [  "$lOBJECT_SID" == "--all" ] && [ "$lCIM_TOOL" == "docker"  ] && {
    [ "$lOBJECT_TYPE" == "--container" ] && lOBJECT_LIST="$(docker container ls -aq)"
    [ "$lOBJECT_TYPE" == "--image" ]     && lOBJECT_LIST="$(docker images -aq)"
    [ -z "$lOBJECT_LIST/ /" ] && luc_core_echo "caut" "no objects to delete" && return 1
  }
  # define vars when --dangling
  [ "$lOBJECT_SID" == "--dangling" ] && {
    [ "$lOBJECT_TYPE" == "--container" ] && luc_core_echo "caut" "dangling container not exists" && return 1
    [ "$lOBJECT_TYPE" == "--image"     ] && lOBJECT_LIST="$($lCIM_TOOL images --all --quiet --filter dangling=true) $($lCIM_TOOL images --all | awk '/<none>/ { print $3 }')"
    [ -z "$lOBJECT_LIST/ /" ]  && luc_core_echo "caut" "no dangling image to delete" && return 1
  }
  # define vars when --temp
  [ "$lOBJECT_SID" == "--temp" ] && {
    [ "$lOBJECT_TYPE" == "--container" ] && lOBJECT_LIST="$($lCIM_TOOL ps --all --quiet --filter 'name=temp-')"
    [ "$lOBJECT_TYPE" == "--image"     ] && luc_core_echo "caut" "temp images not exists" && return 1
    [ -z "$lOBJECT_LIST/ /" ] && luc_core_echo "caut" "no temp container to delete" && return 1
  }


  # delete objects

  luc_core_echo "debu" "CLI > $lCIM_TOOL ${lCLI_DELETE} ${lOBJECT_LIST} ${lCLI_DELETE_OPTION}"
  # luc_core_debug;return 5
  lECHOVAL=$($lCIM_TOOL ${lCLI_DELETE} ${lOBJECT_LIST} ${lCLI_DELETE_OPTION} 2>&1); lRETVAL=$?
  
  # check action
  [ "$lRETVAL" -eq 0   ] && luc_core_echo "done" "delete $lCIM_TOOL ${lOBJECT_TYPE/--/} $@" && return 0 || {
      luc_core_echo "warn" "$lECHOVAL"
      luc_core_echo "caut" "choose ${lOBJECT_TYPE/--/} among:"
      $lCIM_TOOL $lCLI_LIST --all
      return 1
  } 
}

# purpose: get a container or image property
# note: output and return are used
# args: lOBJECT_TYPE lOBJECT_SID lOBJECT_PROPERTY
luc_cim_property_get() {
  # define var
  local lLABEL_IMAGE_SHELL="${luc_EV_CIM_LABEL_KEY_SHELL}"
  local lLABEL_IMAGE_OSNAME="${luc_EV_CIM_LABEL_KEY_OSNAME}"
  local lOBJECT_TYPE="$1"
  local lOBJECT_SID="$2"
  local lOBJECT_PROPERTY="$3"
  local lIMAGE_ID=''
  local lUSAGE_MSG="$(luc_core_method_name_get) --image|--container <lOBJECT_SID> <lPROPERTY> (eg. fullname|name|path|tag|id|shell|json|json:xxx)"

  # checkorexit args are provided
  [ -z "$lOBJECT_TYPE" ]         ||
  [ -z "$lOBJECT_SID" ]          ||
  [ -z "$lOBJECT_PROPERTY" ]     || 
  [ "--help" == "$1" ] && {    luc_core_echo "usag" "$lUSAGE_MSG"
    luc_core_echo "exam" "$(luc_core_method_name_get) --container e6 image:name"
    luc_core_echo "exam" "$(luc_core_method_name_get) --container e6 image:id"
    return 1
  }

  # checkorexit args are managed
  [ "$lOBJECT_TYPE" != "--image" ]      && 
  [ "$lOBJECT_TYPE" != "--container" ]  && 
  luc_core_echo "usag" "$lUSAGE_MSG" && return 1

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  luc_core_check_cli_is_installed podman && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1

  # checkorexit object exists
  lECHOVAL=$(luc_cim_id_get ${lOBJECT_TYPE} $lOBJECT_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lOBJECT_ID="$lECHOVAL"

  # lookup field according to tool and object type for container
  [ "$lCIM_TOOL" == "docker" ]  && {
    lFIELD_IMAGE_NAME='Repository'
    lFIELD_CONTAINER_ID='ID'
    lFIELD_CONTAINER_NAME='Names'
    lFIELD_IMAGE_ID='Image'
    lFIELD_CMD="[].Config.Cmd[]"
    lFIELD_PORT="Todo:"
    lFIELD_ISRUNNING="[].State.Running"
    lFIELD_ENV="[].Config.Env[]"
    lFIELD_LABELS="[].Config.Labels"
    lFIELD_LABEL_SHELL="[].Config.Labels[\"${lLABEL_IMAGE_SHELL}\"]"
    lFIELD_LABEL_OSNAME="[].Config.Labels[\"${lLABEL_IMAGE_OSNAME}\"]"
    lFIELD_JSON="[].${lOBJECT_PROPERTY/json:/}"
  }
  [ "$lCIM_TOOL" == "buildah" ] && {
    lFIELD_IMAGE_NAME='Name'
    lFIELD_CONTAINER_ID='ContainerID'
    lFIELD_CONTAINER_NAME='ContainerName'
    lFIELD_IMAGE_ID='ImageID'
    lFIELD_CMD="OCIv1.config.Cmd[]"
    lFIELD_PORT="OCIv1.config.ExposedPorts"
    lFIELD_ISRUNNING="State"
    # lFIELD_ENV="Config | fromjson | .config | .Env[]"
    lFIELD_ENV="OCIv1.config.Env"
    lFIELD_LABELS="Docker.config.Labels"
    lFIELD_LABEL_SHELL="Docker.config.Labels[\"${lLABEL_IMAGE_SHELL}\"]"
    lFIELD_LABEL_OSNAME="Docker.config.Labels[\"${lLABEL_IMAGE_OSNAME}\"]"
    lFIELD_JSON="${lOBJECT_PROPERTY/json:/}"
  }
  [ "$lCIM_TOOL" == "podman" ] && {
    lFIELD_IMAGE_NAME='Names' # good
    lFIELD_CONTAINER_ID='ContainerID'
    lFIELD_CONTAINER_NAME='ContainerName'
    lFIELD_IMAGE_ID='ImageID'
    lFIELD_CMD="[].Config.Cmd[]" # good
    lFIELD_PORT="OCIv1.config.ExposedPorts"
    lFIELD_ISRUNNING="State"
    # lFIELD_ENV="Config | fromjson | .config | .Env[]"
    lFIELD_ENV="OCIv1.config.Env"
    lFIELD_LABELS="Docker.config.Labels"
    lFIELD_LABEL_SHELL="Docker.config.Labels[\"${lLABEL_IMAGE_SHELL}\"]"
    lFIELD_LABEL_OSNAME="Docker.config.Labels[\"${lLABEL_IMAGE_OSNAME}\"]"
    lFIELD_JSON="${lOBJECT_PROPERTY/json:/}"
  }
  lCHOICE="${lOBJECT_TYPE/--/}:$(echo "$lOBJECT_PROPERTY" | tr '[:upper:]' '[:lower:]')"
  
  # get image:property
  case "$lCHOICE" in
    container:id)
      lVALUE=$($lCIM_TOOL ps --all --format "{{.${lFIELD_CONTAINER_ID}}}" | grep "^$lOBJECT_ID)
      ;;
    image:id)
      lVALUE=$($lCIM_TOOL images --all --format "{{.$lFIELD_IMAGE_NAME}}:{{.Tag}}:{{.ID}}" | grep "$lOBJECT_ID | cut -d':' -f3)
      ;;
    container:name)
      lVALUE=$($lCIM_TOOL ps --all --format "{{.${lFIELD_CONTAINER_ID}}}:{{.${lFIELD_CONTAINER_NAME}}}" | grep "^$lOBJECT_ID | cut -d: -f2)
      ;;
    container:image:id)
      lVALUE=$($lCIM_TOOL ps --all --format "{{.${lFIELD_CONTAINER_ID}}}:{{.${lFIELD_IMAGE_ID}}}" | grep "^$lOBJECT_ID | cut -d: -f2-)
      ;;
    container:image:name)
      tIMAGE_ID=$($lCIM_TOOL ps --all --format "{{.${lFIELD_CONTAINER_ID}}}:{{.${lFIELD_IMAGE_ID}}}" | grep "^$lOBJECT_ID | cut -d: -f2-)
      lVALUE=$($lCIM_TOOL images --all --format "{{.$lFIELD_IMAGE_NAME}}:{{.Tag}}:{{.ID}}" | grep "$tIMAGE_ID" | cut -d':' -f1-2)
      ;;
    image:fullname)
      lVALUE=$($lCIM_TOOL images --all --format "{{.$lFIELD_IMAGE_NAME}}:{{.Tag}}:{{.ID}}" | grep "$lOBJECT_ID | cut -d':' -f1-2 | tr -d '[]')
      ;;
    image:name)
      lVALUE=$($lCIM_TOOL images --all --format "{{.$lFIELD_IMAGE_NAME}}:{{.Tag}}:{{.ID}}" | grep "$lOBJECT_ID | awk -F'/' '{print $NF}'  | awk -F':' '{print $1}')
      ;;
    image:path)
      lVALUE=$($lCIM_TOOL images --all --format "{{.$lFIELD_IMAGE_NAME}}:{{.Tag}}:{{.ID}}" | grep "$lOBJECT_ID | cut -d':' -f1 | xargs dirname)
      ;;
    image:tag)
      lVALUE=$($lCIM_TOOL images --all --format "{{.$lFIELD_IMAGE_NAME}}:{{.Tag}}:{{.ID}}" | grep "$lOBJECT_ID | cut -d':' -f2 | tr -d '[]')
      ;;
    container:cmd)
      lVALUE=$($lCIM_TOOL inspect --type container $lOBJECT_ID| jq -r ".${lFIELD_CMD}?") 
      ;;
    image:envar|container:envar)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_ID| jq  ".${lFIELD_ENV}?" ) 
      ;;
    container:label|image:label)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_ID| jq -r ".${lFIELD_LABELS}?")
      ;;
    container:shell|image:shell)
      lVALUE=$($lCIM_TOOL inspect $lOBJECT_ID | jq -r ".${lFIELD_LABEL_SHELL}?");
      ;;
    image:os:name|container:os:name)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_ID| jq  -r ".${lFIELD_LABEL_OSNAME}?" ) 
      ;;
    container:isrunning)
      lVALUE=$($lCIM_TOOL inspect --type container $lOBJECT_ID| jq -r ".${lFIELD_ISRUNNING}?")
      ;;
    image:port)
      lVALUE=$($lCIM_TOOL inspect --type image $lOBJECT_ID| jq -r ".${lFIELD_PORT}?")
      ;;
    image:cmd)
      lVALUE=$($lCIM_TOOL inspect --type image $lOBJECT_ID| jq -r ".${lFIELD_CMD}?")
      ;;
    container:json)
      $lCIM_TOOL inspect --type container "$lOBJECT_ID | jq . && return 0
      ;;
    container:json:*)
      $lCIM_TOOL inspect --type container "$lOBJECT_ID | jq -r ".${lFIELD_JSON}?" && return 0 # output nothing if not exists
      ;;
    image:json)
      $lCIM_TOOL inspect --type image "$lOBJECT_ID | jq . && return 0
      ;;
    image:json:*)
      $lCIM_TOOL inspect --type image "$lOBJECT_ID | jq -r ".${lFIELD_JSON}?" && return 0 # output nothing if not exists
      ;;
    # container:env)
    #   lVALUE=$($lCIM_TOOL inspect --type container $lOBJECT_ID| jq  ".${lFIELD_ENV}?" ) 
    #   ;;
    # image:label)
    #   lVALUE=$($lCIM_TOOL inspect --type image $lOBJECT_ID| jq -r ".${lFIELD_LABELS}?")
    #   ;;
    # image:shell)
    #   lVALUE=$($lCIM_TOOL inspect --type image $lOBJECT_ID| jq -r ".${lFIELD_LABEL_SHELL}?")
    #   ;;
    *)
      luc_core_echo "warn" "atribute:${lOBJECT_PROPERTY} not yet managed" && return 1
      ;;
  esac
  # do
  echo $lVALUE; return 0
} # function


# purpose: check a container or image exits
# note: no other echo inside the code - helper function - the return value and code are used
# args: <OBJECT_TYPE> <OBJECT_SID>
luc_cimv2_check_exists() {
  local lMSG_USAGE="$(luc_core_method_name_get) --image | --container <OBJECT_SID>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) --image dfe12" 
  local lOBJECT_TYPE="$1"
  local lOBJECT_SID="$2"
  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | podman is installed" && return 1

  # checkorexit args are provided
  [ -z "$lOBJECT_TYPE" ] ||
  [ -z "$lOBJECT_SID"  ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "check a $lCIM_TOOL container exists" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 2

  # checkorexit args are managed
  [ "$lOBJECT_TYPE" != "--image"     ] && 
  [ "$lOBJECT_TYPE" != "--container" ] && luc_core_echo "usag" "$lMSG_USAGE" && return 3

  # get ID(s) found
  lECHOVAL=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{.ID}}" | grep "^${lOBJECT_SID}"); lRETVAL=$?
  
  # get nb ID(s) found
  lNBID="$(echo $lECHOVAL | wc -w)"
  
  # when no ID found
  [ 0 -ne "$lRETVAL" ] && {
    luc_core_echo "warn" "no ${lOBJECT_TYPE/--/} found with sid: $lOBJECT_SID. Choose 1 among:" 
    $lCIM_TOOL ${lOBJECT_TYPE/--/} list --all
    return 4
  }
  # when several ID(s) found
  [   0 -eq "$lRETVAL" ] && [ 2 -le "$lNBID" ] && {
    luc_core_echo "caut" "multiple ${lOBJECT_TYPE/--/}s found starting with sid: $lOBJECT_SID. Choose 1 among:" 
    $lCIM_TOOL ${lOBJECT_TYPE/--/} list --all
    return 5
  }
  # when exactly 1 ID found
  echo $lECHOVAL; return 0 
}

# purpose: get a container or image property
# note: no other echo inside the code - helper function - the return value and code are used
# args: <OBJECT_TYPE> <OBJECT_SID> <OBJECT_PROPERTY>
luc_cimv2_property_get() {
  # define var
  local lMSG_USAGE="$(luc_core_method_name_get) --image | --container <OBJECT_SID> <OBJECT_PROPERTY>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) --container dfe12 label (eg. fullname|name|path|tag|id|shell|json|json:xxx)" 
  local lOBJECT_TYPE="$1"
  local lOBJECT_SID="$2"
  local lOBJECT_PROPERTY="$3"
  local lVALUE
  local lLABEL_IMAGE_SHELL="${luc_EV_CIMV2_LABEL_KEY_SHELL}"
  local lLABEL_IMAGE_OSNAME="${luc_EV_CIMV2_LABEL_KEY_OSNAME}"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | podman is installed" && return 1

  # checkorexit args are provided
  [ -z "$lOBJECT_TYPE"     ] ||
  [ -z "$lOBJECT_SID"      ] ||
  [ -z "$lOBJECT_PROPERTY" ] || 
  [ "--help" == "$1" ] && luc_core_echo "purp" "get a $lCIM_TOOL container or image property" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit args are managed
  [ "$lOBJECT_TYPE" != "--image"     ] && 
  [ "$lOBJECT_TYPE" != "--container" ] && luc_core_echo "usag" "$lMSG_USAGE" && return 1

  # checkorexit object exists
  lECHOVAL="$(luc_cimv2_check_exists ${lOBJECT_TYPE} $lOBJECT_SID)" ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # checkorexit property is managed
  # lLIST_MANAGED_PROPERTY="id|fullname|name|sname|path|tag|image:id|image:name|image:fullname|label"
  # lECHOVAL="$(luc_core_check_string_is_inlist ${lOBJECT_PROPERTY} $lLIST_MANAGED_PROPERTY)" ; lRETVAL=$?
  # [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  
  
  # luc_core_echo "debu" "lOBJECT_TYPE=$lOBJECT_TYPE"
  # luc_core_echo "debu" "lOBJECT_SID=$lOBJECT_SID"
  # luc_core_echo "debu" "lRETVAL=$lRETVAL"
  # luc_core_echo "debu" "lECHOVAL=$lECHOVAL"

  # lookup field according to tool and object type for container
  [ "$lCIM_TOOL" == "docker" ]  && {
    lFIELD_IMAGE_NAME='.Repository'
    lFIELD_ID='.ID'
    lFIELD_CONTAINER_NAME='.Names'
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
  [ "$lCIM_TOOL" == "podman" ] && {
    # CLI
    lFIELD_IMAGE_NAME='.Names'
    lFIELD_CMD="[].Config.Cmd[]"
    lFIELD_CONTAINER_NAME="$lFIELD_IMAGE_NAME"
    lFIELD_CONTAINER_IMID=".ImageID"
    lFIELD_ID='.ID'
    lFIELD_IMAGE_TAG='.Tag'
    # INSPECT
    lFIELD_CONFIG=".[].Config"
    lFIELD_LABELS=".[].Config.Labels"
    lFIELD_LABEL_SHELL=".[].Config.Labels[\"${lLABEL_IMAGE_SHELL}\"]"
    lFIELD_LABEL_OSNAME=".[].Config.Labels[\"${lLABEL_IMAGE_OSNAME}\"]"
    lFIELD_SHELL=".[].Config.Labels"
    lFIELD_ENTRYPOINT=".[].Config.Entrypoint"
    lFIELD_ENVS=".[].Config.Env"
    lFIELD_ENV_PATH=".[].Config.Env[]"
    lFIELD_STATES=".[].State"
    lFIELD_STATE_RUNNING=".[].State.Running"
    lFIELD_JSON=".[]${lOBJECT_PROPERTY/json:/}"
  }
  lCHOICE="${lOBJECT_TYPE/--/}:$(echo "$lOBJECT_PROPERTY" | tr '[:upper:]' '[:lower:]')"
  # :{{.Tag}}:{{.ID}}
  # get image:property
  case "$lCHOICE" in
    container:json|image:json)
      $lCIM_TOOL inspect   "$lOBJECT_SID" | jq ".[]" && return 0
      ;;
    container:config|image:config)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq -r "${lFIELD_CONFIG}?")
      ;;
    container:user)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq -r "${lFIELD_STATES}?")
      ;;
    container:state)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq -r "${lFIELD_STATES}?")
      ;;
    container:state:running)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq -r "${lFIELD_STATE_RUNNING}?")
      ;;
    container:label|image:label)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq -r "${lFIELD_LABELS}?")
      luc_core_echo "debu" "yo"
      ;;
    container:shell)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq -r "${lFIELD_LABEL_SHELL}?")
      [ "null" == "$lVALUE" ] && {
        lIMID=$(luc_cimv2_property_get --container $lOBJECT_SID image:id)
        lVALUE=$(luc_cimv2_property_get --image $lIMID cmd)
      }
      ;;
    container:os:name|image:os:name)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq -r "${lFIELD_LABEL_OSNAME}?")
      [ "null" == "$lVALUE" ] && lVALUE="todo"
      ;;
    image:shell)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq -r "${lFIELD_LABEL_SHELL}?")
      [ "null" == "$lVALUE" ] && lVALUE=$(luc_cimv2_property_get --image $lOBJECT_SID cmd)
      ;;
    container:envar|image:envar)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq -r "${lFIELD_ENVS}?")
      ;;
    container:envar:path|image:envar:path)
      lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq -r "${lFIELD_ENV_PATH}?" | grep -o 'PATH=[^ ]*' | cut -d= -f2)
      ;;
    image:cmd|container:cmd)
      lVALUE=$($lCIM_TOOL inspect $lOBJECT_SID | jq -r ".${lFIELD_CMD}?")
      ;;
    container:id|image:id)
      lVALUE=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_ID}}" | grep "^${lOBJECT_SID}")
      ;;
    image:fullname)
      lVALUE=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_ID}}@{{$lFIELD_IMAGE_NAME}}"     | grep "^${lOBJECT_SID}" | cut -d@ -f2 | tr -d '[]')
      ;;
    image:name)
      lVALUE=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_ID}}@{{$lFIELD_IMAGE_NAME}}"     | grep "^${lOBJECT_SID}" | cut -d@ -f2 | tr -d '[]')
      lVALUE=${lVALUE##*/}
      ;;
    image:sname)
      lVALUE=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_ID}}@{{$lFIELD_IMAGE_NAME}}"     | grep "^${lOBJECT_SID}" | cut -d@ -f2 | tr -d '[]')
      lVALUE=$(echo $lVALUE##*/| cut -d: -f1)
      ;;
    image:path)
      lVALUE=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_ID}}@{{$lFIELD_IMAGE_NAME}}"     | grep "^${lOBJECT_SID}" | cut -d@ -f2 | tr -d '[]')
      lVALUE=$lVALUE#*/
      ;;
    container:name)
      lVALUE=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_ID}}@{{${lFIELD_CONTAINER_NAME}}}" | grep "^${lOBJECT_SID}" | cut -d@ -f2 )
      ;;
    container:image:id)
      lVALUE=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_ID}}@{{$lFIELD_CONTAINER_IMID}}" | grep "^${lOBJECT_SID}" | cut -d@ -f2)
      ;;
    container:image:name)
      lIMID=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_ID}}@{{$lFIELD_CONTAINER_IMID}}" | grep "^${lOBJECT_SID}" | cut -d@ -f2)
      lVALUE=$(luc_cimv2_property_get --image $lIMID name)
      ;;
    container:image:fullname)
      lIMID=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_ID}}@{{$lFIELD_CONTAINER_IMID}}" | grep "^${lOBJECT_SID}" | cut -d@ -f2)
      lVALUE=$(luc_cimv2_property_get --image $lIMID fullname)
      ;;
    image:tag)
      lVALUE=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_ID}}@{{$lFIELD_IMAGE_TAG}}"      | grep "^${lOBJECT_SID}" | cut -d@ -f2)
      ;;
    image:json:*|container:json:*)
      $lCIM_TOOL inspect --type  "$lOBJECT_SID" | jq -r ".[].${lFIELD_JSON}?" && return 0
      ;;
    *)
      luc_core_echo "warn" "porperty not yet managed : ${lOBJECT_PROPERTY}" && return 1
      ;;
  esac
  # do
  echo $lVALUE; return 0
} # function

# purpose: delete containers or images
# args: <OBJECT_TYPE> <OBJECT_SIDs>
luc_cimv2_delete() {
  local lMSG_USAGE="$(luc_core_method_name_get) --help | --image | --container  --all | --dangling | --all | --temp | <obj_id1> <obj_id2> ...]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) --image --all" 
  local lOBJECT_TYPE="$1"
  local lOBJECT_SID="$2"
  local lCIM_TOOL=''
  shift 1; local lOBJECT_LIST="$@" 
  local lCLI_DELETE_OPTION=''
  local lUSAGE_MSG="$(luc_core_method_name_get) --help|--container|--image --dangling|--all|--temp|<obj_id1> <obj_id2>"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1
  # purpose
  luc_core_echo "purp" "delete $lCIM_TOOL containers/images (no confirmation)"
  
  # checkorexit args are provided
  [ -z "$lOBJECT_TYPE"      ] ||
  [ -z "$lOBJECT_SID" ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 3

  # checkorexit args are managed
  [ "$lOBJECT_TYPE" != "--image"     ] && 
  [ "$lOBJECT_TYPE" != "--container" ] && luc_core_echo "usag" "$lMSG_USAGE" && return 3
  # 
  [ "$lOBJECT_SID"  == "--dangling"  ] && 
  [ "$lOBJECT_TYPE" == "--container" ] && luc_core_echo "caut" "dangling container not exists" && return 4
  
  # get list obj to delete
  [ "--all" ==  "$lOBJECT_SID" ] && {
    lOBJECT_LIST="$($lCIM_TOOL ${lOBJECT_TYPE/--/} list -aq)"
  }
  # 
  [ "--dangling" ==  "$lOBJECT_SID" ] && {
    lIMAGE_NONE="$($lCIM_TOOL images --all | awk '/<none>/ { print $3 }')"
    lIMAGE_DANG="$($lCIM_TOOL images --all --quiet --filter dangling=true)"
    # lOBJECT_LIST="${lIMAGE_NONE//$'\n'/ } ${lIMAGE_DANG//$'\n'/ }"
    lOBJECT_LIST="$(echo "${lIMAGE_NONE//$'\n'/ } ${lIMAGE_DANG//$'\n'/ }" | xargs)"
  }
  # 
  [ "--temp" ==  "$lOBJECT_SID" ] && {
    lOBJECT_LIST="$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --quiet --filter 'name=temp-')"
  }
  # checkorexit list is empty
  [ -z "$lOBJECT_LIST" ] && luc_core_echo "caut" "no objects to delete" && return 1
  
  # # info
  # luc_core_echo "info" "action   : delete ${lOBJECT_TYPE/--/}"
  # luc_core_echo "info" "list IDs : ${lOBJECT_LIST//$'\n'/ }"
  
  # # info   
  # luc_core_echo "info" "CLI > $lCIM_TOOL ${lOBJECT_TYPE/--/} rm ${lOBJECT_LIST//$'\n'/ }"
  # delete objects
  lECHOVAL=$($lCIM_TOOL ${lOBJECT_TYPE/--/} rm --force ${lOBJECT_LIST//$'\n'/ } 2>&1); lRETVAL=$?
  
  # check action
  [ "$lRETVAL" -eq 0   ] && luc_core_echo "done" "objects deleted" && return 0 || {
      luc_core_echo "warn" "$lECHOVAL"
      luc_core_echo "caut" "choose ${lOBJECT_TYPE/--/} among:"
      $lCIM_TOOL ${lOBJECT_TYPE/--/} list --all
      return 1
  } 
}

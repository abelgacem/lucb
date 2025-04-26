

# purpose: buildah list locally stored containers and images
# args: NONE
luc_cimb_list() {
  local lMSG_PURPOSE="list locally stored containers and images"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  
  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # do
  luc_core_echo "info" "buildah images"
  buildah images --all

  # do
  luc_core_echo "info" "buildah containers"
  buildah containers --all

  # do
  luc_core_echo "info" "podman containers"
  podman container list --all

} # function


# purpose: get a buildah container or image property
# note: output and return are used
# args: <OBJECT_TYPE> <OBJECT_SID> <OBJECT_PROPERTY>
luc_cimb_property_get() {
  local lMSG_PURPOSE="buildah get a container or image property by inspecting metedata or CLI"  
  local lMSG_USAGE="$(luc_core_method_name_get) --image|--container <OBJECT_SID> <OBJECT_PROPERTY>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) --image ae34 NAME" 
  local lOBJECT_TYPE="$1"
  local lOBJECT_SID="$2"
  local lOBJECT_PROPERTY="$3"
  local lLABEL_IMAGE_SHELL="${luc_EV_CIMB_LABEL_KEY_SHELL}"
  local lLABEL_IMAGE_OSNAME="${luc_EV_CIMB_LABEL_KEY_OSNAME}"
  local lFIELD_LABEL_SHELL lFIELD_LABEL_OSNAME
  # local lIMAGE_ID=''
  

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lOBJECT_TYPE"     ] ||
  [ -z "$lOBJECT_SID"      ] ||
  [ -z "$lOBJECT_PROPERTY" ] || 
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && {
    luc_core_echo "exam" "$lMSG_EXAMPLE"
    luc_core_echo "exam" "luc_cimb_property_get --image 2f json:History"  
    luc_core_echo "exam" "luc_cimb_property_get --image 2f json"  
    return 1
  }

  # checkorexit args are managed
  [ "$lOBJECT_TYPE" != "--image"     ] && 
  [ "$lOBJECT_TYPE" != "--container" ] && 
  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit object exists
  [ "$lOBJECT_TYPE" == "--image"     ] && {
    lECHOVAL=$(luc_cimb_image_check_exists $lOBJECT_SID); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1
  }
  [ "$lOBJECT_TYPE" == "--container" ] && {
    lECHOVAL=$(luc_cimb_container_check_exists $lOBJECT_SID); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1
  }
  
  ###### DEFINE VARIABLES
  { # define flags used in --format or by jq to extract targeted property in of the object inspected
    lFIELD_IMAGE_NAME='.Name'
    lFIELD_CONTAINER_ID='.ContainerID'
    lFIELD_CONTAINER_NAME='.ContainerName'
    lFIELD_IMAGE_ID='ImageID'
    lFIELD_CMD=".OCIv1.config.Cmd[]"
    # lFIELD_PORT="OCIv1.config.ExposedPorts"
    lFIELD_PORT=".Docker.config.ExposedPorts"
    lFIELD_ISRUNNING="State"
    lFIELD_CONFIG=".Docker.config"
    lFIELD_ENV=".Docker.config.Env"
    lFIELD_USER=".Docker.config.User"
    lFIELD_LABELS=".Docker.config.Labels"
    # lFIELD_LABEL_SHELL=$([ -z "${lLABEL_IMAGE_SHELL}" ] && echo "$lFIELD_LABELS" || echo ".Docker.config.Labels[\"${lLABEL_IMAGE_SHELL}\"]")
    # [ -z ${lLABEL_IMAGE_SHELL}  ] && lFIELD_LABEL_SHELL=$lFIELD_LABELS  || lFIELD_LABEL_SHELL=".Docker.config.Labels[\"${lLABEL_IMAGE_SHELL}\"]"
    # [ -z ${lLABEL_IMAGE_SHELL}  ] &&  lFIELD_LABEL_SHELL=".Docker.config.Labels[\"${lLABEL_IMAGE_SHELL}\"]"
    # [ -z ${lLABEL_IMAGE_OSNAME} ] && lFIELD_LABEL_OSNAME=$lFIELD_LABELS || lFIELD_LABEL_OSNAME=".Docker.config.Labels[\"${lLABEL_IMAGE_OSNAME}\"]"
    lFIELD_LABEL_SHELL=".Docker.config.Labels[\"${lLABEL_IMAGE_SHELL}\"]"
    lFIELD_LABEL_OSNAME=".Docker.config.Labels[\"${lLABEL_IMAGE_OSNAME}\"]"
    lFIELD_JSON="${lOBJECT_PROPERTY/json:/}"
    # lFIELD_ENV="Config | fromjson | .config | .Env[]"
    # lFIELD_ENV="OCIv1.config.Env"
  }
  # remove the char -- ; concatenate ; 
  lCHOICE="${lOBJECT_TYPE/--/}:$(echo "$lOBJECT_PROPERTY" | tr '[:upper:]' '[:lower:]')"
  lOBJECTS=${lOBJECT_TYPE#--}s
    

  # get the object property
  case "$lCHOICE" in
    container:id)
      lVALUE=$(buildah $lOBJECTS --all --format "{{${lFIELD_CONTAINER_ID}}}" | grep "^${lOBJECT_SID}")
      ;;
    image:id)
      lVALUE=$(buildah $lOBJECTS --all --format "{{$lFIELD_IMAGE_NAME}}:{{.Tag}}:{{.ID}}" | grep ":$lOBJECT_ID" | cut -d':' -f3)
      ;;
    container:name)
      lVALUE=$(buildah $lOBJECTS --all --format "{{${lFIELD_CONTAINER_ID}}}:{{${lFIELD_CONTAINER_NAME}}}" | grep "^${lOBJECT_SID}" | cut -d: -f2)
      ;;
    container:image:id)
      lVALUE=$(buildah $lOBJECTS --all --format "{{${lFIELD_CONTAINER_ID}}}:{{.${lFIELD_IMAGE_ID}}}" | grep "^${lOBJECT_SID}" | cut -d: -f2-)
      ;;
    container:image:name)
      tIMAGE_ID=$(buildah $lOBJECTS --all --format "{{${lFIELD_CONTAINER_ID}}}:{{.${lFIELD_IMAGE_ID}}}" | grep "^${lOBJECT_SID}" | cut -d: -f2-)
      lVALUE=$(buildah $lOBJECTS --all --format "{{$lFIELD_IMAGE_NAME}}:{{.Tag}}:{{.ID}}" | grep "$tIMAGE_ID" | cut -d':' -f1-2)
      ;;
    image:fullname)
      lVALUE=$(buildah $lOBJECTS --all --format "{{.ID}}:{{$lFIELD_IMAGE_NAME}}:{{.Tag}}" | grep "^$lOBJECT_SID" | cut -d':' -f2-)
      ;;
    image:name)
      lVALUE=$(buildah $lOBJECTS --all --format {{.ID}}:"{{$lFIELD_IMAGE_NAME}}:{{.Tag}}:" | grep "^$lOBJECT_SID" | awk -F'/' '{print $NF}'  )
      ;;
    image:sname)
      lVALUE=$(buildah $lOBJECTS --all --format {{.ID}}:"{{$lFIELD_IMAGE_NAME}}:{{.Tag}}:" | grep "^$lOBJECT_SID" | awk -F'/' '{print $NF}'  | awk -F':' '{print $1}')
      ;;
    image:path)
      lVALUE=$(buildah $lOBJECTS --all --format "{{.ID}}:{{$lFIELD_IMAGE_NAME}}:{{.Tag}}" | grep "^$lOBJECT_SID" | cut -d':' -f2 | xargs dirname)
      ;;
    image:tag)
      lVALUE=$(buildah $lOBJECTS --all --format "{{.ID}}:{{$lFIELD_IMAGE_NAME}}:{{.Tag}}" | grep "^$lOBJECT_SID" | awk -F':' '{print $NF}')
      ;;
    image:user|container:user)
      lVALUE=$(buildah inspect $lOBJECT_SID | jq -r "${lFIELD_USER}?")
      ;;
    image:cmd)
      lVALUE=$(buildah inspect --type image $lOBJECT_SID | jq -r "${lFIELD_CMD}?")
      ;;
    image:config|container:config)
      lVALUE=$(buildah inspect  $lOBJECT_SID | jq  "${lFIELD_CONFIG}?") 
      ;;
    image:envar|container:envar)
      lVALUE=$(buildah inspect  $lOBJECT_SID | jq  "${lFIELD_ENV}?" ) 
      ;;
    image:envar:path|container:envar:path)
      lVALUE=$(buildah inspect  $lOBJECT_SID | jq  -r "${lFIELD_ENV}?" | jq -r ".[]" | grep -o 'PATH=[^ ]*' | cut -d= -f2) 
      ;;
    container:label|image:label)
      lVALUE=$(buildah inspect  $lOBJECT_SID | jq -r "${lFIELD_LABELS}?")
      ;;
    container:shell)
      tIMAGEID=$(luc_cimb_property_get --container $lOBJECT_SID image:id)
      lVALUE=$(luc_cimb_property_get --image ${tIMAGEID:0:6} SHELL)
      ;;
    image:shell)
      lVALUE=$(buildah inspect  $lOBJECT_SID | jq -r "${lFIELD_LABEL_SHELL}?")
      [ "null" == "$lVALUE" ] && lVALUE=$(luc_cimb_property_get --image $lOBJECT_SID CMD)
      ;;
    image:os:name|container:os:name)
      lVALUE=$(buildah inspect  $lOBJECT_SID | jq  -r ".${lFIELD_LABEL_OSNAME}?" ) 
      ;;
    container:isrunning)
      lVALUE=$(buildah inspect --type container $lOBJECT_SID | jq -r ".${lFIELD_ISRUNNING}?")
      ;;
    image:port|container:port)
      lVALUE=$(buildah inspect  $lOBJECT_SID | jq -r "${lFIELD_PORT}?")
      ;;
    container:json)
      buildah inspect --type container "$lOBJECT_SID" | jq . && return 0
      ;;
    container:json:*)
      buildah inspect --type container "$lOBJECT_SID" | jq -r ".${lFIELD_JSON}?" && return 0 # output nothing if not exists
      ;;
    image:json)
      buildah inspect --type image "$lOBJECT_SID" | jq . && return 0
      ;;
    image:json:*)
      buildah inspect --type image "$lOBJECT_SID" | jq -r ".${lFIELD_JSON}?" && return 0 # output nothing if not exists
      ;;
    # container:cmd)
    #   lVALUE=$(buildah inspect --type container $lOBJECT_SID | jq -r ".${lFIELD_CMD}?") 
    #   ;;
    # container:env)
    #   lVALUE=$(buildah inspect --type container $lOBJECT_SID | jq  ".${lFIELD_ENV}?" ) 
    #   ;;
    # image:label)
    #   lVALUE=$(buildah inspect --type image $lOBJECT_SID | jq -r ".${lFIELD_LABELS}?")
    #   ;;
    # image:shell)
    #   lVALUE=$(buildah inspect --type image $lOBJECT_SID | jq -r ".${lFIELD_LABEL_SHELL}?")
    #   ;;
    *)
      luc_core_echo "warn" "atribute:${lOBJECT_PROPERTY} not yet managed" && return 1
      ;;
  esac
  # do
  echo $lVALUE; return 0
} # function


# purpose: get a buildah container or image SID from name
# note: output and return are used
# args: <OBJECT_TYPE> <OBJECT_NAME>
luc_cimb_sid_get() {
  local lMSG_PURPOSE="buildah get an objet SID from its name"  
  local lMSG_USAGE="$(luc_core_method_name_get) --image | --container <IMAGE_SID>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) aeb34e" 
  local lOBJECT_TYPE="$1"
  local lOBJECT_NAME="$2"

  # checkorexit args are provided
  [ -z "$lOBJECT_NAME" ] ||
  [ -z "$lOBJECT_TYPE" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit args are managed
  [ "$lOBJECT_TYPE" != "--image"     ] && 
  [ "$lOBJECT_TYPE" != "--container" ] && 
  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # get name
  [ "$lOBJECT_TYPE" == "--container"     ] && {
    lECHOVAL=$(buildah inspect --type container --format {{.ContainerID}} ${lOBJECT_NAME} 2>/dev/null ); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ]  && luc_core_echo "warn" "failed to get container ID from container: ${lOBJECT_NAME}" && return 1 || lOBJECT_SID="${lECHOVAL:0:5}"
  }
  [ "$lOBJECT_TYPE" == "--image" ] && {
    lECHOVAL=$(buildah inspect --type image --format {{.FromImageID}} ${lOBJECT_NAME} 2>/dev/null ); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ]  && luc_core_echo "warn" "failed to get container ID. does container from container: ${lOBJECT_NAME}" && return 1 || lOBJECT_SID="${lECHOVAL:0:5}"
  }

  # return
  echo $lOBJECT_SID; return 0


} # function

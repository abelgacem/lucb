# shortcut
luc_cim_create_image() { luc_cim_image_create "$@"; }
luc_cim_enter_image()  { luc_cim_image_enter  "$@";  }
luc_cim_pull_image()   { luc_cim_image_pull   "$@";   }
luc_cim_delete_image() { luc_cim_delete "--image" "$@"; }
luc_cim_image_delete() { luc_cim_delete "--image" "$@"; }
luc_cim_image_property_get() { luc_cim_property_get "--image" "$@"; }

# purpose: pull one or more container images
# args: lIMAGE
luc_cim_image_pull() {
  # define var
  local lIMAGE_TO_PULL="$1"
  local lIMAGE_LIST
  local lIMAGE_OS_LIST="
    ubuntu:25.04
    rockylinux:9.3
    almalinux:9.5
    alpine:3.20.3
    gcr.io/kaniko-project/executor:v1.23.2
    gcr.io/kaniko-project/executor      
    registry:2.8.3      
  "
  local lCIM_TOOL=''
  local lUSAGE_MSG="$(luc_core_method_name_get) --all|--image <lIMAGE_TO_PULL01> <lIMAGE_TO_PULL02>"

  # info
  luc_core_echo "purp" "pull one or more container images from a registry"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1


  # checkorexit args are provided
  [ "--help" == "$1" ] && {    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) --all (ie. pull all image define in envvar)" 
    luc_core_echo "exam" "$(luc_core_method_name_get) --image nginx:latest alpine:3.23 reg/repo/name:tag" 
    return 1
  }
  # checkorexit args are managed
  [ "$lIMAGE_TO_PULL" != "--all"   ] && 
  [ "$lIMAGE_TO_PULL" != "--image" ] && 
  luc_core_echo "usag" "$lUSAGE_MSG" && return 1
  
  # define var according to input
  [ "$lIMAGE_TO_PULL" == "--all" ] && lIMAGE_LIST=${lIMAGE_OS_LIST}
  [ "$lIMAGE_TO_PULL" == "--image" ] && {
    # get $@
    shift 1
    
    # checkorexit $@ exists
    [ -z "$@" ] && luc_core_echo "caut" "no image provided" && return 1 
    
    # define var
    lIMAGE_LIST=${@}
  }
  
  # do
  for lIMG in ${lIMAGE_LIST}; do $lCIM_TOOL pull $lIMG;done

  # info
  luc_core_echo "done" "pulled image: ${lIMAGE_LIST}"
  return 0
}

# purpose: list available tags availble in registry for an image
# args: lIMAGE_NAME
luc_cim_image_tag_list() {
  # define var
  lIMAGE_NAME="$1"
  local lUSAGE_MSG="$(luc_core_method_name_get) <lIMAGE_NAME>"

  # info
  luc_core_echo "purp" "list available tags availble in docker hub public registry for image"


  # checkorexit args are provided
  [ -z "$lIMAGE_NAME" ]       ||
  [ "--help" == "$1" ] && {    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) nginx" 
    luc_core_echo "exam" "$(luc_core_method_name_get) alpine" 
    return 1
  }

  # info
  luc_core_echo "info" "list of tagd for image: $lIMAGE_NAME" 

  # get tags
  curl -s https://registry.hub.docker.com/v2/repositories/library/${lIMAGE_NAME}/tags/ | jq  '.results[]?["name"]'

  # info
  luc_core_echo "done"
}

# purpose: create an image from a container
# args: <lIMAGE_NAME> <lCONTAINER_SID>
luc_cim_image_create() {
  local lIMAGE_NAME="$1"
  local lCONTAINER_SID="$2"
  local lCONTAINER_ID='' 
  local lUSAGE_MSG="$(luc_core_method_name_get) <lIMAGE_NAME> <lCONTAINER_SID>"
  local lCIM_TOOL=''

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1

  # info
  luc_core_echo "purp" "create a $lCIM_TOOL image from a $lCIM_TOOL container"

  # checkorexit args are provided
  [ -z "$lIMAGE_NAME" ]       ||
  [ -z "$lCONTAINER_SID" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) test:test 12"
    return 1
  }

  # checkorexit container exists
  lECHOVAL=$(luc_cim_id_get --container  $lCONTAINER_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lCONTAINER_ID="$lECHOVAL"

  # lookup field according to tool
  [ "$lCIM_TOOL" == "docker" ]  && {
    lFIELD_IMAGE_NAME='Repository'
  }
  [ "$lCIM_TOOL" == "buildah" ] && {
    lFIELD_IMAGE_NAME='Name'
  }
  
  # # checkorexit image not exists
  # lECHOVAL=$($lCIM_TOOL images --all --format "{{.${lFIELD_IMAGE_NAME}}:{{.Tag}}" | grep "^${lIMAGE_NAME}"); lRETVAL=$?  
  # [ ! -z "$lECHOVAL" ] && luc_core_echo "warn" "image ${lIMAGE_NAME} already exists"  && return 1

  # create image
  lEHOVAL=$($lCIM_TOOL commit ${lCONTAINER_SID} ${lIMAGE_NAME} 2>&1); lRETVAL=$?
  # check action
  [ "$lRETVAL" -eq 0 ] && {
    luc_core_echo "done" "Created image ${lIMAGE_NAME} from container ${lCONTAINER_SID} ($(luc_cim_property_get --container ${lCONTAINER_SID} name))"  
    return 0 
  } || {
    luc_core_echo "warn" "cannot create image ${lIMAGE_NAME} from container ${lCONTAINER_SID} > $lEHOVAL"
    return 1
  }
}

# purpose: enter an image
# args: <lIMAGE_SID> [OPIONS]
luc_cim_image_enter() {
  local lIMAGE_SID="$1"
  local lUSAGE_MSG="$(luc_core_method_name_get) <lIMAGE_SID> [OPIONS]"
  local lCONTAINER_NAME_TEMP="temp-$(luc_core_id_get 5)"
  local lCIM_TOOL=''
  local lIMAGE_SHELL='/bin/bash'

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1

  # info
  luc_core_echo "purp" "enter a $lCIM_TOOL image"

  # checkorexit args are provided
  [ -z "$lIMAGE_SID" ]       ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) alpine:test"
    luc_core_echo "exam" "$(luc_core_method_name_get) alpine:test -v host:local:ro"
    return 1
  }

  # checkorexit image exists
  lECHOVAL=$(luc_cim_id_get --image  $lIMAGE_SID; lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ID="$lECHOVAL"

  # getorexit image SHELL
  lECHOVAL=$(luc_cim_property_get --image  $lIMAGE_SIDSHELL); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SHELL="$lECHOVAL"

  # getorexit image name
  lECHOVAL=$(luc_cim_property_get --image  $lIMAGE_SIDNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_NAME="$lECHOVAL"

  # for public repository container 
  [ -z "$lIMAGE_SHELL" ] && {
    [ "alpine" == "$lIMAGE_NAME" ] && lIMAGE_SHELL="/bin/sh" || lIMAGE_SHELL="/bin/bash"
  }
    
  # get OPTIONS
  shift 1; lOPTIONS=$@
  # info
  luc_core_echo "info" "enter image $lIMAGE_SID($(luc_cim_property_get --image $lIMAGE_SIDfullname)) via temporary container ${lCONTAINER_NAME_TEMP}"


  ##### debug #####
  luc_core_echo "debu" "start debug mode"
  luc_core_echo "debu" "lCONTAINER_NAME_TEMP=$lCONTAINER_NAME_TEMP"
  luc_core_echo "debu" "lIMAGE_SID=$lIMAGE_SID"
  luc_core_echo "debu" "lIMAGE_NAME=$lIMAGE_NAME"
  luc_core_echo "debu" "lIMAGE_SHELL=$lIMAGE_SHELL"
  luc_core_echo "debu" "lOPTIONS=$lOPTIONS"
  luc_core_echo "debu" "end debug mode"
  ##### debug #####

  # when docker
  [ "$lCIM_TOOL" == "docker" ]  && {
    # enter image via a temporary container
    $lCIM_TOOL run -it --rm  --name ${lCONTAINER_NAME_TEMP} $lOPTIONS $lIMAGE_SID${lIMAGE_SHELL} -l
    return 0
  }

  # when buildah
  [ "$lCIM_TOOL" == "buildah" ] && {
    # createorexit temporary container
    luc_core_echo "info" "create temporary container ${lCONTAINER_NAME_TEMP}"
    lECHOVAL=$(luc_cim_container_create ${lCONTAINER_NAME_TEMP} $lIMAGE_SID; lRETVAL=$?  
    [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1
    # enter the temporary container
    luc_core_echo "info" "enter temporary container ${lCONTAINER_NAME_TEMP}"
    $lCIM_TOOL run -t $lOPTIONS ${lCONTAINER_NAME_TEMP} ${lIMAGE_SHELL} -l 
    luc_core_echo "caut" "deleted temporary container ${lCONTAINER_NAME_TEMP}"
    $lCIM_TOOL rm ${lCONTAINER_NAME_TEMP}
    return 0
  }
}

# purpose: check a container exists
# args: <lIMAGE_NAME>
luc_cim_imge_check_exists() {
  local lIMAGE_NAME="$1"
  local lUSAGE_MSG="$(luc_core_method_name_get) <lIMAGE_NAME>"
  local lCIM_TOOL=''

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1

  # checkorexit args are provided
  [ -z "$lIMAGE_NAME" ]       ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) ab12" 
    return 1
  }

  # lookup field according to object type
  [ "$lCIM_TOOL" == "docker" ]  && {
    lFIELD_NAME='Repository'
  }
  [ "$lCIM_TOOL" == "buildah" ] && {
    lFIELD_NAME='Name'
  }

  # checkorexit image exists
  lRESULT=$($lCIM_TOOL images --all --format "{{.${lFIELD_NAME}}}" | grep -w "^${lCONTAINER_NAME}" 2>/dev/null)
  [ -z "$lRESULT" ] && luc_core_echo "warn" "image not exists : ${lCONTAINER_NAME} "  && return 1

  # info
  return 0
}

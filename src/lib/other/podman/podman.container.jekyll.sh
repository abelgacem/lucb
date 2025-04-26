# purpose: get info about the container purpose and conf  
# args: none
luc_podman_container_info() {
  local lMSG_PURPOSE="get info about the container purpose and conf"  
  local lMSG_USAGE="$(luc_core_method_name_get) <JEKYLL_IMAGE_SID> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 

}

# purpose: podman create a jekyll container from a jekyll image
# args: <JEKYLL_IMAGE_SID> <JEKYLL_WKSPC_HOST_FOLDER> [OPTIONS]
luc_podman_cjekyll_create() {
  local lMSG_PURPOSE="podman create a jekyll container from a jekyll image"  
  local lMSG_USAGE="$(luc_core_method_name_get) <JEKYLL_IMAGE_SID> <JEKYLL_WKSPC_HOST_FOLDER> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lCONTAINER_NAME="${luc_EV_CIMAGE_PREFIX_CONTAINER}-jekyll"
  local lIMAGE_SRC_SID="$1"
  local lFOLDER_JEKYLL_WKSPC_HOST="$2"
  local lFOLDER_LUC_HOST="$luc_EV_PODMAN_LUC_CORE_HOME"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"
  local lFOLDER_JEKYLL_CONTAINER="$luc_EV_PODMAN_JEKYLL_WKSPC"
  local LUCSETUP="${lFOLDER_LUC_CONTAINER}/${luc_EV_PODMAN_LUC_SRC_RELPATH}"  
  local lCLILOOP="$luc_EV_PODMAN_CLILOOP"
  local lVOLUMES
  shift 2; local lOPTIONS="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lIMAGE_SRC_SID"  ] ||
  [ -z "$lFOLDER_JEKYLL_WKSPC_HOST"  ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  luc_core_echo "chec" "image exists"
  lECHOVAL=$(luc_buildah_image_check_exists  $lIMAGE_SRC_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2

  # getorexit image FULLNAME
  luc_core_echo "step" "get image FULLNAME"
  lECHOVAL=$(luc_buildah_property_get --image  ${lIMAGE_SRC_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 3 || lIMAGE_SRC_FULLNAME="$lECHOVAL"

  # getorexit image SHELL
  luc_core_echo "step" "get image SHELL"
  lECHOVAL=$(luc_buildah_property_get --image  ${lIMAGE_SRC_SID} SHELL); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 4 || lIMAGE_SRC_SHELL="$lECHOVAL"

  ###### DELETE CURRENT CONTAINER #######################
  luc_core_echo "step" "stop container if exists: $lCONTAINER_NAME"
  podman stop $lCONTAINER_NAME
  luc_core_echo "step" "delete container if exists: $lCONTAINER_NAME"
  podman rm $lCONTAINER_NAME

  ###### DEFINE CONFIGURATION ###########################
  # host volume to mount into container
  lVOLUMES="-v ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}:ro -v ${lFOLDER_JEKYLL_WKSPC_HOST}:${lFOLDER_JEKYLL_CONTAINER}:rw"

  # checkorexit host folder exists
  luc_core_echo "chec" "host foler exists: $lFOLDER_LUC_HOST"
  lECHOVAL=$(luc_core_check_folder_exits  $lFOLDER_LUC_HOST); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && luc_core_echo "warn" "$lECHOVAL" && return 5

  # checkorexit host folder exists
  luc_core_echo "chec" "host foler exists: $lFOLDER_JEKYLL_WKSPC_HOST"
  lECHOVAL=$(luc_core_check_folder_exits  $lFOLDER_JEKYLL_WKSPC_HOST); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && luc_core_echo "warn" "$lECHOVAL" && return 6

  ###### INFO                       #################### 
  luc_core_echo "debu" "lIMAGE_SRC   : $lIMAGE_SRC_FULLNAME ($lIMAGE_SRC_SID) ($lIMAGE_SRC_SHELL)"
  luc_core_echo "debu" "lVOLUMES  : $lVOLUMES"
    
  ###### CREATE PODMAN CONTAINER  ###################### 
  luc_core_echo "step" "create a running container in detached mode with infinite loop"
  luc_core_echo "debu" "podman run -d --name $lCONTAINER_NAME -P $lOPTIONS $lVOLUMES $lIMAGE_SRC_SID $lCLILOOP"
  # lECHOVAL=$(podman run -d --name $lCONTAINER_NAME -P $lOPTIONS $lVOLUMES $lIMAGE_SRC_SID $lIMAGE_SRC_SHELL -c '$lCLILOOP'); lRETVAL=$?
  lECHOVAL=$(podman run -d --name $lCONTAINER_NAME -P $lOPTIONS $lVOLUMES $lIMAGE_SRC_SID $lCLILOOP); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 7 || lCONTAINER_SID="$lECHOVAL"

  # getorexit container PORT
  luc_core_echo "step" "create the container in detached mode"
  lECHOVAL=$(podman port $lCONTAINER_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 8 || lCONTAINER_PORT_HOST="$lECHOVAL"

  ###### INFO                       #################### 
  luc_core_echo "debu" "lCONTAINER_NAME      : $lCONTAINER_NAME (${lCONTAINER_SID:0:5})"
  luc_core_echo "debu" "lCONTAINER_PORT_HOST : $lCONTAINER_PORT_HOST"

  ###### ENTER PODMAN CONTAINER  ####################### 
  luc_core_echo "step" "enter the running container"
  # podman exec -it $lCONTAINER_NAME $lIMAGE_SRC_SHELL -l
  podman exec -it $lCONTAINER_NAME $lIMAGE_SRC_SHELL

  #
  return 0
}

# purpose: port forward the served topix
# note: must be executed from anoter VM
# args: <LOCAL_PORT>
luc_podman_cjekyll_pforward() {
  local lMSG_PURPOSE="port forward a served topix"
  local lMSG_USAGE="$(luc_core_method_name_get) <LOCAL_PORT>"
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lCONTAINER_NAME="${luc_EV_CIMAGE_PREFIX_CONTAINER}-jekyll"
  local lLOCAL_PORT="$1"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lLOCAL_PORT"   ] ||
  [ "--help" == "$1"    ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # getorexit container host PORT
  luc_core_echo "step" "Get the container HOST PORT on the remote VM"
  lECHOVAL=$(podman port $lCONTAINER_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 5 || lCONTAINER_PORT_HOST="$lECHOVAL"
}
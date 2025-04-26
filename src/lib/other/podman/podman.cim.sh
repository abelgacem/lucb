# purpose: podman create a container from an image
# args: <CONTAINER_NAME> <IMAGE_SID> [OPTIONS]
luc_podman_container_create() {
  local lMSG_PURPOSE="podman create a container from an image"  
  local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_NAME> <IMAGE_SID> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lCONTAINER_NAME="$1"
  local lIMAGE_SRC_SID="$2"
  local lFOLDER_LUC_HOST="${luc_EV_PODMAN_LUC_CORE_HOME}"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"
  local LUCSETUP="${lFOLDER_LUC_CONTAINER}/${luc_EV_PODMAN_LUC_SRC_RELPATH}"  
  local lCLILOOP="$luc_EV_PODMAN_CLILOOP"
  shift 2; local lOPTIONS="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lCONTAINER_NAME" ] ||
  [ -z "$lIMAGE_SRC_SID"  ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

   # checkorexit image exists
  luc_core_echo "chec" "image exists"
  lECHOVAL=$(luc_buildah_image_check_exists  $lIMAGE_SRC_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # getorexit image FULLNAME
  luc_core_echo "step" "get image FULLNAME"
  lECHOVAL=$(luc_buildah_property_get --image  ${lIMAGE_SRC_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lIMAGE_SRC_FULLNAME="$lECHOVAL"

  # getorexit image SHELL
  luc_core_echo "step" "get image SHELL"
  lECHOVAL=$(luc_buildah_property_get --image  ${lIMAGE_SRC_SID} SHELL); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 3 || lIMAGE_SRC_SHELL="$lECHOVAL"

  ###### INFO                       #################### 
  luc_core_echo "debu" "lIMAGE_SRC      : $lIMAGE_SRC_FULLNAME ($lIMAGE_SRC_SID) ($lIMAGE_SRC_SHELL)"
  
  ###### CREATE PODMAN CONTAINER  ###################### 
  luc_core_echo "step" "create a running container in detached mode and random port mapping with infinite loop"
  lECHOVAL=$(podman run -d --name $lCONTAINER_NAME -P $lOPTIONS  $lIMAGE_SRC_SID $lCLILOOP); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 4 || lCONTAINER_SID="$lECHOVAL"

  # getorexit container host PORT
  luc_core_echo "step" "Get the container HOST PORT"
  lECHOVAL=$(podman port $lCONTAINER_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 5 || lCONTAINER_PORT_HOST="$lECHOVAL"

  ###### INFO                       #################### 
  luc_core_echo "debu" "lCONTAINER_NAME      : $lCONTAINER_NAME (${lCONTAINER_SID:0:5})"
  luc_core_echo "debu" "lCONTAINER_PORT_HOST : $lCONTAINER_PORT_HOST"

  ###### ENTER PODMAN CONTAINER  ####################### 
  luc_core_echo "step" "enter the running container"
  podman exec -it $lCONTAINER_NAME $lIMAGE_SRC_SHELL -l

  #
  return 0
}
# purpose: podman interactive enter an image
# args: <IMAGE_SID> [OPTIONS]
luc_podman_image_enter() {
  local lMSG_PURPOSE="podman interactive enter an image"
  local lMSG_USAGE="$(luc_core_method_name_get) <IMAGE_SID> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12 -v xxx:yyy" 
  local lIMAGE_SID="$1"
  shift 1; local lOPTIONS="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lIMAGE_SID" ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  luc_core_echo "chec" "image exists"
  lECHOVAL=$(luc_buildah_image_check_exists  $lIMAGE_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # getorexit image exists SHELL
  luc_core_echo "step" "get image SHELL"
  lECHOVAL=$(luc_buildah_property_get --image  ${lIMAGE_SID} SHELL); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lIMAGE_SHELL="$lECHOVAL"

  # enter image
  podman run -it $lOPTIONS $lIMAGE_SID $lIMAGE_SHELL

  # return
  return 20
}


# purpose: podman interactive enter a container
# note: if a volume was mounted with run, it is still mounted
# args: <CONTAINER_SID> [OPTIONS]
luc_podman_container_enter() {
  local lMSG_PURPOSE="podman interactive enter a container"
  local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_SID> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lCONTAINER_SID="$1"
  shift 1; local lOPTIONS="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lCONTAINER_SID" ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit container exists
  luc_core_echo "chec" "container exists"
  lECHOVAL=$(luc_buildah_container_check_exists  $lCONTAINER_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # getorexit container SHELL
  luc_core_echo "step" "get container SHELL"
  lECHOVAL=$(luc_buildah_property_get --container  $lCONTAINER_SID SHELL); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lCONTAINER_SHELL="$lECHOVAL"

  # enter image
  podman exec -it $lOPTIONS $lCONTAINER_SID $lCONTAINER_SHELL

  # return
  return 20
}
# # create a container from an image
# podman run -it --name $lCONTAINER_NAME -p $lHOST_PORT:4000 $lIMAGE_SRC_SID
# podman run -it --name $lCONTAINER_NAME -P $lIMAGE_SRC_SID # use a random host port
# # restart
# podman start -ai jekyll_debug
# # IP
# podman inspect -f '{{ .NetworkSettings.IPAddress }}' jekyll_debug

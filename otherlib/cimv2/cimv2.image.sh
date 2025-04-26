# purpose: enter an image
# args: <MAGE_SID> [OPIONS]
luc_cimv2_image_enter() {
  local lMSG_USAGE="$(luc_core_method_name_get) <IMAGE_SID> [OPIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12 -p 4000:4001" 
  local lIMAGE_SID="$1"
  local lCONTAINER_NAME_TEMP="temp-$(luc_core_id_get 5)"
  local lCIM_TOOL=''
  local lIMAGE_SHELL='/bin/bash'
  shift 1; local lOPTIONS="$@"; 

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman  && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | buildah | podman is installed" && return 1
  # purpose
  luc_core_echo "purp" "use $lCIM_TOOL to enter an image via a temporary container"

  # checkorexit args are provided
  [ -z "$lIMAGE_SID" ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  lECHOVAL=$(luc_cimv2_check_exists --image $lIMAGE_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # getorexit image shell
  lECHOVAL=$(luc_cimv2_property_get --image $lIMAGE_SID SHELL); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SHELL="$lECHOVAL"

  # getorexit image fullname
  lECHOVAL=$(luc_cimv2_property_get --image $lIMAGE_SID FULLNAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_FULLNAME="$lECHOVAL"

  # info
  luc_core_echo "info" "image       : $lIMAGE_FULLNAME ($lIMAGE_SID)"
  luc_core_echo "info" "image shell : $lIMAGE_SHELL"
  luc_core_echo "info" "options     : $lOPTIONS"
  luc_core_echo "info" "temp container : $lCONTAINER_NAME_TEMP"

  
  # create temporary container to enter image
  luc_core_echo "info" "enter image via the temporary container"
  # luc_core_echo "debu" "$lCIM_TOOL run -it --rm  --name ${lCONTAINER_NAME_TEMP} $lOPTIONS $lIMAGE_SID${lIMAGE_SHELL} -l"
  $lCIM_TOOL run -it --rm  --name ${lCONTAINER_NAME_TEMP} $lOPTIONS $lIMAGE_SID${lIMAGE_SHELL} -l
  
  return 5

# return  
  luc_core_echo "done" "exit image $lIMAGE_FULLNAME ($lIMAGE_SID); temporary container auto cleaned"
  return 0  

}

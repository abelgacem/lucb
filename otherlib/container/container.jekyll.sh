# shortcut
luc_container_create_jekyll() { luc_container_jekyll_create "$@"; }

# Purpose: create a jekyll container from a jekyll container image
# args <IMAGE_JEKYLL_SID> <SERVER_HOST_PORT>
luc_container_jekyll_create()  {
  # define var
  local lMSG_USAGE="$(luc_core_method_name_get) <IMAGE_JEKYLL_SID> <SERVER_HOST_PORT>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12 -4001" 
  local lIMAGE_JEKYLL_SID="$1"
  local lHOST_PORT="$2"
  local lTOOL="jekyll"
  local lCONTAINER_NAME="${luc_EV_CONTAINER_PREFIX}-$lTOOL"
  local lFOLDER_LUC_HOST="${luc_EV_CONTAINER_LUC_HOME}"
  local lFOLDER_LUC_CONTAINER="/home/${luc_EV_CONTAINER_OS_USER_SUDO}/wkspc/luc"
  local lFILE_LUC_BOOT="${luc_EV_CONTAINER_BOOT_RELPATH}"
  local LUCSETUP_HOST="${lFOLDER_LUC_HOST}/${lFILE_LUC_BOOT}"
  local LUCSETUP_CONTAINER="${lFOLDER_LUC_CONTAINER}/${lFILE_LUC_BOOT}"
  local lFOLDER_JEKYLL_WKSPC_HOST="$HOME/wkspc/$lTOOL/"
  local lFOLDER_JEKYLL_WKSPC_CONTAINER="/home/${luc_EV_CONTAINER_OS_USER_SUDO}/wkspc/$lTOOL/"

  # info
  luc_core_echo "purp" "create a $lTOOL container from a ruby $lTOOL image"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1

  # checkorexit args are provided
  [ -z "$lIMAGE_SRC_SID" ] ||
  [ -z "$lHOST_PORT"     ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "yo $lUSAGE_MSG 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12" 
    return 1
  }

  # checkorexit file exists
  lECHOVAL=$(luc_core_check_file_exits "${LUCSETUP_HOST}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # checkorexit folder exists
  lECHOVAL=$(luc_core_check_folder_exits "${lFOLDER_JEKYLL_WKSPC_HOST}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && luc_core_echo "warn" "$lECHOVAL" && return 1

  # checkorexit image exists
  lECHOVAL=$(luc_cim_id_get --image  ${lIMAGE_SRC_SID}); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # getorexit image FULLNAME
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_SRC_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_FULLNAME="$lECHOVAL"

  # getorexit image PORT
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_SRC_SID} PORT); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_PORT="$lECHOVAL"

  # define VOLUME
  lOPTION_VOLUME="-v   ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}:ro -v ${lFOLDER_JEKYLL_WKSPC_HOST}:${lFOLDER_JEKYLL_WKSPC_CONTAINER}:rw"
  lOPTION_ENVAR="--env LUCSETUP=${LUCSETUP_CONTAINER}"
  lOPTION_PORT="--publish $lHOST_PORT${lIMAGE_SRC_PORT}"

  [ "$lCIM_TOOL" == "docker" ]  && {
    lFIELD_CONTAINERID='ID'
    lOPTION_ENVAR_AT_CREATE="${lOPTION_ENVAR}"
    lOPTION_PORT_AT_CREATE="${lOPTION_PORT}"
}



  [ "$lCIM_TOOL" == "buildah" ] && {
    lFIELD_CONTAINERID='ContainerID'
    lOPTION_ENVAR_AT_CREATE=""
  }
  [ "$lCIM_TOOL" == "podman" ] && {
    lOPTION_ENVAR_AT_CREATE="${lOPTION_ENVAR}"
    lFIELD_CONTAINERID='ContainerID'
    lOPTION_PORT_AT_CREATE="${lOPTION_PORT}"
  }

  # info
  luc_core_echo "step" "create jeky container ${lCONTAINER_NAME}"
  luc_core_echo "info" "conf > $lTOOL image   : ${lIMAGE_SRC_FULLNAME}. Sid : ${lIMAGE_SRC_SID}."
  luc_core_echo "info" "conf > $lTOOL container  : ${lCONTAINER_NAME}"
  luc_core_echo "info" "conf > volume mounted : ${lOPTION_VOLUME}"
  luc_core_echo "info" "conf > container port : ${lIMAGE_SRC_PORT}"
  luc_core_echo "info" "conf > port mapping   : ${lOPTION_PORT}"
  luc_core_echo "info" "conf > envar          : ${lOPTION_ENVAR}"

  luc_core_debug

  # createordonothing container if not exist with ENVAR
  lECHOVAL=$(luc_cim_container_create ${lCONTAINER_NAME} ${lIMAGE_SRC_SID} \
    ${lOPTION_ENVAR_AT_CREATE}  \
    ${lOPTION_PORT_AT_CREATE}  \
  ); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" 

  # checkorexit container exits
  luc_core_echo "chec" "container ${lCONTAINER_NAME} is created"
  lECHOVAL=$(luc_cim_container_check_exists "${lCONTAINER_NAME}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # getorexit container id
  lCONTAINER_ID=$($lCIM_TOOL inspect --type container --format {{.${lFIELD_CONTAINERID}}} ${lCONTAINER_NAME})
  lCONTAINER_SID="${lCONTAINER_ID:0:5}"

  # # When BUILDAH configure 
  # [ "$lCIM_TOOL" == "buildah" ] && {
  #   luc_core_echo "step" "configure ENVVARS into $lCIM_TOOL container"
  #   buildah config ${lOPTION_ENVAR} ${lCONTAINER_NAME}
  # }

  # enter the container with VOLUME, ENVAR
  # luc_cim_container_enter ${lCONTAINER_SID} ${lOPTION_VOLUME} ${lOPTION_ENVAR}
  luc_cim_container_enter ${lCONTAINER_SID} ${lOPTION_VOLUME}

  # info
  luc_core_echo "info" "exit container > ${lCONTAINER_NAME}"

} # end function
  

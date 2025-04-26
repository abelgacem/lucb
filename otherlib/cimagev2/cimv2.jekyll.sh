# purpose: create a container from an image
# args: <RUBY_IMAGE_SID>
luc_cimv2_jekyll_create_from()  {
  local lMSG_USAGE="$(luc_core_method_name_get) <RUBY_IMAGE_SID>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lTOOL="jekyll" 
  local lIMAGE_RUBY_SID="$1"
  local lCONTAINER_TEMPORARY_NAME=''
  local lLABEL_KEY_SHELL="${luc_EV_CIMAGEV2_LABEL_KEY_SHELL}"
  local lLABEL_KEY_OSNAME="${luc_EV_CIMAGEV2_LABEL_KEY_OSNAME}"
  local lLABEL_KEY_IMAGE_02="${luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_02}"
  local lLABEL_KEY_IMAGE_CURRENT="${luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_CURRENT}"
  local lLABEL_KEY_SERVER_PORT="${luc_EV_CIMAGEV2_LABEL_KEY_SERVER_PORT}"
  local lLABEL_VALUE_SERVER_PORT="4000"
  local lOS_USER_SUDO="${luc_EV_CIMAGEV2_OS_USER_SUDO}"
  local lFOLDER_LUC_HOST="${luc_EV_CIMAGEV2_LUC_CORE_HOME}"
  # local lFOLDER_LUC_CONTAINER="/home/${luc_EV_CIMAGEV2_OS_USER_SUDO}/wkspc/luc"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"
  local LUCSETUP="${lFOLDER_LUC_CONTAINER}/${luc_EV_CIMAGEV2_LUC_SRC_RELPATH}"  

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | podman is installed" && return 1
  # info
  luc_core_echo "purp" "use $lCIM_TOOL to create a $lTOOL image from a base os image" 

  # checkorexit args are provided
  [ -z "$lIMAGE_RUBY_SID"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  lECHOVAL=$(luc_cimv2_check_exists --image  $lIMAGE_RUBY_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # getorexit image NAME
  lECHOVAL=$(luc_cimv2_property_get --image  ${lIMAGE_RUBY_SID} NAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_RUBY_SNAME="${lECHOVAL/linux/}"

  # getorexit image FULLNAME
  lECHOVAL=$(luc_cimv2_property_get --image  ${lIMAGE_RUBY_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_RUBY_FULLNAME="$lECHOVAL"

  # getorexit image TAG
  lECHOVAL=$(luc_cimv2_property_get --image  ${lIMAGE_RUBY_SID} TAG); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_RUBY_TAG="$lECHOVAL"

  # getorexit image OSNAME
  lECHOVAL=$(luc_cimv2_property_get --image  ${lIMAGE_RUBY_SID} OS:NAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_RUBY_OSNAME="$lECHOVAL"

  # define image fullname
  lIMAGE_TOOL_FULLNAME="dev/$lTOOL:${lIMAGE_RUBY_OSNAME}"

  # define root container temporary name
  lCONTAINER_TEMPORARY_NAME="temp-$(luc_core_id_get 5)"

  # define LABELs, ENVARs, VOLUME, PORT
  #
  lOPTION_ENVAR="LUCSETUP=$LUCSETUP"
  lOPT_ENVAR=""; for ITEM in $lOPTION_ENVAR; do lOPT_ENVAR="$lOPT_ENVAR --change ENV=$ITEM"; done
  #
  # lOPTION_LABEL="--label ${lLABEL_KEY_IMAGE_SRC}=${lIMAGE_GOLDEN_FULLNAME} --label ${lLABEL_KEY_IMAGE_CURRENT}=${lIMAGE_TOOL_NAMEANDTAG}"
  lOPTION_LABEL=" 
    ${lLABEL_KEY_IMAGE_02}=${lIMAGE_RUBY_FULLNAME}
    ${lLABEL_KEY_IMAGE_CURRENT}=${lIMAGE_TOOL_FULLNAME}
    ${lLABEL_KEY_SERVER_PORT}=${lLABEL_VALUE_SERVER_PORT}
  "
  lOPT_LABEL=""; for ITEM in $lOPTION_LABEL; do lOPT_LABEL="$lOPT_LABEL -c LABEL=$ITEM"; done
  #
  lOPT_PORT="-c EXPOSE=${lLABEL_VALUE_SERVER_PORT}"
  #
  lOPTION_VOLUME="$lFOLDER_LUC_HOST:$lFOLDER_LUC_CONTAINER:ro"
  lOPT_VOLUME=""; for ITEM in $lOPTION_VOLUME; do lOPT_VOLUME="$lOPT_VOLUME -v $ITEM"; done

  # info
  luc_core_echo "info" "image root (src) : $lIMAGE_RUBY_FULLNAME ($lIMAGE_RUBY_SID)"
  luc_core_echo "info" "image base (dst) : $lIMAGE_TOOL_FULLNAME"
  luc_core_echo "info" "envar      : $lOPT_ENVAR"
  luc_core_echo "info" "volume     : $lOPT_VOLUME"
  luc_core_echo "info" "label      : $lOPT_LABEL"
  
  # create the running container - VOLUMEs
  luc_cimv2_container_create $lCONTAINER_TEMPORARY_NAME $lIMAGE_RUBY_SID $lOPT_VOLUME --env LUCSETUP=$LUCSETUP ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && return 1
  
  # getorexit container id
  lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.ID}} ${lCONTAINER_TEMPORARY_NAME})
  lCONTAINER_TEMPORARY_SID="${lCONTAINER_TEMPORARY_ID:0:5}"
  
  # provision container - os:upgrade, os:user 
  luc_core_echo "step" "provision container ${lCONTAINER_TEMPORARY_NAME} (${lCONTAINER_TEMPORARY_SID})"
  ## CLI
  lCLI=". $LUCSETUP ; luc_core_os_user_group_update lisa root"
  luc_core_echo "info" "cli > $lCLI"
  lECHOVAL=$(luc_cimv2_container_cli_play ${lCONTAINER_TEMPORARY_SID} "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  ## CLI
  lCLI=". $LUCSETUP ; luc_jekyll_install"
  luc_core_echo "info" "cli > $lCLI"
  lECHOVAL=$(luc_cimv2_container_cli_play ${lCONTAINER_TEMPORARY_SID} "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # info
  luc_core_echo "step" "pause the container"
  # pause the container
  lECHOVAL=$($lCIM_TOOL container pause $lCONTAINER_TEMPORARY_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  
  # info
  luc_core_echo "step" "commit the container to the image $lIMAGE_TOOL_FULLNAME"
  # configure image before commit - ENVARs, LABELs, PORT
  lECHOVAL=$($lCIM_TOOL commit --quiet $lOPT_ENVAR $lOPT_PORT $lOPT_LABEL $lCONTAINER_TEMPORARY_NAME $lIMAGE_TOOL_FULLNAME) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # getorexit image id
  lIMAGE_RUBY_ID=$($lCIM_TOOL inspect --type image --format {{.ID}} ${lIMAGE_TOOL_FULLNAME})
  lIMAGE_RUBY_SID="${lIMAGE_RUBY_ID:0:5}"

  # info
  luc_core_echo "step" "clean temporary containers and images"
  # 
  luc_cimv2_delete --container --temp
  luc_cimv2_delete --image     --dangling

  # info
  luc_core_echo "done" "created image $lIMAGE_TOOL_FULLNAME ($lIMAGE_RUBY_SID) from container $lCONTAINER_TEMPORARY_NAME ($lCONTAINER_TEMPORARY_SID)"
  return 0
}

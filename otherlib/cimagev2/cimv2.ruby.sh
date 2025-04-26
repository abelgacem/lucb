# purpose: create a container from an image
# args: <BASE_IMAGE_SID>
luc_cimv2_ruby_create_from()  {
  local lMSG_USAGE="$(luc_core_method_name_get) <BASE_IMAGE_SID>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lTOOL="ruby" 
  local lIMAGE_BASE_SID="$1"
  local lCONTAINER_TEMPORARY_NAME=''
  local lLABEL_KEY_SHELL="${luc_EV_CIMAGEV2_LABEL_KEY_SHELL}"
  local lLABEL_KEY_OSNAME="${luc_EV_CIMAGEV2_LABEL_KEY_OSNAME}"
  local lLABEL_KEY_IMAGE_01="${luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_01}"
  local lLABEL_KEY_IMAGE_CURRENT="${luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_CURRENT}"
  local lOS_USER_SUDO="${luc_EV_CIMAGEV2_OS_USER_SUDO}"
  local lFOLDER_LUC_HOST="${luc_EV_CIMAGEV2_LUC_CORE_HOME}"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | podman is installed" && return 1
  # info
  luc_core_echo "purp" "use $lCIM_TOOL to create a $lTOOL image from a base os image" 

  # checkorexit args are provided
  [ -z "$lIMAGE_BASE_SID"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  lECHOVAL=$(luc_cimv2_check_exists --image  $lIMAGE_BASE_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # getorexit image NAME
  lECHOVAL=$(luc_cimv2_property_get --image  ${lIMAGE_BASE_SID} NAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_BASE_SNAME="${lECHOVAL/linux/}"

  # getorexit image FULLNAME
  lECHOVAL=$(luc_cimv2_property_get --image  ${lIMAGE_BASE_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_BASE_FULLNAME="$lECHOVAL"

  # getorexit image TAG
  lECHOVAL=$(luc_cimv2_property_get --image  ${lIMAGE_BASE_SID} TAG); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_BASE_TAG="$lECHOVAL"

  # getorexit image OSNAME
  lECHOVAL=$(luc_cimv2_property_get --image  ${lIMAGE_BASE_SID} OS:NAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_BASE_OSNAME="$lECHOVAL"

  # getorexit image ENV:PATH
  lECHOVAL=$(luc_cimv2_property_get --image  ${lIMAGE_BASE_SID} ENVAR:PATH); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_BASE_ENVAR_PATH="$lECHOVAL"
  

  # define image fullname
  lIMAGE_TOOL_FULLNAME="dev/$lTOOL:${lIMAGE_BASE_OSNAME}"

  # define root container temporary name
  lCONTAINER_TEMPORARY_NAME="temp-$(luc_core_id_get 5)"

  # define LABELs, ENVARs, VOLUME, PORT
  #
  lOPTION_ENVAR="GEM_HOME=/home/${lOS_USER_SUDO}/wkspc/rubygems PATH=\\\$GEM_HOME/bin:$lIMAGE_BASE_ENVAR_PATH"
  lOPT_ENVAR=""; for ITEM in $lOPTION_ENVAR; do lOPT_ENVAR="$lOPT_ENVAR --change ENV=$ITEM"; done
  #
  lOPTION_LABEL=" 
    ${lLABEL_KEY_IMAGE_01}=${lIMAGE_BASE_FULLNAME}
    ${lLABEL_KEY_IMAGE_CURRENT}=${lIMAGE_TOOL_FULLNAME}
  "
  lOPT_LABEL=""; for ITEM in $lOPTION_LABEL; do lOPT_LABEL="$lOPT_LABEL --change LABEL=$ITEM"; done
  #  
  lOPTION_VOLUME="$lFOLDER_LUC_HOST:$lFOLDER_LUC_CONTAINER:ro"
  lOPT_VOLUME=""; for ITEM in $lOPTION_VOLUME; do lOPT_VOLUME="$lOPT_VOLUME --volume $ITEM"; done

  # info
  luc_core_echo "info" "image root (src) : $lIMAGE_BASE_FULLNAME ($lIMAGE_BASE_SID)"
  luc_core_echo "info" "image base (dst) : $lIMAGE_TOOL_FULLNAME"
  luc_core_echo "info" "envar      : $lOPT_ENVAR"
  luc_core_echo "info" "volume     : $lOPT_VOLUME"
  luc_core_echo "info" "label      : $lOPT_LABEL"
  luc_core_echo "info" "image path : $lIMAGE_BASE_ENVAR_PATH"
  
  # create the running container - VOLUMEs
  luc_cimv2_container_create $lCONTAINER_TEMPORARY_NAME $lIMAGE_BASE_SID $lOPT_VOLUME ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && return 1
  
  # getorexit container id
  lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.ID}} ${lCONTAINER_TEMPORARY_NAME})
  lCONTAINER_TEMPORARY_SID="${lCONTAINER_TEMPORARY_ID:0:5}"
  
  # provision container - os:upgrade, os:user 
  # note: $LUCSETUP is defined inside the container
  luc_core_echo "step" "provision container ${lCONTAINER_TEMPORARY_NAME} (${lCONTAINER_TEMPORARY_SID})"
  ## CLI
  lCLI=". \$LUCSETUP ; luc_ruby_install"
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
  # configure image before commit - ENVARs, LABELs
  lECHOVAL=$($lCIM_TOOL commit --quiet $lOPT_ENVAR $lOPT_LABEL $lCONTAINER_TEMPORARY_NAME $lIMAGE_TOOL_FULLNAME) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # getorexit image id
  lIMAGE_BASE_ID=$($lCIM_TOOL inspect --type image --format {{.ID}} ${lIMAGE_TOOL_FULLNAME})
  lIMAGE_BASE_SID="${lIMAGE_BASE_ID:0:5}"

  # info
  luc_core_echo "step" "clean temporary containers and images"
  # 
  luc_cimv2_delete --container --temp
  luc_cimv2_delete --image     --dangling

  # info
  luc_core_echo "done" "created image $lIMAGE_TOOL_FULLNAME ($lIMAGE_BASE_SID) from container $lCONTAINER_TEMPORARY_NAME ($lCONTAINER_TEMPORARY_SID)"
  return 0
}

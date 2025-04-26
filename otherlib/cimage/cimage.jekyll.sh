# shortcut
luc_cimage_create_jekyll_from() { luc_cimage_jekyll_create_from "$@"; }
luc_cimage_create_all_jekyll()  { luc_cimage_jekyll_create_all "$@"; }

# Purpose: create a ruby image from a golden image
# depenencies
# args <lIMAGE_RUBY_SID>
luc_cimage_jekyll_create_from()  {
  # define var
  local lTOOL_NAME="jekyll"
  local lIMAGE_RUBY_SID="$1"
  local lIMAGE_TOOL_NAMEANDTAG=''
  local lCONTAINER_TEMPORARY_NAME=''
  local lFOLDER_LUC_HOST="${luc_EV_CIMAGE_LUC_CORE_HOME}"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"
  local lFILE_LUC_BOOT="${luc_EV_CIMAGE_LUC_SRC_RELPATH}"
  local LUCSETUP="${lFOLDER_LUC_CONTAINER}/${lFILE_LUC_BOOT}"
  local lLABEL_KEY_IMAGE_SRC="mx.image.src.02"
  local lLABEL_KEY_IMAGE_CURRENT="${luc_EV_CIMAGE_LABEL_KEY_IMAGE_CURRENT}"
  local lLABEL_KEY_SERVER_PORT="${luc_EV_CIMAGE_LABEL_KEY_SERVER_PORT}"
  local lLABEL_VALUE_SERVER_PORT="4000"
  local lUSAGE_MSG="$(luc_core_method_name_get) <lIMAGE_RUBY_SID>"
  # info
  luc_core_echo "purp" "create a $lTOOL_NAMEimage from a ruby image"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1

  # checkorexit args are provided
  [ -z "$lIMAGE_RUBY_SID" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12" 
    return 1
  }

  # checkorexit image exists
  lECHOVAL=$(luc_cim_id_get --image  ${lIMAGE_RUBY_SID}); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1
  
  # getorexit image FULLNAME
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_RUBY_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_RUBY_FULLNAME="$lECHOVAL"

  # getorexit image OSNAME
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_RUBY_SID} OS:NAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_RUBY_OSNAME="$lECHOVAL"

  # getorexit image NAME
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_RUBY_SID} NAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_RUBY_NAME="$lECHOVAL"

  # define tool image fullname
  lIMAGE_TOOL_NAMEANDTAG="dev/$lTOOL_NAME${lIMAGE_RUBY_OSNAME}"

  # define container temporary name
  lCONTAINER_TEMPORARY_NAME="temp-$(luc_core_id_get 5)"

  # checkorexit file exits
  lOPTION_LABEL="
    --label ${lLABEL_KEY_IMAGE_SRC}=${lIMAGE_RUBY_FULLNAME}
    --label ${lLABEL_KEY_IMAGE_CURRENT}=${lIMAGE_TOOL_NAMEANDTAG}
    --label ${lLABEL_KEY_SERVER_PORT}=${lLABEL_VALUE_SERVER_PORT}
  "
  lOPTION_PORT="${lLABEL_VALUE_SERVER_PORT}"
  lOPTION_VOLUME="-v ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}:ro"
  luc_core_echo "chec" "folder ${lFOLDER_LUC_HOST} exits"
  [ ! -f "${lFOLDER_LUC_HOST}/${lFILE_LUC_BOOT}" ] && luc_core_echo "warn" "folder/file that need to be mounted in container does not exists : ${lFOLDER_LUC_HOST}/${lFILE_LUC_BOOT}" && return 1

  [ "$lCIM_TOOL" == "docker" ]  && {
    lFIELD_CONTAINERID='ID'
    lOPTION_LABEL_AT_CREATE="${lOPTION_LABEL}"
    lOPTION_PORT_AT_CREATE="--expose ${lOPTION_PORT}"
    lOPTION_VOLUME_AT_CREATE="${lOPTION_VOLUME}"
  }
  [ "$lCIM_TOOL" == "buildah" ] && {
    lFIELD_CONTAINERID='ContainerID'
    lOPTION_LABEL_AT_CREATE=''
    lOPTION_PORT_AT_CREATE=""
    lOPTION_VOLUME_AT_CREATE="${lOPTION_VOLUME}"
  }
  
  # info
  luc_core_echo "step" "create temporary container ${lCONTAINER_TEMPORARY_NAME}"
  luc_core_echo "info" "conf > ruby image   : ${lIMAGE_RUBY_FULLNAME}. Sid : ${lIMAGE_RUBY_SID}."
  luc_core_echo "info" "conf > $lTOOL_NAMEimage  : ${lIMAGE_TOOL_NAMEANDTAG}"
  luc_core_echo "info" "conf > mounted volume : ${lFOLDER_LUC_HOST}"
  luc_core_echo "info" "conf > expose  port   : ${lOPTION_VOLUME_AT_CREATE}"

  # createorexit container if not exist with ENVAR
  lECHOVAL=$(luc_cim_container_create ${lCONTAINER_TEMPORARY_NAME} ${lIMAGE_RUBY_SID} \
    ${lOPTION_VOLUME_AT_CREATE} \
    ${lOPTION_LABEL_AT_CREATE}  \
    ${lOPTION_PORT_AT_CREATE}   \
  ); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # checkorexit container exits
  luc_core_echo "chec" "temporary container ${lCONTAINER_TEMPORARY_NAME} is created"
  lECHOVAL=$(luc_cim_container_check_exists "${lCONTAINER_TEMPORARY_NAME}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # getorexit container id
  lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.${lFIELD_CONTAINERID}}} ${lCONTAINER_TEMPORARY_NAME})
  lCONTAINER_TEMPORARY_ID="${lCONTAINER_TEMPORARY_ID:0:5}"

  # ##### debug #####
  # luc_core_debug;
  # luc_cim_container_enter ${lCONTAINER_TEMPORARY_ID};
  # return 5
  # ##### debug #####

  # When BUILDAH configure LABELS, ENVS
  [ "$lCIM_TOOL" == "buildah" ] && {
    luc_core_echo "step" "configure LABELS, ENVVARS into $lCIM_TOOL container"
    buildah config ${lOPTION_LABEL} ${lCONTAINER_TEMPORARY_NAME}
    buildah config --port ${lOPTION_PORT} ${lCONTAINER_TEMPORARY_NAME}
  }
  
  # play CLI in container
  luc_core_echo "step" "play CLI in container > ${lCONTAINER_TEMPORARY_NAME} (${lCONTAINER_TEMPORARY_ID})"
  ## CLI - root in container == user that create container on host - workaround when mounting FS
  lCLI=". $LUCSETUP; luc_core_os_user_group_update lisa root"
  luc_core_echo "info" "conf > CLI > $lCLI"
  lECHOVAL=$(luc_cim_container_cli_play ${lCONTAINER_TEMPORARY_ID} "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  ## CLI
  lCLI=". $LUCSETUP; luc_jekyll_install"
  luc_core_echo "info" "conf > CLI > $lCLI"
  lECHOVAL=$(luc_cim_container_cli_play ${lCONTAINER_TEMPORARY_ID} "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
    
  # get container SID
  lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.${lFIELD_CONTAINERID}}} ${lCONTAINER_TEMPORARY_NAME})
  lCONTAINER_TEMPORARY_ID="${lCONTAINER_TEMPORARY_ID:0:5}"

  # create final golden image
  luc_core_echo "step" "create golden image (${lIMAGE_RUBY_NAMEANDTAG}) from container ${lCONTAINER_TEMPORARY_NAME} ($lCONTAINER_TEMPORARY_ID)"
  luc_cim_image_create ${lIMAGE_TOOL_NAMEANDTAG} ${lCONTAINER_TEMPORARY_ID}
  
  # clean temporary images and containers
  luc_core_echo "step" "clean temporary containers and images"
  luc_cim_container_delete --temp
  luc_cim_image_delete     --dangling

} # end function
  
# Purpose: create all ruby image
# Note: change in container image name => change the criteria
# args NONE
luc_cimage_jekyll_create_all()  {
  local lCRITERIA="ruby"
  luc_core_echo "purp" "create all ruby images"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1
  
  # If one match select it as a src image
  lIMAGE_SRC_LIST=$($lCIM_TOOL images | awk -v pattern="$lCRITERIA" '$1 ~ pattern {print $3}')

  # ### debug ###
  # luc_core_echo "debu" "lCRITERIA=$lCRITERIA"
  # luc_core_echo "debu" "lIMAGE_SRC_LIST = $($lCIM_TOOL images | awk -v pattern=$lCRITERIA '$1 ~ pattern {print $1}')"
  # return 5
  # ### debug ###

  # checkorexit list not empty
  [ -z "$lIMAGE_SRC_LIST" ] && luc_core_echo "warn" "No golden images found" && return 1
  
  for IMG_SRC_ID in ${lIMAGE_SRC_LIST}; do
    luc_cimage_jekyll_create_from $IMG_SRC_ID
  done

  return 0
}

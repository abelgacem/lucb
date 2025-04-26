# shortcut
luc_cimage_create_ruby_from() { luc_cimage_ruby_create_from "$@"; }
luc_cimage_create_all_ruby()  { luc_cimage_ruby_create_all "$@"; }

# Purpose: create a ruby image from a golden image
# Note: change in container image name => change the criteria
# args <lIMAGE_GOLDEN_SID>
luc_cimage_ruby_create_from()  {
  # define var
  local lTOOL_NAME="ruby"
  local lIMAGE_GOLDEN_SID="$1"
  local lIMAGE_TOOL_NAMEANDTAG=''
  local lCONTAINER_TEMPORARY_NAME=''
  local lFOLDER_LUC_HOST="${luc_EV_CIMAGE_LUC_CORE_HOME}"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"
  local lFILE_LUC_BOOT="${luc_EV_CIMAGE_LUC_SRC_RELPATH}"
  local LUCSETUP="${lFOLDER_LUC_CONTAINER}/${lFILE_LUC_BOOT}"
  local lOS_USER_SUDO="${luc_EV_CIMAGE_OS_USER_SUDO}"
  local lLABEL_KEY_IMAGE_SRC="mx.image.src.01"
  local lLABEL_KEY_IMAGE_CURRENT="${luc_EV_CIMAGE_LABEL_KEY_IMAGE_CURRENT}"
  local lUSAGE_MSG="$(luc_core_method_name_get) <lIMAGE_GOLDEN_SID>"
  # info
  luc_core_echo "purp" "create a $lTOOL_NAMEimage from a golden image"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1

  # checkorexit args are provided
  [ -z "$lIMAGE_GOLDEN_SID" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12" 
    return 1
  }

  # checkorexit image exists
  lECHOVAL=$(luc_cim_id_get --image  ${lIMAGE_GOLDEN_SID}); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1
  
  # getorexit image FULLNAME
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_GOLDEN_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_GOLDEN_FULLNAME="${lECHOVAL/localhost\//}"

  # getorexit image OSNAME
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_GOLDEN_SID} "OS:NAME"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_GOLDEN_OSNAME="$lECHOVAL"

  # define tool image fullname
  lIMAGE_TOOL_NAMEANDTAG="dev/$lTOOL_NAME${lIMAGE_GOLDEN_OSNAME}"

  # checkorexit file exits
  lOPTION_LABEL="--label ${lLABEL_KEY_IMAGE_SRC}=${lIMAGE_GOLDEN_FULLNAME} --label ${lLABEL_KEY_IMAGE_CURRENT}=${lIMAGE_TOOL_NAMEANDTAG}"
  lOPTION_ENVAR="--env GEM_HOME=/home/${lOS_USER_SUDO}/wkspc/rubygems --env PATH=\$GEM_HOME/bin:\$PATH"
  lOPTION_VOLUME="-v ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}:ro"
  luc_core_echo "chec" "folder ${lFOLDER_LUC_HOST} exits"
  [ ! -f "${lFOLDER_LUC_HOST}/${lFILE_LUC_BOOT}" ] && luc_core_echo "warn" "folder/file that need to be mounted in container does not exists : ${lFOLDER_LUC_HOST}/${lFILE_LUC_BOOT}" && return 1

  [ "$lCIM_TOOL" == "docker" ]  && {
    lFIELD_CONTAINERID='ID'
    lOPTION_LABEL_AT_CREATE="${lOPTION_LABEL}"
    lOPTION_ENVAR_AT_CREATE="${lOPTION_ENVAR}"
    lOPTION_VOLUME_AT_CREATE="${lOPTION_VOLUME}"
  }
  [ "$lCIM_TOOL" == "buildah" ] && {
    lFIELD_CONTAINERID='ContainerID'
    lOPTION_LABEL_AT_CREATE=''
    lOPTION_ENVAR_AT_CREATE=''
    lOPTION_VOLUME_AT_CREATE="${lOPTION_VOLUME}"
  }

  # createorexit temporary container with VOLUME, LABELS
  lCONTAINER_TEMPORARY_NAME="temp-$(luc_core_id_get 5)"
  luc_core_echo "step" "create temporary container ${lCONTAINER_TEMPORARY_NAME}"
  luc_core_echo "info" "conf > golden image : ${lIMAGE_GOLDEN_FULLNAME}. Sid : ${lIMAGE_GOLDEN_SID}."
  luc_core_echo "info" "conf > $lTOOL_NAMEimage   : ${lIMAGE_TOOL_NAMEANDTAG}"
  luc_core_echo "info" "conf > volume at build : ${lOPTION_VOLUME}"
  luc_core_echo "info" "conf > envar        : ${lOPTION_ENVAR}"
  luc_core_echo "info" "conf > label        : ${lOPTION_LABEL}"
  lECHOVAL=$(luc_cim_container_create ${lCONTAINER_TEMPORARY_NAME} ${lIMAGE_GOLDEN_SID} \
    ${lOPTION_VOLUME_AT_CREATE} \
    ${lOPTION_LABEL_AT_CREATE} \
    ${lOPTION_ENVAR_AT_CREATE} \
  ); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # checkorexit container exits
  luc_core_echo "chec" "temporary container ${lCONTAINER_TEMPORARY_NAME} is created"
  lECHOVAL=$(luc_cim_container_check_exists "${lCONTAINER_TEMPORARY_NAME}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # getorexit container id
  lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.${lFIELD_CONTAINERID}}} ${lCONTAINER_TEMPORARY_NAME})
  lCONTAINER_TEMPORARY_ID="${lCONTAINER_TEMPORARY_ID:0:5}"

  # When BUILDAH configure LABELS, ENVS
  [ "$lCIM_TOOL" == "buildah" ] && {
    luc_core_echo "step" "configure LABELS, ENVVARS into $lCIM_TOOL container"
    buildah config ${lOPTION_LABEL} ${lCONTAINER_TEMPORARY_NAME}
    buildah config ${lOPTION_ENVAR} ${lCONTAINER_TEMPORARY_NAME}
  }

  # play CLI in container
  luc_core_echo "step" "play CLI in container > ${lCONTAINER_TEMPORARY_NAME} (${lCONTAINER_TEMPORARY_ID})"
  ## CLI
  lCLI=". $LUCSETUP; luc_ruby_install"
  luc_core_echo "info" "conf > CLI > $lCLI"
  lECHOVAL=$(luc_cim_container_cli_play ${lCONTAINER_TEMPORARY_ID} "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
    
  # get container SID
  lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.${lFIELD_CONTAINERID}}} ${lCONTAINER_TEMPORARY_NAME})
  lCONTAINER_TEMPORARY_ID="${lCONTAINER_TEMPORARY_ID:0:5}"

  # create final golden image
  luc_core_echo "step" "create golden image (${lIMAGE_TOOL_NAMEANDTAG}) from container ${lCONTAINER_TEMPORARY_NAME} ($lCONTAINER_TEMPORARY_ID)"
  luc_cim_image_create ${lIMAGE_TOOL_NAMEANDTAG} ${lCONTAINER_TEMPORARY_ID}
  
  # clean temporary images and containers
  luc_core_echo "step" "clean temporary containers and images"
  luc_cim_container_delete --temp
  luc_cim_image_delete     --dangling

} # end function
  
# Purpose: create all ruby image
# Note: change in container image name => change the criteria
# args NONE
luc_cimage_ruby_create_all()  {
  local lCRITERIA="os/${luc_EV_LUC_CORE_OS_MANAGED//|/|os/}"
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
    luc_cimage_ruby_create_from $IMG_SRC_ID
  done

  return 0
}

# Purpose: test ruby is installed
# Note: change in container image name => change the criteria
# args NONE
luc_cimage_ruby_test()  {
  local lCRITERIA="dev/ruby"
  luc_core_echo "purp" "test all ruby images"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1
  # lookup field
  [ "$lCIM_TOOL" == "docker" ]  && {
    lFIELD_CONTAINERID='ID'
  }
  [ "$lCIM_TOOL" == "buildah" ] && {
    lFIELD_CONTAINERID='ContainerID'
  }

  # select all images that match the pattern
  lIMAGE_SRC_LIST=$($lCIM_TOOL images | awk -v pattern="$lCRITERIA" '$1 ~ pattern {print $3}')

  # ### debug ###
  # luc_core_echo "debu" "lCRITERIA=$lCRITERIA"
  # luc_core_echo "debu" "lIMAGE_SRC_LIST = $($lCIM_TOOL images | awk -v pattern=$lCRITERIA '$1 ~ pattern {print $1}')"
  # return 5
  # ### debug ###

  # checkorexit list not empty
  [ -z "$lIMAGE_SRC_LIST" ] && luc_core_echo "warn" "No golden images found" && return 1

  # TODO:
  for IMG_SRC_ID in ${lIMAGE_SRC_LIST}; do
    [ "buildah" == "$lCIM_TOOL" ] && {

      # getorexit image FULLNAME
      lECHOVAL=$(luc_cim_property_get --image  $IMG_SRC_IDFULLNAME); lRETVAL=$?  
      [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_FULLNAME="$lECHOVAL"

      # getorexit image label
      lECHOVAL=$(luc_cim_property_get --image  $IMG_SRC_IDlabel); lRETVAL=$?  
      [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_LABEL="$lECHOVAL"

      # getorexit image env
      lECHOVAL=$(luc_cim_property_get --image  $IMG_SRC_IDenvar); lRETVAL=$?  
      [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ENVAR="$lECHOVAL"

      lCONTAINER_TEMPORARY_NAME="$($lCIM_TOOL from $IMG_SRC_ID)"
      lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.${lFIELD_CONTAINERID}}} ${lCONTAINER_TEMPORARY_NAME})
      lCONTAINER_TEMPORARY_SID="${lCONTAINER_TEMPORARY_ID:0:5}"

      # ### debug
      # luc_core_echo "debu" "lCONTAINER_TEMPORARY_NAME=$lCONTAINER_TEMPORARY_NAME"
      # luc_core_echo "debu" "lCONTAINER_TEMPORARY_SID=$lCONTAINER_TEMPORARY_SID"
      # return 5
      # ### debug
      # play cli
      luc_core_echo "info" "image > $lIMAGE_FULLNAME"
      luc_cim_container_cli_play $lCONTAINER_TEMPORARY_ID "ruby -v && gem -v"
      echo "gem install path > " 
      luc_cim_container_cli_play $lCONTAINER_TEMPORARY_ID "gem environment gemdir" | grep -v 'purp'
      echo "gem lookup gems > " 
      luc_cim_container_cli_play $lCONTAINER_TEMPORARY_ID "gem environment gempath" | grep -v 'purp'
      # display info
      echo "label = $(echo "$lIMAGE_LABEL" | jq -r)"
      echo "envar = $(echo "$lIMAGE_ENVAR" | jq -r)"

      # clean 
      $lCIM_TOOL rm $lCONTAINER_TEMPORARY_ID 1> /dev/null
    }
    [ "docker"  == "$lCIM_TOOL" ] && luc_core_echo "debu" "TODO"
  done

  return 0
}

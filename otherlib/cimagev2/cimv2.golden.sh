# purpose: create a container from an image
# args: <ROOT_IMAGE_SID>
luc_cimv2_golden_create_from()  {
  local lMSG_USAGE="$(luc_core_method_name_get) <ROOT_IMAGE_SID>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lIMAGE_ROOT_SID="$1"
  local lCONTAINER_TEMPORARY_NAME=''
  local lLABEL_KEY_SHELL="${luc_EV_CIMAGEV2_LABEL_KEY_SHELL}"
  local lLABEL_KEY_OSNAME="${luc_EV_CIMAGEV2_LABEL_KEY_OSNAME}"
  local lLABEL_KEY_IMAGE_00="${luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_00}"
  local lLABEL_KEY_IMAGE_CURRENT="${luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_CURRENT}"
  local lOS_USER_SUDO="${luc_EV_CIMAGEV2_OS_USER_SUDO}"
  local lFOLDER_LUC_HOST="${luc_EV_CIMAGEV2_LUC_CORE_HOME}"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"
  local LUCSETUP="${lFOLDER_LUC_CONTAINER}/${luc_EV_CIMAGEV2_LUC_SRC_RELPATH}"  

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed podman && lCIM_TOOL="podman"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker | podman is installed" && return 1
  # info
  luc_core_echo "purp" "use $lCIM_TOOL to create a base os image from a root os image" 

  # checkorexit args are provided
  [ -z "$lIMAGE_ROOT_SID"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  lECHOVAL=$(luc_cimv2_check_exists --image  $lIMAGE_ROOT_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # getorexit image NAME
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_ROOT_SID} NAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ROOT_SNAME="${lECHOVAL/linux/}"

  # getorexit image FULLNAME
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_ROOT_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ROOT_FULLNAME="$lECHOVAL"

  # getorexit image TAG
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_ROOT_SID} TAG); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ROOT_TAG="$lECHOVAL"

  # getorexit image SHELL
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_ROOT_SID} CMD); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ROOT_SHELL="$lECHOVAL"

  # define image fullname
  lIMAGE_BASE_FULLNAME="dev/os/${lIMAGE_ROOT_SNAME}:${lIMAGE_ROOT_TAG}"
  
  # define root container temporary name
  lCONTAINER_TEMPORARY_NAME="temp-$(luc_core_id_get 5)"

  # define LABELs, ENVARs, VOLUME, PORT
  #
  lOPTION_ENVAR="LUCSETUP=$LUCSETUP OS_USER_SUDO=$lOS_USER_SUDO"
  lOPT_ENVAR=""; for ITEM in $lOPTION_ENVAR; do lOPT_ENVAR="$lOPT_ENVAR --change ENV=$ITEM"; done
  #
  lOPTION_LABEL=" 
    ${lLABEL_KEY_IMAGE_00}=${lIMAGE_ROOT_FULLNAME}
    ${lLABEL_KEY_IMAGE_CURRENT}=${lIMAGE_BASE_FULLNAME}
    ${lLABEL_KEY_OSNAME}=${lIMAGE_ROOT_SNAME}
    ${lLABEL_KEY_SHELL}=${lIMAGE_ROOT_SHELL}
  "
  lOPT_LABEL=""; for ITEM in $lOPTION_LABEL; do lOPT_LABEL="$lOPT_LABEL --change LABEL=$ITEM"; done
  #
  lOPT_USER="--change USER=$lOS_USER_SUDO"
  #  
  lOPTION_VOLUME="$lFOLDER_LUC_HOST:$lFOLDER_LUC_CONTAINER:ro"
  lOPT_VOLUME=""; for ITEM in $lOPTION_VOLUME; do lOPT_VOLUME="$lOPT_VOLUME --volume $ITEM"; done
  #
  lOPT_WKDIR="--change WORKDIR=/home/$lOS_USER_SUDO"
  # docker commit --change='CMD ["apachectl", "-DFOREGROUND"]' -c "EXPOSE 80"
  
  # info
  luc_core_echo "info" "image root (src) : $lIMAGE_ROOT_FULLNAME ($lIMAGE_ROOT_SID)"
  luc_core_echo "info" "image base (dst) : $lIMAGE_BASE_FULLNAME"
  luc_core_echo "info" "image shell: $lIMAGE_ROOT_SHELL"
  luc_core_echo "info" "envar      : $lOPTION_ENVAR"
  luc_core_echo "info" "volume     : $lOPT_VOLUME"

  # create the running container - VOLUMEs, ENVARs
  luc_cimv2_container_create $lCONTAINER_TEMPORARY_NAME $lIMAGE_ROOT_SID $lOPT_VOLUME --env LUCSETUP=$LUCSETUP ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && return 1
  
  # getorexit container id
  lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.ID}} ${lCONTAINER_TEMPORARY_NAME})
  lCONTAINER_TEMPORARY_SID="${lCONTAINER_TEMPORARY_ID:0:5}"
  
  # provision container - os:upgrade, os:user 
  luc_core_echo "step" "provision container ${lCONTAINER_TEMPORARY_NAME} (${lCONTAINER_TEMPORARY_SID})"
  ## CLI
  lCLI=". \$LUCSETUP ; luc_core_os_package_upgrade"
  luc_core_echo "info" "cli > $lCLI"
  lECHOVAL=$(luc_cimv2_container_cli_play ${lCONTAINER_TEMPORARY_SID} "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  ## CLI
  lCLI=". \$LUCSETUP ; luc_core_os_user_sudo_provision ${lOS_USER_SUDO}"
  luc_core_echo "info" "cli > $lCLI"
  lECHOVAL=$(luc_cimv2_container_cli_play ${lCONTAINER_TEMPORARY_SID} "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # info
  luc_core_echo "step" "pause the container"
  # pause the container
  lECHOVAL=$($lCIM_TOOL container pause $lCONTAINER_TEMPORARY_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  
  # info
  luc_core_echo "step" "commit the container to the image $lIMAGE_BASE_FULLNAME"
  luc_core_echo "info" "conf > user  : $lOPT_USER"
  luc_core_echo "info" "conf > wkdir : $lOPT_WKDIR"
  luc_core_echo "info" "conf > envar : $lOPT_ENVAR"
  luc_core_echo "info" "conf > label : $lOPT_LABEL"
  # configure image before commit - ENVARs, LABELs, USER, WKDIR
  lECHOVAL=$($lCIM_TOOL commit --quiet $lOPT_ENVAR $lOPT_LABEL $lOPT_USER $lOPT_WKDIR $lCONTAINER_TEMPORARY_NAME $lIMAGE_BASE_FULLNAME) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # getorexit image id
  lIMAGE_BASE_ID=$($lCIM_TOOL inspect --type image --format {{.ID}} ${lIMAGE_BASE_FULLNAME})
  lIMAGE_BASE_SID="${lIMAGE_BASE_ID:0:5}"

  # ################ debug
  # luc_core_echo "debu" "check label, user, env in container $lCONTAINER_TEMPORARY_SID"
  # luc_core_echo "debu" "check label, user, env in image     $lIMAGE_BASE_SID"
  # luc_core_debug; return 5
  # ################ debug

  # info
  luc_core_echo "step" "clean temporary containers and images"
  # 
  luc_cimv2_delete --container --temp
  luc_cimv2_delete --image     --dangling

  # info
  luc_core_echo "done" "created image $lIMAGE_BASE_FULLNAME ($lIMAGE_BASE_SID) from container $lCONTAINER_TEMPORARY_NAME ($lCONTAINER_TEMPORARY_SID)"
  return 0
}

# Purpose: create all golden image
# Note: change in container image name => change the criteria
# args NONE
luc_cimagev2_golden_create_all() {
  local lCRITERIA=${luc_EV_CIMAGE_OS_LIST}
  luc_core_echo "purp" "create all golden os images (ie. $lCRITERIA)"

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1
  
  # If one match select it as a src image
  lIMAGE_SRC_LIST=$($lCIM_TOOL images | awk -v pattern="$lCRITERIA" '$1 ~ pattern {print $3}')

  # ### debug ###
  # luc_core_echo "debu" "$($lCIM_TOOL images | awk -v pattern=$lCRITERIA '$1 ~ pattern {print $1}')"
  # return 5
  # ### debug ###

  # checkorexit list not empty
  [ -z "$lIMAGE_SRC_LIST" ] && luc_core_echo "warn" "No root images found" && return 1
  
  for IMG_SRC_ID in ${lIMAGE_SRC_LIST}; do
    luc_cimage_golden_create_from $IMG_SRC_ID
  done

  return 0
}

# Purpose: test ruby is installed
# Note: change in container image name => change the criteria
# args NONE
luc_cimagev2_golden_test()  {
  local lCRITERIA="os/${luc_EV_LUC_CORE_OS_MANAGED//|/|os/}"
  luc_core_echo "purp" "test all golden images"

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

  for IMG_SRC_ID in ${lIMAGE_SRC_LIST}; do

    # getorexit image FULLNAME
    lECHOVAL=$(luc_cim_property_get --image  $IMG_SRC_IDFULLNAME); lRETVAL=$?  
    [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_FULLNAME="$lECHOVAL"

    # getorexit image label
    lECHOVAL=$(luc_cim_property_get --image  $IMG_SRC_IDlabel); lRETVAL=$?  
    [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_LABEL="$lECHOVAL"

    # getorexit image env
    lECHOVAL=$(luc_cim_property_get --image  $IMG_SRC_IDenvar); lRETVAL=$?  
    [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ENVAR="$lECHOVAL"
 
    luc_core_echo "info" "image > $lIMAGE_FULLNAME"
    echo "label = $(echo "$lIMAGE_LABEL" | jq -r)"
    echo "envar = $(echo "$lIMAGE_ENVAR" | jq -r)"
    
  done

}
    #  --change "ENV ${lOPTION_ENVAR}" \
    #  --change "WORKDIR $lOPT_WKDIR \

# shortcut
luc_cimage_create_golden_from() { luc_cimage_golden_create_from "$@"; }
luc_cimage_create_all_golden()  { luc_cimage_golden_create_all "$@"; }

# define var accessible to the method when the script is sourced
# sOS_PACKAGE_LIST="tree jq"
# sOS_PACKAGE_LIST_alpine="doas"
# sOS_PACKAGE_LIST_rocky="sudo"
# sOS_PACKAGE_LIST_ubuntu="sudo"


# Description
# -----------
# - create a destination image from a source image
# - the source image is a base os image from the public registry
# - the destination image is an organization golden image
# 
# Note
# -----------
# - temporary containers are deleted
#
# Parameters
# ----------
# $1: IMAGE_SID
#
# Action
# ------
# 1. provision a container from the src image
# 2. mount folder (ie. luc) into the container (ie. /tmp/luc)
# 3. source file in mounted folder (ie. /tmp/luc/ci/source.sh)
# 4. update and upgrade os (ie. mmx_xxx)
# 5. provision container:os:user:lisa (ie. mmx_xxx)
# 6. set container:workingdir:lisa (ie. mmx_xxx)
# 7. install basic os package (ie. mmx_xxx)
# 8. define os varenv
# 9. add user into image

# Purpose: create a golden image from a base image
# depenencies
# - luc_EV_CIMAGE_LUC_CORE_HOME
# - luc_EV_CIMAGE_LUC_SRC_RELPATH
# args <lIMAGE_ROOT_SID>
luc_cimage_golden_create_from()  {
  luc_core_echo "purp" "create golden os image from base image"

  # define var
  local lIMAGE_ROOT_SID=$1
  local lIMAGE_ROOT_FULLNAME=''
  local lIMAGE_GOLDEN_NAMEANDTAG=''
  local lCONTAINER_TEMPORARY_NAME=''
  local lFOLDER_LUC_HOST="${luc_EV_CIMAGE_LUC_CORE_HOME}"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"
  local lFILE_LUC_BOOT="${luc_EV_CIMAGE_LUC_SRC_RELPATH}"
  local LUCSETUP="${lFOLDER_LUC_CONTAINER}/${lFILE_LUC_BOOT}"
  local lOS_USER_SUDO="${luc_EV_CIMAGE_OS_USER_SUDO}"
  local lUSAGE_MSG="$(luc_core_method_name_get) <lIMAGE_ROOT_SID>"
  local lLABEL_KEY_SHELL="${luc_EV_CIMAGE_LABEL_KEY_SHELL}"
  local lLABEL_KEY_OSNAME="${luc_EV_CIMAGE_LABEL_KEY_OSNAME}"
  local lLABEL_KEY_IMAGE_ROOT="${luc_EV_CIMAGE_LABEL_KEY_IMAGE_ROOT}"
  local lLABEL_KEY_IMAGE_CURRENT="${luc_EV_CIMAGE_LABEL_KEY_IMAGE_CURRENT}"
  
  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1

  # checkorexit args are provided
  [ -z "$lIMAGE_ROOT_SID" ]       ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12" 
    return 1
  }

  # checkorexit image exists
  lECHOVAL=$(luc_cim_id_get --image  ${lIMAGE_ROOT_SID}); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1
  
  # getorexit image FULLNAME
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_ROOT_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ROOT_FULLNAME="$lECHOVAL"

  # getorexit image NAME
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_ROOT_SID} NAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ROOT_SNAME="${lECHOVAL/linux/}"

  # getorexit image TAG
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_ROOT_SID} TAG); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ROOT_TAG="$lECHOVAL"

  # getorexit image SHELL
  lECHOVAL=$(luc_cim_property_get --image  ${lIMAGE_ROOT_SID} CMD); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_ROOT_SHELL="$lECHOVAL"

  # define golden image fullname
  lIMAGE_GOLDEN_NAMEANDTAG="dev/os/${lIMAGE_ROOT_SNAME}:${lIMAGE_ROOT_TAG}"
  
  # checkorexit file exits
  luc_core_echo "chec" "folder ${lFOLDER_LUC_HOST} exits"
  [ ! -f "${lFOLDER_LUC_HOST}/${lFILE_LUC_BOOT}" ] && luc_core_echo "warn" "folder/file that need to be mounted in container does not exists : ${lFOLDER_LUC_HOST}/${lFILE_LUC_BOOT}" && return 1

  # define ENVs, LABELs, WKDIR 
  lOPTION_LABEL="--label ${lLABEL_KEY_OSNAME}=${lIMAGE_ROOT_SNAME} \
                 --label ${lLABEL_KEY_SHELL}=${lIMAGE_ROOT_SHELL} \
                 --label ${lLABEL_KEY_IMAGE_CURRENT}=${lIMAGE_GOLDEN_NAMEANDTAG} \
                 --label ${lLABEL_KEY_IMAGE_ROOT}=${lIMAGE_ROOT_FULLNAME}"
  lOPTION_ENVAR="--env LUCSETUP=$LUCSETUP"
  lOPTION_WKDIR="/home/${lOS_USER_SUDO}"
  lOPTION_VOLUME="-v ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}:ro"
  [ "$lCIM_TOOL" == "docker" ]  && {
    lFIELD_CONTAINERID='ID'
    lOPTION_LABEL_AT_CREATE="${lOPTION_LABEL}"
    lOPTION_ENVAR_AT_CREATE="${lOPTION_ENVAR}"
    lOPTION_WKDIR_AT_CREATE="--workdir ${lOPTION_WKDIR}"
    lOPTION_VOLUME_AT_CREATE="${lOPTION_VOLUME}"
  }
  [ "$lCIM_TOOL" == "buildah" ] && {
    lFIELD_CONTAINERID='ContainerID'
    lOPTION_LABEL_AT_CREATE=""
    lOPTION_ENVAR_AT_CREATE=""
    lOPTION_WKDIR_AT_CREATE=""
    lOPTION_VOLUME_AT_CREATE="${lOPTION_VOLUME}"
  }

  # # TODO: find a way to map container:lisa:uid/gid:1001 to host:user:default:uid/gid:1000
  # # chown jekyll volume before mounting
  # luc_core_echo "todo" "step > workaround > chown folder to ${luc_EV_CONTAINER_OS_USER_SUDO} befor mounting: ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}"
  # chown -R ${luc_EV_CONTAINER_OS_USER_SUDO}:${luc_EV_CONTAINER_OS_USER_SUDO} ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}

  # createorexit temporary container with VOLUME, LABELS, ENVS, WKDIR
  lCONTAINER_TEMPORARY_NAME="temp-$(luc_core_id_get 5)"
  luc_core_echo "step" "create temporary container ${lCONTAINER_TEMPORARY_NAME}"
  luc_core_echo "info" "conf > root image   : ${lIMAGE_ROOT_FULLNAME}. Sid : ${lIMAGE_ROOT_SID}."
  luc_core_echo "info" "conf > golden image : ${lIMAGE_GOLDEN_NAMEANDTAG}"
  luc_core_echo "info" "conf > volume at build : ${lOPTION_VOLUME}"
  luc_core_echo "info" "conf > label        : ${lOPTION_LABEL}"
  luc_core_echo "info" "conf > envar        : ${lOPTION_ENVAR}"
  luc_core_echo "info" "conf > wkdir        : ${lOPTION_WKDIR}"
  lECHOVAL=$(luc_cim_container_create ${lCONTAINER_TEMPORARY_NAME} ${lIMAGE_ROOT_SID} \
    ${lOPTION_VOLUME_AT_CREATE} \
    ${lOPTION_LABEL_AT_CREATE}  \
    ${lOPTION_ENVAR_AT_CREATE}  \
    ${lOPTION_WKDIR_AT_CREATE}  \
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
  lCLI=". $LUCSETUP ; luc_core_os_package_upgrade"
  luc_core_echo "info" "conf > CLI > $lCLI"
  lECHOVAL=$(luc_cim_container_cli_play ${lCONTAINER_TEMPORARY_ID} "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  ## CLI
  lCLI=". $LUCSETUP ; luc_core_os_user_sudo_provision ${lOS_USER_SUDO}"
  luc_core_echo "info" "conf > CLI > $lCLI"
  lECHOVAL=$(luc_cim_container_cli_play ${lCONTAINER_TEMPORARY_ID} "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # When BUILDAH configure WKDIR, USER
  [ "$lCIM_TOOL" == "buildah" ] && {
    luc_core_echo "step" "configure WKDIR, USER into $lCIM_TOOL container"
    buildah config --workingdir ${lOPTION_WKDIR} ${lCONTAINER_TEMPORARY_NAME}
    buildah config --user       ${lOPTION_USER} ${lCONTAINER_TEMPORARY_NAME}
  }


  # configure USER (docker) - cannot be done before because user MUST exists
  luc_core_echo "step" "configure USER"
  lOPTION_USER="${lOS_USER_SUDO}"
  ## When DOCKER
  [ "$lCIM_TOOL" == "docker" ] && {
    # create temporary golden image from container
    $lCIM_TOOL commit --change="USER ${lOS_USER_SUDO}" ${lCONTAINER_TEMPORARY_ID} ${lIMAGE_GOLDEN_NAMEANDTAG}
    # create temporary container from temporary golden image
    lCONTAINER_TEMPORARY_NAME="temp-$(luc_core_id_get 5)"
    $lCIM_TOOL run -d --name ${lCONTAINER_TEMPORARY_NAME} --user ${lOPTION_USER} ${lIMAGE_GOLDEN_NAMEANDTAG}
    # get container SID
    lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.${lFIELD_CONTAINERID}}} ${lCONTAINER_TEMPORARY_NAME})
    lCONTAINER_TEMPORARY_ID="${lCONTAINER_TEMPORARY_ID:0:5}"
  }

  # get container SID
  lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.${lFIELD_CONTAINERID}}} ${lCONTAINER_TEMPORARY_NAME})
  lCONTAINER_TEMPORARY_ID="${lCONTAINER_TEMPORARY_ID:0:5}"

  # create final golden image
  luc_core_echo "step" "create golden image (${lIMAGE_GOLDEN_NAMEANDTAG}) from container ${lCONTAINER_TEMPORARY_NAME} ($lCONTAINER_TEMPORARY_ID)"
    lEHOVAL=$($lCIM_TOOL commit ${lCONTAINER_SID} ${lIMAGE_NAME} 2>&1); lRETVAL=$?

  luc_cim_image_create ${lIMAGE_GOLDEN_NAMEANDTAG} ${lCONTAINER_TEMPORARY_ID}
  
  # # TODO: find a way to map container:lisa:uid/gid:1001 to host:user:default:uid/gid:1000
  # # chown jekyll volume after mounting
  # luc_core_echo "todo" "step > workaround > chown folder back to $(id -u):$(id -u) after unmounting: ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}"
  # chown -R $(id -u):$(id -u) ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}

  # clean temporary images and containers
  luc_core_echo "step" "clean temporary containers and images"
  luc_cim_container_delete --temp
  luc_cim_image_delete     --dangling
}

# Purpose: create all golden image
# Note: change in container image name => change the criteria
# args NONE
luc_cimage_golden_create_all() {
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
luc_cimage_golden_test()  {
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

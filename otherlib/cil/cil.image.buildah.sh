# define var accessible to the method when the script is sourced
sOS_PACKAGE_LIST_ubuntu="buildah"
sOS_PACKAGE_LIST_rocky="buildah"
sOS_PACKAGE_LIST_alpine="buildah"


# documentation model cf. image.os
# args lIMAGE_SID
luc_cil_image_buildah_create ()  {
  local lAPP_NAME="buildah"
  luc_core_echo "purp" "create $lAPP_NAME image from os golden image"

  # define var
  local lIMAGE_SID=$1
  local lBUILDAH_PREFIX_CONT="${gslBUILDAH_PREFIX_CONT}"
  local lFOLDER_LUC_HOST="${mmx_EV_FOLDER_LUC}"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"
  local lRELPATHFILE_LUC_TO_SOURCE="${mmx_EV_PATHFILE_TO_SOURCE}"
  local lACTION lOS_PACKAGE_LIST
  local lCONTAINER_NAME lCONTAINER_SID lIMAGE_GOLDEN_TAG lIMAGE_GOLDEN_NAME lIMAGE_GOLDEN_FULLNAME lIMAGE_OUT_SNAME
  local lOS_USER_SUDO="${luc_EV_CIL_OS_USER_SUDO}"
  local lBUILDAH_PREFIX_IMG="${luc_EV_CIL_IMAGE_PREFIX}"

  # checkorexit image:golden exists
  lECHOVAL=$(luc_cil_image_id_get "$lIMAGE_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # getorexit image:golden:info
  lIMAGE_GOLDEN_FULLNAME=$(luc_cil_image_attribute_get $lIMAGE_SIDattribute FULLNAME)
  lIMAGE_GOLDEN_NAME=$(luc_cil_image_attribute_get $lIMAGE_SIDattribute NAME)
  lIMAGE_GOLDEN_TAG=$(luc_cil_image_attribute_get  $lIMAGE_SIDattribute TAG)
  lIMAGE_OUT_SNAME="$lAPP_NAME:latest"
  luc_core_echo "debu" "lIMAGE_GOLDEN_FULLNAME=${lIMAGE_GOLDEN_FULLNAME}"
  luc_core_echo "debu" "lIMAGE_OUT_SNAME=${lIMAGE_OUT_SNAME}"

  # getorexit container:name
  luc_core_echo "step" "create container from imageO ${lIMAGE_GOLDEN_FULLNAME} ($lIMAGE_SID"
  lECHOVAL=$(luc_cil_container_create "$lIMAGE_SID "$lAPP_NAME"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  lCONTAINER_NAME="$lECHOVAL"  
  
  
  # getorexit container:id
  lECHOVAL=$(luc_cil_container_attribute_get ${lCONTAINER_NAME} "ID"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  lCONTAINER_SID="${lECHOVAL:0:3}"
  luc_core_echo "done" "Ocreated container : ${lCONTAINER_NAME} (${lCONTAINER_SID})"
  
  # getorexit container:shell
  lECHOVAL=$(luc_cil_container_attribute_get ${lCONTAINER_NAME} "SHELL"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  lCONTAINER_SHELL="$(basename $lECHOVAL)"

  # choose os package list
  case "${lIMAGE_GOLDEN_NAME}" in
    "ubuntu") lOS_PACKAGE_LIST="${sOS_PACKAGE_LIST_ubuntu}";;
    "alpine") lOS_PACKAGE_LIST="${sOS_PACKAGE_LIST_alpine}";;
    "rocky")  lOS_PACKAGE_LIST="${sOS_PACKAGE_LIST_rocky}";;
    *) luc_core_echo "warn" "Os not managed > ${lIMAGE_GOLDEN_NAME}"; return 1;;
  esac

  # action
  luc_core_echo "step" "mount volume, source lib and provision $lOS_PACKAGE_LIST"
  lACTION=". ${lFOLDER_LUC_CONTAINER}/${lRELPATHFILE_LUC_TO_SOURCE} ${lFOLDER_LUC_CONTAINER}/${lRELPATHFILE_LUC_TO_SOURCE} ; luc_os_package_provision $lOS_PACKAGE_LIST"
  buildah run -v ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}:ro ${lCONTAINER_SID} ${lCONTAINER_SHELL} -c "$lACTION"
  luc_core_echo "done"
  return 
  
  # info
  luc_core_echo "step" "create image from container"
  local lIMAGE_REGISTRY_PATH=''
  luc_cil_image_create "${lCONTAINER_SID}" "${lIMAGE_OUT_SNAME}" "$lIMAGE_PATH"
}

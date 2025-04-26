# purpose : manage container images with Buildah

# shortcuts
# luc_cil_create_image     () { luc_cil_image_create "$@"; }
# luc_cil_get_image_id     () { luc_cil_image_id_get "$@"; }
# luc_cil_inspect_image    () { luc_cil_image_attribute_get "$@"; }
# luc_cil_delete_image     () { luc_cil_image_delete "$@"; }
# luc_cil_delete_image_dang() { luc_cil_image_dang_delete "$@"; }
# luc_cil_pull_image_os_all() { luc_cil_image_os_pull_all; }
# luc_cil_list_image_all   () { luc_cil_image_list_all; }
# luc_cil_delete_image_all () { luc_cil_image_delete_all; }
#

# purpose: 
# purpose: 3 states function that check image exists and echo 1 registry:image:value or 1 JSON:value of a key
## if pbs with image     => echo error msg and return 1
## if pbs with arguments => echo error msg and return 2
## if pbs with key       => echo error msg and return 3
## if ok                 => echo image:key:value and return 0
# args: $lIMAGE_SID $lINSPECT_TYPE $lKEY

# purpose: delete all images
luc_cil_image_dang_delete () {
  luc_core_echo "purp" "delete all dangling images"
  buildah rmi --prune
} 


# purpose: enter 1 image
# args: "$lIMAGE_SID"
luc_cil_image_enter () {
  luc_core_echo "purp" "enter 1 image"
  # define var
  local lIMAGE_SID=$1
  shift
  local lIMAGE_ID lCONTAINER_SNAME lIMAGE_NAME lCONTAINER_NAME_LONG lCONTAINER_NAME
  # varenv dependency
  local lBUILDAH_PREFIX_CONT=${luc_EV_CIL_CONTAINER_PREFIX}

  # check object exists
  lECHOVAL=$(luc_cil_image_id_get "$lIMAGE_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # check attribute exists
  lECHOVAL=$(luc_cil_image_attribute_get $lIMAGE_SIDjson "SHELL"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  # ok > image:shell
  lSHELL="$lECHOVAL"

  # check attribute exists
  lECHOVAL=$(luc_cil_image_attribute_get $lIMAGE_SIDattribute "NAME"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  # ok > image:name
  lIMAGE_NAME="$lECHOVAL"
  lCONTAINER_SNAME="temp-${lIMAGE_NAME}"
  lCONTAINER_NAME="${lBUILDAH_PREFIX_CONT}-${lCONTAINER_SNAME}"

  # info
  luc_core_echo "debu" "lIMAGE_PATH = $(luc_cil_image_attribute_get $lIMAGE_SIDattribute REGPATH)"
  luc_core_echo "debu" "lIMAGE_TAG  = $(luc_cil_image_attribute_get $lIMAGE_SIDattribute TAG)"
  luc_core_echo "debu" "lARCH       = $(luc_cil_image_attribute_get  $lIMAGE_SID json "OCIv1.architecture")"
  luc_core_echo "debu" "lIMAGE_SID       = $lIMAGE_SID
  luc_core_echo "debu" "lIMAGE_NAME      = $lIMAGE_NAME"
  luc_core_echo "debu" "lCONTAINER_SNAME = ${lCONTAINER_SNAME}"
  luc_core_echo "debu" "lCONTAINER_NAME  = ${lCONTAINER_NAME}"
  luc_core_echo "debu" "lSHELL           = $lSHELL"

  # info
  luc_core_echo "step" "create container from image ($lIMAGE_SID/$lIMAGE_NAME)"
  
  # check object exists after creation
  lECHOVAL=$(luc_cil_container_create "$lIMAGE_SID "${lCONTAINER_SNAME}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  # ok > container:name
  lCONTAINER_NAME="$lECHOVAL"  

  # check attribute exists
  lECHOVAL=$(luc_cil_container_attribute_get ${lCONTAINER_NAME} "ID"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  # ok > container:shell
  lCONTAINER_ID="$lECHOVAL"

  # enter container and kill it on exit
  luc_cil_container_enter ${lCONTAINER_ID} $@ && buildah rm ${lCONTAINER_NAME}
}

luc_cil_image_os_pull_all () {
  local lIMAGE_TAG_LIST=${luc_EV_CIL_IMAGE_OS_BASE_LIST}
  for IMG in ${lIMAGE_TAG_LIST}; do
    buildah pull ${IMG};
  done
} 


# purpose: create an image from a container
# args: lCONTAINER_SID lIMAGE_FULLNAME lIMAGE_REGISTRY_PATH
luc_cil_image_create () {
  # define var
  # var@input
  local lCONTAINER_SID=$1
  local lIMAGE_FULLNAME=$2
  local lIMAGE_REGISTRY_PATH=$3
  # var@dependency
  local lBUILDAH_PREFIX_CONT="${luc_EV_CIL_CONTAINER_PREFIX}"
  local lBUILDAH_PREFIX_IMG="${luc_EV_CIL_IMAGE_PREFIX}"
  local lCONTAINER_NAME="$(luc_cil_container_attribute_get ${lCONTAINER_SID} NAME)"
  # var@calculated
  local lIMAGE_FULLNAME="${lBUILDAH_PREFIX_IMG}/dev/${lIMAGE_REGISTRY_PATH}/${lIMAGE_FULLNAME}"
  
  luc_core_echo "purp" "create image from container"
  
  # checkorexit container exists
  lECHOVAL=$(luc_cil_container_id_get "${lCONTAINER_SID}"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # checkorexit args
  if [ "$#" -ne 3 ]; then
    luc_core_echo "warn" "Needed 2 args: lCONTAINER_SID lIMAGE_FULLNAME lIMAGE_REGISTRY_PATH"
    return 1
  fi

  luc_core_echo "info" "create image: ${lIMAGE_FULLNAME} from container : ${lCONTAINER_SID} (${lCONTAINER_NAME})"
  luc_core_echo "debu" "buildah commit ${lCONTAINER_SID} ${lIMAGE_FULLNAME}"
  buildah commit ${lCONTAINER_SID} ${lIMAGE_FULLNAME}
  luc_core_echo "done"

  buildah images
} 


  
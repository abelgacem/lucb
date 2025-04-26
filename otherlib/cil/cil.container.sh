# purpose : manage container with Buildah







# purpose : enter in a container
# args: $lCONT_ID
luc_cil_container_enter() {
  luc_core_echo "purp" "enter 1 container"
  # define var
  local lCONTAINER_SID=$1
  shift
  local lCONTAINER_ID lCONTAINER_SHELL lCONTAINER_NAME
  # varenv dependency
  local lBUILDAH_PREFIX_CONT=${luc_EV_CIL_CONTAINER_PREFIX}

  # check object exists
  lECHOVAL=$(luc_cil_container_id_get "${lCONTAINER_SID}"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  # # ok > container:id
  # lCONTAINER_ID="$lECHOVAL"

  # check object exists
  lECHOVAL=$(luc_cil_container_attribute_get ${lCONTAINER_SID} "SHELL"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  # ok > container:shell
  lCONTAINER_SHELL="$lECHOVAL"

  # check object exists
  lECHOVAL=$(luc_cil_container_attribute_get ${lCONTAINER_SID} "NAME"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  # ok > container:shell
  lCONTAINER_NAME="$lECHOVAL"
  
  # ok to continue
  luc_core_echo "info" "enter container with following specs"
  luc_core_echo "debu" "lCONTAINER_NAME  = ${lCONTAINER_NAME}"
  luc_core_echo "debu" "lCONTAINER_ID    = ${lCONTAINER_SID}"
  luc_core_echo "debu" "lCONTAINER_SHELL = ${lCONTAINER_SHELL}"
  # enter interactive
  # example :luc_cil_container_enter ff -v /home/ubuntu/wkspc/git/luc-bash:/tmp/luc
    buildah run $@ -t  ${lCONTAINER_SID}  ${lCONTAINER_SHELL} -l 
}
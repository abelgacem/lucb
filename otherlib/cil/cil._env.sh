# purpose : define the pre-requisits
# - set environment variables for this project/lib
# - check prerequisit to use libraries

return 1

lLIB="cil"
# Check
CLI='buildah'; luc_core_check_cli_is_installed ${CLI} || { 
  luc_core_echo "warn" "library : $lLIB > not loaded > ${CLI} is not installed." 
  return 1 
}   
# Check
CLI='jq'; luc_core_check_cli_is_installed ${CLI} || { 
  luc_core_echo "warn" "library : $lLIB > not loaded > ${CLI} is not installed." 
  return 1 
}   

export luc_EV_CIL_OS_USER_SUDO="lisa" # linux sudo admin
export luc_EV_CIL_OS_USER_STD="lise"  # linux std user
export luc_EV_CIL_CONTAINER_PREFIX="mxc"
export luc_EV_CIL_IMAGE_PREFIX="mxi"
export mmx_EV_FOLDER_LUC="/home/ubuntu/wkspc/git/luc-bash"
export mmx_EV_PATHFILE_TO_SOURCE="setup/srclib"
export luc_EV_CIL_IMAGE_OS_BASE_LIST="
  ubuntu:25.04
  rockylinux:9.3
  almalinux:9.5
  alpine:3.20.3
"

luc_core_echo "caut" "library : $lLIB > some commands need sudo." 
return 0
# purpose : define the pre-requisits
# - set environment variables for this project/lib
# - check prerequisit to use libraries

lLIB="docker";
# Check
CLI='docker';luc_core_check_cli_is_installed ${CLI} || { 
  luc_core_echo "caut" "library : $lLIB > ${CLI} is not installed." 
  return 1 
}   

export luc_EV_DOCKER_CONTAINER_PREFIX="mxc"
export luc_EV_DOCKER_IMAGE_PREFIX="mxi"

return 0
# purpose : define the pre-requisits
# - set environment variables for this project/lib
# - check prerequisit to use libraries


lLIB="oldcil"
luc_core_echo "warn" "library : $lLIB > not loaded." && return 1 
# Check
CLI='docker';luc_core_check_cli_is_installed ${CLI} || { 
  luc_core_echo "warn" "library : $lLIB > not loaded > ${CLI} is not installed." 
  return 1 
}   

export gsIMAGE_KANIKO="gcr.io/kaniko-project/executor:v1.23.2"
export gsIMAGE_KANIKO="gcr.io/kaniko-project/executor:v1.23.2"
export gsIMAGE_SKOPEO="quay.io/skopeo/stable:latest"
export gsIMAGE_DOCKER_REGISTRY="registry:2"
export gsSERVICE_REGISTRY_IP="localhost"
export gsSERVICE_REGISTRY_CONT_PORT="5000"
export gsSERVICE_REGISTRY_HOST_PORT="5001"
export gsNAME_REGISTRY_DOCKER_VOLUME="mx-docker-registry"
export gsNAME_CONT_SERVICE_REGISTRY_DOCKER="mxcs-docker-registry"

luc_core_echo "info" "library : $lLIB > loaded." 
return 0

# gs = global from script
#### shortcuts ####
# purpose: list docker objects 
luc_docker_image_list_all() { luc_docker_core_list; }







luc_docker_image_enter () {
  local lIMAGE_SID=$1
  local lPREFIX_IMAGE=$luc_EV_DOCKER_IMAGE_PREFIX
  local lPREFIX_CONTAINER=$luc_EV_DOCKER_CONTAINER_PREFIX
  local lCONTAINER_NAME="${lPREFIX_CONTAINER}-temp-$lIMAGE_SID
  local lIMAGE_SHELL

  luc_core_echo "purp" "enter 1 docker image"
  
  # checkorexit arg is provided
  [ -z "$1" ] && {
    luc_core_echo "warn" "No image:id provided.choose one" 
    luc_docker_image_list_all
    return 1
  }

  # do
  echo "docker run -it --name ${lCONTAINER_NAME} --rm $lIMAGE_SID${lIMAGE_SHELL} -l"
  luc_core_echo "done"

}
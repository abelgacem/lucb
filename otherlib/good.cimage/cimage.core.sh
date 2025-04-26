# purpose: list available tag for an image container in the docker hub publi registry
# args: <IMAGE_SNAME>
luc_cimage_tag_list() {
  local lMSG_PURPOSE="list available tag for an image container in the docker hub publi registry"
  local lMSG_USAGE="$(luc_core_method_name_get) <IMAGE_SNAME>"
  local lMSG_EXAMPLE="$(luc_core_method_name_get) nginx"
  local lIMAGE_SNAME="$1"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  # checkorexit args are provided
  [ -z "$lIMAGE_SNAME" ] ||
  [ "--help" == "$1"   ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit response exists
  luc_core_echo "chec" "image exists when getting the tags"
  lECHOVAL=$(curl -s "https://registry.hub.docker.com/v2/repositories/library/$lIMAGE_SNAME/tags")
  [ ! "null" == "$(echo $lECHOVAL | jq .errinfo)" ] && echo "$lECHOVAL" && return 2
  
  # format the response
  luc_core_echo "info" "list of available tags for image: $lIMAGE_SNAME"
  echo "$lECHOVAL" | jq '.results[].name' 
}

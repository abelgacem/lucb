# purpose: buildah run a CLI in an image
# args: <IMAGE_SID> <CLI> [OPTIONS]
luc_buildah_image_cli_run() {
  local lMSG_PURPOSE="buildah run a CLI in an image"  
  local lMSG_USAGE="$(luc_core_method_name_get) <IMAGE_SID> <CLI> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12 -v xxx,yyy:ro" 
  local lCONTAINER_TEMP_NAME="temp-$(luc_core_id_get 5)"
  local lIMAGE_SID="$1"
  local lCLI="$2"
  shift 2; local lOPTIONS="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  # checkorexit args are provided
  [ -z "$lIMAGE_SID" ] ||
  [ -z "$lCLI" ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  lECHOVAL=$(luc_buildah_image_check_exists $lIMAGE_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2

  # getorexit image FULLNAME
  luc_core_echo "step" "get image FULLNAME"
  lECHOVAL=$(luc_buildah_property_get --image $lIMAGE_SID FULLNAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 || lIMAGE_FULLNAME="$lECHOVAL"

  # info
  luc_core_echo "debu" "lIMAGE_FULLNAME  : $lIMAGE_FULLNAME ($lIMAGE_SID)"
  luc_core_echo "debu" "lCONTAINER_SHELL : $lCONTAINER_SHELL"
  luc_core_echo "debu" "lCLI             : $lCLI"
  luc_core_echo "debu" "lOPTIONS         : $lOPTIONS"

  # create temporary container
  luc_core_echo "step" "create temporary container"
  lECHOVAL=$(luc_buildah_container_create $lCONTAINER_TEMP_NAME $lIMAGE_SID $lOPTIONS);lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # getorexit container SID
  luc_core_echo "step" "get container SID"
  lECHOVAL=$(luc_buildah_sid_get --container $lCONTAINER_TEMP_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 || lCONTAINER_TEMP_ID="$lECHOVAL"

  # getorexit container shell
  luc_core_echo "step" "get container shell"
  lECHOVAL=$(luc_buildah_property_get --container $lCONTAINER_TEMP_ID SHELL); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lCONTAINER_SHELL="$lECHOVAL"
  

  # play CLI the container
  luc_core_echo "step" "play CLI in the temporary container $lCONTAINER_TEMP_NAME ($lCONTAINER_TEMP_ID)"
  luc_buildah_container_cli_run "$lCONTAINER_TEMP_ID" "$lCLI" $lOPTIONS 
  
  # return
  luc_buildah_container_delete $lCONTAINER_TEMP_ID
  return 0 
}

# # purpose: buildah run a CLI in a container
# # args: <CONTAINER_SID> <CLI> [OPTIONS]
# luc_buildah_container_cli_run() {
#   local lMSG_PURPOSE="buildah run a CLI in container"  
#   local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_SID> <CLI> [OPTIONS]"  
#   local lMSG_EXAMPLE="$(luc_core_method_name_get) 77 printenv | set | 'id -un'" 
#   local lCONTAINER_SID="$1"
#   local lCLI="$2"
#   shift 2; local lOPTIONS="$@"

#   # purpose
#   luc_core_echo "purp" "$lMSG_PURPOSE"

#   # checkorexit args are provided
#   [ -z "$lCONTAINER_SID" ] ||
#   [ -z "$lCLI" ] ||
#     [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

#   # checkorexit container exists
#   lECHOVAL=$(luc_buildah_container_check_exists $lCONTAINER_SID); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2

#   # getorexit container shell
#   lECHOVAL=$(luc_buildah_property_get --container $lCONTAINER_SID SHELL); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lCONTAINER_SHELL="$lECHOVAL"

#   # getorexit container name
#   lECHOVAL=$(luc_buildah_property_get --container $lCONTAINER_SID NAME); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lCONTAINER_NAME="$lECHOVAL"

#   # info
#   luc_core_echo "debu" "lCONTAINER       : $lCONTAINER_NAME ($lCONTAINER_SID)"
#   luc_core_echo "debu" "lCONTAINER_SHELL : $lCONTAINER_SHELL"
#   luc_core_echo "debu" "lCLI             : $lCLI"
#   luc_core_echo "debu" "lOPTIONS         : $lOPTIONS"
#   luc_core_echo "debu" "CLI              : buildah run $lOPTIONS $lCONTAINER_SID $lCONTAINER_SHELL -c \"$lCLI\""

#   # run the CLI in container
#   luc_core_echo "step" "run the CLI in container"
#   lECHOVAL=$(buildah run $lOPTIONS $lCONTAINER_SID $lCONTAINER_SHELL -c "$lCLI"); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 3 || echo "$lECHOVAL"
  
#   # return
#   return 0 
# }


# # purpose: buildah create image from a container
# # note: output and return are used
# # args: <IMAGE_SNAME> <CONTAINER_SID> [OPTIONS]
# luc_buildah_image_create() {
#   local lMSG_PURPOSE="buildah create image from a container"  
#   local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_SID> <IMAGE_SNAME> [OPTIONS]"  
#   local lMSG_EXAMPLE="$(luc_core_method_name_get) aeb34e myimage" 
#   local lIMAGE_SNAME="$1"
#   local lCONTAINER_SID="$2"
#   shift 2; local lOPTIONS="$@"

#   # purpose
#   luc_core_echo "purp" "$lMSG_PURPOSE"
  
#   # checkorexit args are provided
#   [ -z "$lCONTAINER_SID" ] ||
#   [ -z "$lIMAGE_SNAME" ] ||
#   [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  
#   # checkorexit container exists
#   lECHOVAL=$(luc_buildah_container_check_exists $lCONTAINER_SID); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2

#   # getorexit container SID
#   lECHOVAL=$(luc_buildah_sid_get --container $lCONTAINER_SID); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 3 || lCONTAINER_NAME="$lECHOVAL"
  
#   # info
#   luc_core_echo "debu" "lCONTAINER  : $lCONTAINER_SID"
#   luc_core_echo "debu" "lIMAGE_SNAME: $lIMAGE_SNAME"
#   luc_core_echo "debu" "lOPTIONS:     $lOPTIONS"

#   # create the image
#   luc_core_echo "debu" "CLI > buildah commit $lOPTIONS $lCONTAINER_SID $lIMAGE_SNAME"
#   lEHOVAL=$(buildah commit $lOPTIONS $lCONTAINER_SID $lIMAGE_SNAME  2>&1); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "failed to  create image $lIMAGE_SNAME"  &&  return 14

#   # getorexit image SID
#   lECHOVAL=$(luc_buildah_sid_get --image $lIMAGE_SNAME); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 5 || lIMAGE_ID="$lECHOVAL"

#   # get the image FULLNAME
#   lECHOVAL=$(luc_buildah_property_get --image $lIMAGE_ID FULLNAME); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 6 || lIMAGE_FULLNAME="$lECHOVAL"
  
#   # return
#   luc_core_echo "done" "created image $lIMAGE_FULLNAME ($lIMAGE_ID) from container $lCONTAINER_NAME ($lCONTAINER_SID)"
#   return 0
# }


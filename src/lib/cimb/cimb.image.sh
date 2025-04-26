
# shortcuts
luc_cimb_image_list() { luc_cimb_list; }

# purpose: buildah check a container image exits
# note: no other echo inside the code - helper function - the return value and code are used
# args   : <IMAGE_SID>
# return : O if exist, an integer otherwise
luc_cimb_image_check_exists() {
  local lMSG_PURPOSE="check an image exits"  
  local lMSG_USAGE="$(luc_core_method_name_get) <IMAGE_SID>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lOBJECT_SID="$1"

  # checkorexit args are provided
  [ -z "$lOBJECT_SID" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # get ID(s) found
  lECHOVAL=$(buildah images --all --format "{{.ID}}" | grep "^${lOBJECT_SID}"); lRETVAL=$?
  
  # get nb ID(s) found
  lNBID="$(echo $lECHOVAL | wc -w)"
  
  # when no ID found
  [ 0 -ne "$lRETVAL" ] && {
    luc_core_echo "warn" "no image found with sid: $lOBJECT_SID. Choose 1 among:" 
    buildah images --all
    return 2
  }
  # when several ID(s) found
  [  0 -eq "$lRETVAL" ] && [ 2 -le "$lNBID" ] && {
    luc_core_echo "caut" "multiple imagess found starting with sid: $lOBJECT_SID. Choose 1 among:" 
    buildah images --all
    return 3
  }
  # when exactly 1 ID found
  echo $lECHOVAL; return 0 
} # function


# purpose: buildah pull one or more container images
# args: --all | <IMG1> <IMG2>
luc_cimb_image_pull() {
  local lMSG_PURPOSE="buildah pull one or more container images"  
  local lMSG_USAGE="$(luc_core_method_name_get) --all | <IMG1> <IMG2>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) --all | nginx [alpine:3.20.3] " 
  local lIMAGE_TO_PULL="$1"
  local lIMAGE_ROOT_LIST="$luc_EV_CIMB_IMAGE_ROOT_LIST"
  local lIMAGE_LIST
  local lUSAGE_MSG="$(luc_core_method_name_get) --all|--image <lIMAGE_TO_PULL01> <lIMAGE_TO_PULL02>"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  # checkorexit args are provided
  [ -z "$lIMAGE_TO_PULL" ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  
  # define var according to input
  [ "$lIMAGE_TO_PULL" == "--all"   ] && lIMAGE_LIST="$lIMAGE_ROOT_LIST" || lIMAGE_LIST="$@" 
      
  # pull images
  luc_core_echo "info" "image(s) to pull: $(echo ${lIMAGE_LIST} | tr '\n' ' ')"
  for lIMG in ${lIMAGE_LIST}; do buildah pull $lIMG;done

  # return
  luc_core_echo "done" "pulled image: $(echo ${lIMAGE_LIST} | tr '\n' ' ')"
  return 0
} # function


# purpose: buildah create an image from a container
# note: output and return are used
# args: <IMAGE_NAME> <CONTAINER_SID> [OPTIONS]
luc_cimb_image_create() {
  local lMSG_PURPOSE="buildah create image from a container"  
  local lMSG_USAGE="$(luc_core_method_name_get) <CONTAINER_SID> <IMAGE_NAME> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) aeb34e myimage" 
  local lIMAGE_NAME="$1"
  local lCONTAINER_SID="$2"
  shift 2; local lOPTIONS="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lCONTAINER_SID" ] ||
  [ -z "$lIMAGE_NAME" ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  
  # checkorexit container exists
  lECHOVAL=$(luc_cimb_container_check_exists $lCONTAINER_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2

  # getorexit container SID
  lECHOVAL=$(luc_cimb_sid_get --container $lCONTAINER_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 3 || lCONTAINER_NAME="$lECHOVAL"
  
  ###### INFO
  luc_core_echo "debu" "container SRC : $lCONTAINER_SID"
  luc_core_echo "debu" "image     DST : $lIMAGE_NAME"
  luc_core_echo "debu" "lOPTIONS      : $lOPTIONS"
  luc_core_echo "debu" "CLI           : buildah commit $lOPTIONS $lCONTAINER_SID $lIMAGE_NAME"

  ###### ACION: CREATE BUILDAH IMAGE  ################## 
  lEHOVAL=$(buildah commit $lOPTIONS $lCONTAINER_SID $lIMAGE_NAME  2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "failed to  create image $lIMAGE_NAME"  &&  return 14

  ###### CHECK PROVISIONING ##################### 
  # getorexit image SID
  lECHOVAL=$(luc_cimb_sid_get --image $lIMAGE_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 5 || lIMAGE_ID="$lECHOVAL"

  # get the image FULLNAME
  lECHOVAL=$(luc_cimb_property_get --image $lIMAGE_ID FULLNAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 6 || lIMAGE_FULLNAME="$lECHOVAL"
  
  # return
  luc_core_echo "done" "created image $lIMAGE_FULLNAME ($lIMAGE_ID) from container $lCONTAINER_NAME ($lCONTAINER_SID)"
  return 0
}



# purpose: buildah delete all or some container images
# args: --all | --temp | <OBJECT_SID1> <OBJECT_SID2> ...
luc_cimb_image_delete() {
  local lMSG_PURPOSE="buildah delete all or some container images"  
  local lMSG_USAGE="$(luc_core_method_name_get) --all | --temp | --dangling | <OBJECT_SID1> <OBJECT_SID2> ..."  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) aeb34e" 
  local lOBJECT_SID="$1"
  local lOBJECT_LIST="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  # checkorexit args are provided
  [ -z "$lOBJECT_SID"      ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 3

  # define the list of containers to delete
  # when --all
  [ "$lOBJECT_SID" == "--all" ] && {
    lMSG="all images"
    lOBJECT_LIST="--all"
  }
  # when --temp
  [ "$lOBJECT_SID" == "--temp" ] && {
    lMSG="temporary images"
    lOBJECT_LIST=$(buildah images --quiet --filter 'name=temp-')
  }
  # when --dangling
  [ "$lOBJECT_SID" == "--dangling"  ] && {
    lMSG="dangling and <none> images"
    lOBJECT_LIST="$(buildah images --all --quiet --filter dangling=true) $(buildah images --all | awk '/<none>/ { print $3 }')"
  }
  # when a list is provided
  [ "$lOBJECT_SID" != "--all"       ] && 
  [ "$lOBJECT_SID" != "--dangling"  ] && 
  [ "$lOBJECT_SID" != "--temp"      ] && {
    lMSG="provided images"
    lOBJECT_LIST="$@"
  }
  # delete the objects
  luc_core_echo "info" "deleting $lMSG"
  buildah rmi --force $lOBJECT_LIST
  return 0
} # function


# purpose: buildah enter [interactively] a container image
# args   : <IMAGE_SID> [OPTIONS]
luc_cimb_image_enter() {
  local lMSG_PURPOSE="buildah enter [interactive] an image"  
  local lMSG_USAGE="$(luc_core_method_name_get) <IMAGE_SID> [OPTIONS]"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12 -v xxx,yyy:ro" 
  local lCONTAINER_TEMP_NAME="temp-$(luc_core_id_get 5)"
  local lIMAGE_SID="$1"
  shift 1; local lOPTIONS="$@"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  # checkorexit args are provided
  [ -z "$lIMAGE_SID" ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  lECHOVAL=$(luc_cimb_image_check_exists $lIMAGE_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2

  # getorexit image FULLNAME
  luc_core_echo "step" "get image FULLNAME"
  lECHOVAL=$(luc_cimb_property_get --image $lIMAGE_SID FULLNAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 || lIMAGE_FULLNAME="$lECHOVAL"

  # create temporary container
  luc_core_echo "step" "create temporary container"
  lECHOVAL=$(luc_cimb_container_create $lCONTAINER_TEMP_NAME $lIMAGE_SID  $lOPTIONS);lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # getorexit container SID
  lECHOVAL=$(luc_cimb_sid_get --container $lCONTAINER_TEMP_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 || lCONTAINER_TEMP_ID="$lECHOVAL"

  # getorexit container shell
  luc_core_echo "step" "get container shell"
  lECHOVAL=$(luc_cimb_property_get --container $lCONTAINER_TEMP_ID SHELL); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 2 || lCONTAINER_SHELL="$lECHOVAL"
  
  # info
  luc_core_echo "debu" "lIMAGE           : $lIMAGE_FULLNAME ($lIMAGE_SID)"
  luc_core_echo "debu" "lCONTAINER_SHELL : $lCONTAINER_SHELL"
  luc_core_echo "debu" "lOPTIONS         : $lOPTIONS"

  # enter the container
  luc_core_echo "step" "enter the temporary container $lCONTAINER_TEMP_NAME ($lCONTAINER_TEMP_ID)"
  luc_cimb_container_enter $lCONTAINER_TEMP_ID $lOPTIONS 
  
  # return
  luc_cimb_container_delete $lCONTAINER_TEMP_ID
  return 0 
} # function

# purpose: buildah create a base os image from a root os image
# args: <ROOT_IMAGE_SID>
luc_cimb_image_golden_create()  {
  local lMSG_PURPOSE="buildah create a base os image from a root os image"  
  local lMSG_USAGE="$(luc_core_method_name_get) <ROOT_IMAGE_SID>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lIMAGE_SRC_SID="$1"
  local lLABEL_KEY_SHELL="$luc_EV_CIMB_LABEL_KEY_SHELL"
  local lLABEL_KEY_OSNAME="$luc_EV_CIMB_LABEL_KEY_OSNAME"
  local lLABEL_KEY_IMAGE_00="$luc_EV_CIMB_LABEL_KEY_IMAGE_00"
  local lLABEL_KEY_IMAGE_CURRENT="$luc_EV_CIMB_LABEL_KEY_IMAGE_CURRENT"
  local lOS_USER_SUDO="$luc_EV_CIMB_OS_USER_SUDO"
  local lFOLDER_LUC_HOST="$luc_EV_CIMB_LUC_CORE_HOME"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"
  local lFILE_LUCSETUP_CONTAINER="${lFOLDER_LUC_CONTAINER}/$luc_EV_CIMB_LUC_SETUP_RELPATH"  
  local lCONTAINER_TEMP_NAME="temp-$(luc_core_id_get 5)"
  local lENVARS lLABELS lVOLUMES lUSER lWKDIR
  local lLIST_ENVAR lLIST_LABEL lLIST_VOLUME
  local lOPTIONS

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lIMAGE_SRC_SID"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  lECHOVAL=$(luc_cimb_image_check_exists  $lIMAGE_SRC_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # getorexit image ID
  lECHOVAL=$(luc_cimb_property_get --image  ${lIMAGE_SRC_SID} ID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_ID="$lECHOVAL"

  # getorexit image NAME
  lECHOVAL=$(luc_cimb_property_get --image  ${lIMAGE_SRC_SID} SNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_SNAME="$lECHOVAL"

  # getorexit image FULLNAME
  lECHOVAL=$(luc_cimb_property_get --image  ${lIMAGE_SRC_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_FULLNAME="$lECHOVAL"

  # getorexit image TAG
  lECHOVAL=$(luc_cimb_property_get --image  ${lIMAGE_SRC_SID} TAG); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_TAG="$lECHOVAL"

  # getorexit image SHELL
  lECHOVAL=$(luc_cimb_property_get --image  ${lIMAGE_SRC_SID} SHELL); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_SHELL="$lECHOVAL"

  ###### DEFINE VARIABLES
  # define image fullname - remove linux in name if exists
  lIMAGE_DST_FULLNAME="dev/os/${lIMAGE_SRC_SNAME/linux/}:${lIMAGE_SRC_TAG}"

  ###### DEFINE CONFIGURATION DATA
  lENVARS="LUCSETUP=$lFILE_LUCSETUP_CONTAINER OS_USER_SUDO=$lOS_USER_SUDO"
  lLABELS=" 
    ${lLABEL_KEY_IMAGE_00}=$lIMAGE_SRC_FULLNAME
    ${lLABEL_KEY_IMAGE_CURRENT}=$lIMAGE_DST_FULLNAME
    ${lLABEL_KEY_OSNAME}=$lIMAGE_SRC_SNAME
    ${lLABEL_KEY_SHELL}=$lIMAGE_SRC_SHELL
  "
  lUSER=" --user $lOS_USER_SUDO"
  lVOLUMES="$lFOLDER_LUC_HOST:$lFOLDER_LUC_CONTAINER:ro"
  lWKDIR=" --workingdir /home/$lOS_USER_SUDO"

  ###### FORMAT CONFIGURATION DATA FOR BUILDAH
  [ ! -z "$lENVARS"  ] && lLIST_ENVAR='';  for ITEM in $lENVARS;  do lLIST_ENVAR+=" --env $ITEM";     done
  [ ! -z "$lLABELS"  ] && lLIST_LABEL='';  for ITEM in $lLABELS;  do lLIST_LABEL+=" --label $ITEM";   done
  [ ! -z "$lVOLUMES" ] && lLIST_VOLUME=''; for ITEM in $lVOLUMES; do lLIST_VOLUME+=" --volume $ITEM"; done

  ###### INFO
  luc_core_echo "step" "collect datas and infos"

  luc_core_echo "debu" "image SRC : $lIMAGE_SRC_FULLNAME ($lIMAGE_SRC_SID) ($lIMAGE_SRC_SHELL)"
  luc_core_echo "debu" "image DST : $lIMAGE_DST_FULLNAME"
  luc_core_echo "debu" "lCONTAINER_TEMP_NAME     : $lCONTAINER_TEMP_NAME"
  luc_core_echo "debu" "lFILE_LUCSETUP_CONTAINER : $lFILE_LUCSETUP_CONTAINER"
  luc_core_echo "info" "image envar    : $lLIST_ENVAR"
  luc_core_echo "info" "image user     : $lUSER"
  luc_core_echo "info" "volume mapping : $lLIST_VOLUME"
  luc_core_echo "info" "image wkdir    : $lWKDIR"
  # luc_core_echo "info" "image label    : ${lLIST_LABEL:0:100} ..."
  luc_core_echo "info" "image label    : ${lLIST_LABEL}"
  
  
  ###### ACION: CREATE BUILDAH CONTAINER  ################## 
  luc_core_echo "step" "create a temporary container"
  lECHOVAL=$(luc_cimb_container_create $lCONTAINER_TEMP_NAME $lIMAGE_SRC_SID $lLIST_VOLUME);lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 || echo "$lECHOVAL"    

  ###### CHECK PROVISIONING ##################### 
  # getorexit container SID
  # luc_core_echo "chec" "container exists. If yes get temporary container SID"
  luc_core_echo "chec" "container exists"
  lECHOVAL=$(luc_cimb_sid_get --container $lCONTAINER_TEMP_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" &&  return 1 || lCONTAINER_TEMP_SID="$lECHOVAL"
  
  ###### ACION: PROVISION BUILDAH TEMPORARY CONTAINER
  
  ###### CLI
  luc_core_echo "step" "run CLI in the temporary container"
  ## CONF
  lOPTIONS="--env LUCSETUP=$lFILE_LUCSETUP_CONTAINER"
  lCLI=". \$LUCSETUP ; luc_core_os_package_upgrade"
  # lCLI='echo "user = $(id -un)"; ls -ial; echo -$LUCSETUP-; printenv'
  luc_core_echo "debu" "container OPTIONS : $lOPTIONS"
  luc_core_echo "debu" "CLI               : $lCLI"
  ## ACTION
  lECHOVAL=$(luc_cimb_container_cli_run $lCONTAINER_TEMP_SID "$lCLI" "$lOPTIONS"); lRETVAL=$?
  [ ! 0 -eq "$lRETVAL"  ] && echo "$lECHOVAL" && return 1  || echo "$lECHOVAL"

  ###### CLI
  luc_core_echo "step" "run CLI in the temporary container"
  ## CONF
  lOPTIONS="--env LUCSETUP=$lFILE_LUCSETUP_CONTAINER"
  lCLI=". \$LUCSETUP ; luc_core_os_user_sudo_provision $lOS_USER_SUDO"
  luc_core_echo "debu" "container OPTIONS : $lOPTIONS"
  luc_core_echo "debu" "CLI               : $lCLI"
  ## ACTION
  lECHOVAL=$(luc_cimb_container_cli_run $lCONTAINER_TEMP_SID "$lCLI" "$lOPTIONS"); lRETVAL=$?
  [ ! 0 -eq "$lRETVAL"  ] && echo "$lECHOVAL" && return 1 # || echo "$lECHOVAL"
 
  ###### CHECK PROVISIONING ############################
  luc_core_echo "chec" "USER is created inside the container"
  luc_cimb_container_cli_run $lCONTAINER_TEMP_SID "cat /etc/passwd | grep $lOS_USER_SUDO"
  

  ###### CONFIGURE CONTAINER ###########################
  luc_core_echo "step" "set container ENVARs, LABELs, USER and WORKDIR"
  buildah config ${lLIST_ENVAR} ${lLIST_LABEL} $lUSER $lWKDIR ${lCONTAINER_TEMP_SID}
  
  
  ###### CHECK CONGIGURATION ###########################
  luc_core_echo "chec" "LABELs values in container metadata"
  luc_cimb_property_get --container $lCONTAINER_TEMP_SID LABEL | jq .
  
  luc_core_echo "chec" "ENVARs value in container metadata"
  luc_cimb_property_get --container $lCONTAINER_TEMP_SID ENVAR | jq .

  luc_core_echo "chec" "ENVARs value inside the container"
  luc_cimb_container_cli_run $lCONTAINER_TEMP_SID "env"

  luc_core_echo "chec" "USER value in container metadata"
  luc_cimb_property_get --container $lCONTAINER_TEMP_SID USER

  luc_core_echo "chec" "USER inside the container"
  luc_cimb_container_cli_run $lCONTAINER_TEMP_SID "id -un"

  luc_core_echo "chec" "WORKINGDIR inside the container"
  luc_cimb_container_cli_run $lCONTAINER_TEMP_SID "pwd"
  
  
  ###### ACION: CREATE IMAGE FROM CONTAINER / COMMIT CONTAINER INTO IMAGE
  luc_core_echo "step" "commit the container to destsination image: $lIMAGE_DST_FULLNAME"
  lECHOVAL=$(luc_cimb_image_create $lIMAGE_DST_FULLNAME $lCONTAINER_TEMP_SID 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" || echo "$lECHOVAL"

  
  ###### CHECK PROVISIONING ############################
  # getorexit image SID
  lECHOVAL=$(luc_cimb_sid_get --image $lIMAGE_DST_FULLNAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" &&  return 1 || lIMAGE_DST_SID="$lECHOVAL"


  ###### CLEAN OBJECTS ################################# 
  luc_core_echo "step" "delete temporary container"
  lECHOVAL=$(luc_cimb_container_delete $lCONTAINER_TEMP_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" || echo "$lECHOVAL"
    

  ###### RETURN
  # luc_core_echo "done" "created image $lIMAGE_DST_FULLNAME ($lIMAGE_DST_SID) from container $lCONTAINER_TEMP_NAME ($lCONTAINER_TEMP_SID)"
  return 0
}

# purpose: buildah create all base os image from root os image
# args: NONE
luc_cimb_image_golden_create_all()  {
  local lMSG_PURPOSE="buildah create a base os image from a root os image"  
  local lMSG_USAGE="$(luc_core_method_name_get) <ROOT_IMAGE_SID>"  
  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  ###### PREREQUISIT
  # checkorexit image exists
  luc_core_echo "step" "create list of SRC images"
  lIMAGE_SRC_LIST=$(echo "$luc_EV_CIMB_IMAGE_ROOT_LIST" | grep -E "^\s*($luc_EV_CIMB_CORE_OS_MANAGED)")
  [ ! -n "$lIMAGE_SRC_LIST" ] && luc_core_echo "warn" "none of $luc_EV_CIMB_CORE_OS_MANAGED is in $luc_EV_CIMB_IMAGE_ROOT_LIST" && return 1
  luc_core_echo "debu"  "lIMAGE_SRC_LIST : $(echo $lIMAGE_SRC_LIST | tr '\n' ' ')"

  ###### ACTION: CREATE IMAGES
  luc_core_echo "step" "create images from root image"
  for lIMAGE_SRC in $lIMAGE_SRC_LIST; do
    lIMAGE_SID=$(luc_cimb_sid_get --image $lIMAGE_SRC)
    luc_cimb_image_golden_create $lIMAGE_SID
  done
}





# # Purpose: create all golden image
# # Note: change in container image name => change the criteria
# # args NONE
# luc_cimagev2_golden_create_all() {
#   # export luc_EV_CIMAGE_OS_LIST=${luc_EV_LUC_CORE_OS_MANAGED}
#   local lCRITERIA=${luc_EV_CIMAGE_OS_LIST}
#   luc_core_echo "purp" "create all golden os images (ie. $lCRITERIA)"

#   # checkorexit cli exists
#   luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
#   luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
#   [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1
  
#   # If one match select it as a src image
#   lIMAGE_SRC_LIST=$($lCIM_TOOL images | awk -v pattern="$lCRITERIA" '$1 ~ pattern {print $3}')

#   # ### debug ###
#   # luc_core_echo "debu" "$($lCIM_TOOL images | awk -v pattern=$lCRITERIA '$1 ~ pattern {print $1}')"
#   # return 5
#   # ### debug ###

#   # checkorexit list not empty
#   [ -z "$lIMAGE_SRC_LIST" ] && luc_core_echo "warn" "No root images found" && return 1
  
#   for IMG_SRC_ID in ${lIMAGE_SRC_LIST}; do
#     luc_cimage_golden_create_from $IMG_SRC_ID
#   done

#   return 0
# }

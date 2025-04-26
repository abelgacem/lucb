# purpose: buildah create an image that include the CLI: PODMAN, BUILDAH
# args: <BASE_IMAGE_SID>
luc_cimb_image_buildah_create()  {
  local lMSG_PURPOSE="buildah create an image that include the CLI: PODMAN, BUILDAH"  
  local lMSG_USAGE="$(luc_core_method_name_get) <BASE_IMAGE_SID>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lIMAGE_SRC_SID="$1"
  local lLABEL_KEY_IMAGE_01="$luc_EV_CIMB_LABEL_KEY_IMAGE_01"
  local lLABEL_KEY_IMAGE_CURRENT="$luc_EV_CIMB_LABEL_KEY_IMAGE_CURRENT"
  # local lOS_USER_SUDO="$luc_EV_CIMB_OS_USER_SUDO"
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
  lIMAGE_DST_FULLNAME="dev/podman/${lIMAGE_SRC_SNAME}:$lIMAGE_SRC_TAG"

  ###### DEFINE CONFIGURATION DATA
  lLABELS=" 
    ${lLABEL_KEY_IMAGE_01}=$lIMAGE_SRC_FULLNAME
    ${lLABEL_KEY_IMAGE_CURRENT}=$lIMAGE_DST_FULLNAME
  "
  lVOLUMES="$lFOLDER_LUC_HOST:$lFOLDER_LUC_CONTAINER:ro"

  ###### FORMAT CONFIGURATION DATA FOR BUILDAH
  [ ! -z "$lLABELS"  ] && lLIST_LABEL='';  for ITEM in $lLABELS;  do lLIST_LABEL+=" --label $ITEM";   done
  [ ! -z "$lVOLUMES" ] && lLIST_VOLUME=''; for ITEM in $lVOLUMES; do lLIST_VOLUME+=" --volume $ITEM"; done

  ###### INFO
  luc_core_echo "step" "collect datas and infos"

  luc_core_echo "debu" "image SRC : $lIMAGE_SRC_FULLNAME ($lIMAGE_SRC_SID) ($lIMAGE_SRC_SHELL)"
  luc_core_echo "debu" "image DST : $lIMAGE_DST_FULLNAME"
  luc_core_echo "debu" "lIMAGE_SRC_SNAME     : $lIMAGE_SRC_SNAME"
  luc_core_echo "debu" "lCONTAINER_TEMP_NAME     : $lCONTAINER_TEMP_NAME"
  luc_core_echo "debu" "lFILE_LUCSETUP_CONTAINER : $lFILE_LUCSETUP_CONTAINER"
  luc_core_echo "info" "volume mapping : $lLIST_VOLUME"
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
  lCLI=". \$LUCSETUP ; luc_core_os_package_provision podman buildah"
  luc_core_echo "debu" "container OPTIONS : $lOPTIONS"
  luc_core_echo "debu" "CLI               : $lCLI"
  ## ACTION
  lECHOVAL=$(luc_cimb_container_cli_run $lCONTAINER_TEMP_SID "$lCLI" "$lOPTIONS"); lRETVAL=$?
  [ ! 0 -eq "$lRETVAL"  ] && echo "$lECHOVAL" && return 1 # || echo "$lECHOVAL"
 
  ###### CHECK PROVISIONING ############################
  luc_core_echo "chec" "Podman and buildah are provisioned inside the container"
  luc_cimb_container_cli_run $lCONTAINER_TEMP_SID "podman --version ; buildah --version"
    
  
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
    

  # info
  # luc_core_echo "done" "created image $lIMAGE_DST_FULLNAME ($lIMAGE_DST_SID) from container $lCONTAINER_TEMP_NAME ($lCONTAINER_TEMP_SID)"
  return 0
}


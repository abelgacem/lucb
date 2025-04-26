# purpose: buildah create a base os image from a root os image
# args: <ROOT_IMAGE_SID>
luc_buildah_image_golden_create_from()  {
  local lMSG_PURPOSE="buildah create a base os image from a root os image"  
  local lMSG_USAGE="$(luc_core_method_name_get) <ROOT_IMAGE_SID>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lIMAGE_SRC_SID="$1"
  local lLABEL_KEY_SHELL="${luc_EV_BUILDAH_LABEL_KEY_SHELL}"
  local lLABEL_KEY_OSNAME="${luc_EV_BUILDAH_LABEL_KEY_OSNAME}"
  local lLABEL_KEY_IMAGE_00="${luc_EV_BUILDAH_LABEL_KEY_IMAGE_00}"
  local lLABEL_KEY_IMAGE_CURRENT="${luc_EV_BUILDAH_LABEL_KEY_IMAGE_CURRENT}"
  local lOS_USER_SUDO="${luc_EV_BUILDAH_OS_USER_SUDO}"
  local lFOLDER_LUC_HOST="${luc_EV_BUILDAH_LUC_CORE_HOME}"
  local lFOLDER_LUC_CONTAINER="/tmp/luc"
  local LUCSETUP="${lFOLDER_LUC_CONTAINER}/${luc_EV_BUILDAH_LUC_SRC_RELPATH}"  
  local lCONTAINER_TEMP_NAME="temp-$(luc_core_id_get 5)"
  local lENVARS lLABELS lVOLUMES lPORT lUSER lWKDIR
  local lLIST_ENVAR lLIST_LABEL lLIST_VOLUME
  local lOPTIONS

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lIMAGE_SRC_SID"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit image exists
  lECHOVAL=$(luc_buildah_image_check_exists  $lIMAGE_SRC_SID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # getorexit image ID
  lECHOVAL=$(luc_buildah_property_get --image  ${lIMAGE_SRC_SID} ID); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_ID="$lECHOVAL"

  # getorexit image NAME
  lECHOVAL=$(luc_buildah_property_get --image  ${lIMAGE_SRC_SID} SNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_SNAME="$lECHOVAL"

  # getorexit image FULLNAME
  lECHOVAL=$(luc_buildah_property_get --image  ${lIMAGE_SRC_SID} FULLNAME); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_FULLNAME="$lECHOVAL"

  # getorexit image TAG
  lECHOVAL=$(luc_buildah_property_get --image  ${lIMAGE_SRC_SID} TAG); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_TAG="$lECHOVAL"

  # getorexit image SHELL
  lECHOVAL=$(luc_buildah_property_get --image  ${lIMAGE_SRC_SID} SHELL); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lIMAGE_SRC_SHELL="$lECHOVAL"

  # define image fullname
  lIMAGE_DST_FULLNAME="dev/os/${lIMAGE_SRC_SNAME/linux/}:${lIMAGE_SRC_TAG}"

  ###### DEFINE CONFIGURATION ###########################
  lENVARS="LUCSETUP=$LUCSETUP OS_USER_SUDO=$lOS_USER_SUDO"
  lLABELS=" 
    ${lLABEL_KEY_IMAGE_00}=${lIMAGE_SRC_FULLNAME}
    ${lLABEL_KEY_IMAGE_CURRENT}=${lIMAGE_DST_FULLNAME}
    ${lLABEL_KEY_OSNAME}=${lIMAGE_SRC_SNAME}
    ${lLABEL_KEY_SHELL}=${lIMAGE_SRC_SHELL}
  "
  lUSER=" --user $lOS_USER_SUDO"
  lVOLUMES="$lFOLDER_LUC_HOST:$lFOLDER_LUC_CONTAINER:ro"
  lWKDIR=" --workingdir /home/$lOS_USER_SUDO"

  ###### FORMAT CONFIGURATION DATA #####################
  [ ! -z "$lENVARS"  ] && lLIST_ENVAR='';  for ITEM in $lENVARS;  do lLIST_ENVAR+=" --env $ITEM";     done
  [ ! -z "$lLABELS"  ] && lLIST_LABEL='';  for ITEM in $lLABELS;  do lLIST_LABEL+=" --label $ITEM";   done
  [ ! -z "$lVOLUMES" ] && lLIST_VOLUME=''; for ITEM in $lVOLUMES; do lLIST_VOLUME+=" --volume $ITEM"; done

  ###### INFO                       #################### 
  luc_core_echo "debu" "lIMAGE_SRC          : $lIMAGE_SRC_FULLNAME ($lIMAGE_SRC_SID) ($lIMAGE_SRC_SHELL)"
  luc_core_echo "debu" "lIMAGE_DST_FULLNAME : $lIMAGE_DST_FULLNAME"
  luc_core_echo "debu" "lCONTAINER_TEMP_NAME: $lCONTAINER_TEMP_NAME"
  luc_core_echo "debu" "LUCSETUP            : $LUCSETUP"
  luc_core_echo "info" "envar    : $lLIST_ENVAR"
  luc_core_echo "info" "label    : ${lLIST_LABEL:0:80} ..."
  luc_core_echo "info" "user     : $lUSER"
  luc_core_echo "info" "volume   : $lLIST_VOLUME"
  luc_core_echo "info" "wkdir    : $lWKDIR"

  ###### CREATE BUILDAH CONTAINER  ##################### 
  luc_core_echo "step" "create a temporary container with VOLUME"
  lECHOVAL=$(luc_buildah_container_create $lCONTAINER_TEMP_NAME $lIMAGE_SRC_SID $lLIST_VOLUME);lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 || echo "$lECHOVAL"    

  # getorexit container SID
  luc_core_echo "chec" "container exists and get temporary container SID"
  lECHOVAL=$(luc_buildah_sid_get --container $lCONTAINER_TEMP_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" &&  return 1 || lCONTAINER_TEMP_SID="$lECHOVAL"

  ###### PROVISION BUILDAH CONTAINER ################### 
  
  ###### CLI
  luc_core_echo "step" "run CLI in temporary container"
  lOPTIONS="--env LUCSETUP=$LUCSETUP"
  lCLI=". $LUCSETUP ; luc_core_os_package_upgrade"
  # lCLI='echo "user = $(id -un)"; ls -ial; echo -$LUCSETUP-; printenv'
  luc_core_echo "debu" "OPTIONS pass to container > $lOPTIONS"
  luc_core_echo "debu" "CLI to play in container  > $lCLI"
  lECHOVAL=$(luc_buildah_container_cli_run $lCONTAINER_TEMP_SID "$lCLI" "$lOPTIONS"); lRETVAL=$?
  [ ! 0 -eq "$lRETVAL"  ] && echo "$lECHOVAL" && return 1 # || echo "$lECHOVAL"
  
  ###### CLI
  luc_core_echo "step" "run CLI in temporary container"
  lOPTIONS="--env LUCSETUP=$LUCSETUP"
  lCLI=". $LUCSETUP ; luc_core_os_user_sudo_provision $lOS_USER_SUDO"
  luc_core_echo "debu" "OPTIONS pass to container > $lOPTIONS"
  luc_core_echo "debu" "CLI to play in container  > $lCLI"
  lECHOVAL=$(luc_buildah_container_cli_run $lCONTAINER_TEMP_SID "$lCLI" "$lOPTIONS"); lRETVAL=$?
  [ ! 0 -eq "$lRETVAL"  ] && echo "$lECHOVAL" && return 1 # || echo "$lECHOVAL"

  ###### CHECK PROVISIONING ############################
  luc_core_echo "chec" "USER is created inside the container"
  luc_buildah_container_cli_run $lCONTAINER_TEMP_SID "cat /etc/passwd | grep $lOS_USER_SUDO"

  ###### CONFIGURE CONTAINER ###########################
  luc_core_echo "step" "set container ENVARs, LABELs, USER and WORKDIR"
  buildah config ${lLIST_ENVAR} ${lLIST_LABEL} $lUSER $lWKDIR ${lCONTAINER_TEMP_SID}

  ###### CHECK CONGIGURATION ###########################

  luc_core_echo "chec" "LABELs values in container metadata"
  luc_buildah_property_get --container $lCONTAINER_TEMP_SID LABEL | jq .
  
  luc_core_echo "chec" "ENVARs value in container metadata"
  luc_buildah_property_get --container $lCONTAINER_TEMP_SID ENVAR | jq .

  luc_core_echo "chec" "ENVARs value inside the container"
  luc_buildah_container_cli_run $lCONTAINER_TEMP_SID "env"

  luc_core_echo "chec" "USER value in container metadata"
  luc_buildah_property_get --container $lCONTAINER_TEMP_SID USER

  luc_core_echo "chec" "USER inside the container"
  luc_buildah_container_cli_run $lCONTAINER_TEMP_SID "id -un"

  luc_core_echo "chec" "WORKINGDIR inside the container"
  luc_buildah_container_cli_run $lCONTAINER_TEMP_SID "pwd"
  
  ###### COMMIT CONTAINER TO IMAGE ##################### 
  luc_core_echo "step" "commit the container to destsination image: $lIMAGE_DST_FULLNAME"
  lECHOVAL=$(luc_buildah_image_create $lIMAGE_DST_FULLNAME $lCONTAINER_TEMP_SID 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" || echo "$lECHOVAL"

  # getorexit image SID
  lECHOVAL=$(luc_buildah_sid_get --image $lIMAGE_DST_FULLNAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" &&  return 1 || lIMAGE_DST_SID="$lECHOVAL"

  ###### CLEAN OBJECTS ################################# 
  luc_core_echo "step" "delete temporary container"
  lECHOVAL=$(luc_buildah_container_delete $lCONTAINER_TEMP_SID); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" || echo "$lECHOVAL"
    
  # info
  luc_core_echo "done" "created image $lIMAGE_DST_FULLNAME ($lIMAGE_DST_SID) from container $lCONTAINER_TEMP_NAME ($lCONTAINER_TEMP_SID)"
  return 0
}

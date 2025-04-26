
# purpose: install the CLI
# prereq: User that launch this CLI is sudo
# args: NONE
luc_core_install() {
  local lMSG_PURPOSE="install the CLI: LUC"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lFOLDER_LUC_HOME="$luc_EV_LUC_CORE_HOME"
  local lFILE_LUC_RC="$luc_EV_LUC_CORE_FILE_RC"
  local lFILE_LUC_SETUP="${lFOLDER_LUC_HOME}/${luc_EV_LUC_CORE_BOOT_RELPATH}"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  ###### PREREQUISIT
  # checkorexit folder exists
  lECHOVAL=$(luc_core_check_folder_exits $lFOLDER_LUC_HOME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1

  # checkorexit file exists
  lECHOVAL=$(luc_core_check_file_exits $lFILE_LUC_SETUP); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 1

  ###### INFO  ##################
  luc_core_echo "debug" "lFILE_LUC_SETUP=$lFILE_LUC_SETUP"
  luc_core_echo "debug" "lFILE_LUC_RC=$lFILE_LUC_RC"

  ###### ACION: PROVISION FILE > RC  ################## 
  luc_core_echo "step" "provision rc file : $lFILE_LUC_RC"
  echo "export LUCSETP=$lFILE_LUC_SETUP" | sudo tee $lFILE_LUC_RC > /dev/null
  echo '
  alias srcluc=". $LUCSETP 1>/dev/null"
  alias srclucv=". $LUCSETP"
  srcluc
  ' | sudo tee -a $lFILE_LUC_RC > /dev/null

  ###### RETURN 
  luc_core_echo "info" "ssh disconnect and reconnect for changes to apply"
  return 0
}

# purpose: remote copy the LUC folder in a folder on a VM or container
# prereq: The VM/container is SSH reachable
# prereq: The user that launche this CLI can ssh connect to the VM/container
# args: <VM_NAME> <FOLDER_DST>
luc_core_install_tmp() {
  local lMSG_PURPOSE="install the CLI: LUC"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <FOLDER_DST>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u /tmp/luc" 
  local lFOLDER_LUC_HOME_SRC="$luc_EV_LUC_CORE_HOME"
  local lVM_NAME="$1"
  local lFOLDER_LUC_HOME_DST="$2"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  ###### PREREQUISIT
  luc_core_echo "chec" "args are provided"
  [ -z "$lVM_NAME"             ] ||
  [ -z "$lFOLDER_LUC_HOME_DST" ] ||
  [ "--help" == "$1"           ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  luc_core_echo "chec" "SRC folder exists"
  lECHOVAL=$(luc_core_check_folder_exits $lFOLDER_LUC_HOME_SRC); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1

  ###### INFO  ##################
  luc_core_echo "debu" "lFOLDER_LUC_HOME_SRC: $lFOLDER_LUC_HOME_SRC"
  luc_core_echo "debu" "lFOLDER_LUC_HOME_DST: $lVM_NAME > $lFOLDER_LUC_HOME_DST"

  ###### ACION: REMOTE COPY FOLDER  ################## 
  luc_core_echo "step" "provision folder : $lFOLDER_LUC_HOME_SRC"
  # note: --delete => files at dest that not exists in src
  # note: ending / => the folder content is copied not the folder
  rsync -av --delete --quiet $lFOLDER_LUC_HOME_SRC/ ${lVM_NAME}:$lFOLDER_LUC_HOME_DST/

  ###### CHECK PROVISIONING ##################### 
  luc_core_echo "chec" "LUC folder exists"
  ssh ${lVM_NAME} "ls $lFOLDER_LUC_HOME_DST" > /dev/null  || return 1

  ###### RETURN 
  return 0
}
luc_core_uninstall() {
  local lMSG_PURPOSE="uninstall the CLI: LUC"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lFILE_LUC_RC="$luc_EV_LUC_CORE_FILE_RC"
  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  # delete rc file
  luc_core_echo "step" "deprovision rc file : $lFILE_LUC_RC"
  sudo rm -f $lFILE_LUC_RC

  # end
  return 0
}



# purpose: provision git credential-askpass helper in a VM or container
# args : NONE
luc_git_askpass_provision() {
  local lMSG_PURPOSE="provision git credential-askpass helper in a VM or container"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lFILE_ASKPASS="/home/$(id -un)/.git-askpass"  # \$ => sudo evaluate var on remote
  local lFILE_GIT_RC="$luc_EV_GIT_FILE_RC"
  local lFILE_STRING_ASKPASS='echo $GIT_TOKEN'
  local lFILE_STRING_GIT_RC='echo $GIT_TOKEN'

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### INFO  ##################
  luc_core_echo "debug" "lFILE_ASKPASS : $lFILE_ASKPASS"
  luc_core_echo "debug" "lFILE_GIT_RC  : $lFILE_GIT_RC"
  
  ###### ACION: PROVISION FILE > RC ################## 
  luc_core_echo "step" "provision rc file : $lFILE_GIT_RC"
  echo 'export GIT_ASKPASS=$HOME/.git-askpass' | sudo tee $lFILE_GIT_RC > /dev/null

  ###### ACION: PROVISION FILE > GIT ASKPASS ######### 
  luc_core_echo "step" "provision git askpass file: $lFILE_ASKPASS"
  echo "$lFILE_STRING_ASKPASS" | sed 's/^[[:space:]]*//' | tee "$lFILE_ASKPASS" > /dev/null
  chmod +x $lFILE_ASKPASS

  ###### RETURN 
  luc_core_echo "info" "ssh disconnect and reconnect for changes to apply"
  return 0
}

luc_git_askpass_provision_remote() {
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <GIT_ACCESS_TOKEN>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u gdgdknkjfnnnbnbn" 
  local lFILE_ASKPASS="/home/\$(id -un)/.git-askpass"  # \$ => sudo evaluate var on remote
  local lFILE_GIT_RC='/etc/profile.d/git.rc.sh'
  local lFILE_STRING_ASKPASS='echo $GIT_TOKEN'
  local lFILE_STRING_GIT_RC='echo $GIT_TOKEN'
  local lVM_NAME="$1"  # as define in .ssh/config.d/xx

  # purpose
  luc_core_echo "purp" "provision git credential-askpass helper in a VM"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"              ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit VM is reachable
  luc_core_echo "info" "check VM is ssh reachable"
  lECHOVAL=$(ssh -v -o BatchMode=yes -o ConnectTimeout=3 $lVM_NAME true >/dev/null 2>&1) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "VM is not reachable: $lVM_NAME" && return 2
  
  ###### INFO  ##################
  # remote create git-askpass file
  luc_core_echo "step" "provision git askpass file: $lFILE_ASKPASS"
  echo "$lFILE_STRING_ASKPASS" | sed 's/^[[:space:]]*//' | ssh $lVM_NAME "[ ! -f $lFILE_ASKPASS ] && tee $lFILE_ASKPASS > /dev/null"
  ssh $lVM_NAME "[ -f $lFILE_ASKPASS ] && [ ! -x $lFILE_ASKPASS ] && chmod +x $lFILE_ASKPASS"

  # remote create GIT rc file
  luc_core_echo "step" "provision rc file : $lFILE_GIT_RC"
  echo 'export GIT_ASKPASS=$HOME/.git-askpass'           | ssh $lVM_NAME "[ ! -f $lFILE_GIT_RC ]  && sudo tee $lFILE_GIT_RC > /dev/null"
  #
  return 0
}

# purpose: git clone a repo for the first time
# prerequisit: the gitaskpass credential helper is provisioned
# prerequisit: the VM is reachable
# args : <VM_NAME> <GIT_URL> <ABSOLUTE_PATH> <GIT_ACCESS_TOKEN>
luc_git_clone() {
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <GIT_URL> <ABSOLUTE_PATH> <GIT_ACCESS_TOKEN>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u https://github.com/abelgacem/luc-bash.git /tmp gdgdknkjfnnnbnbn" 
  local lVM_NAME="$1"
  local lGIT_URL="$2"
  local lABSOLUTE_PATH="$3"
  local lGIT_ACCESS_TOKEN="$4"

  # checkorexit args are provided
  [ -z "$lVM_NAME"          ] ||
  [ -z "$lGIT_URL" ] ||
  [ -z "$lABSOLUTE_PATH"    ] ||
  [ -z "$lGIT_ACCESS_TOKEN" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "git clone a repo for the first time" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit args are provided
  ssh $lVM_NAME "[ ! -d $lABSOLUTE_PATH ] && . /etc/profile && export GIT_TOKEN=$lGIT_ACCESS_TOKEN && git -C $lGIT_ACCESS_TOKEN clone $lGIT_URL" || luc_core_echo "warn" "not cloned git repo" 
  # ssh $lOVH_VM "[ ! -d $lVM_FOLDER_GIT_ROOT/$lLUC_GIT_FOLDER_NAME ] && . /etc/profile && export GIT_TOKEN=$lGIT_ACCESS_TOKEN && git -C $lVM_FOLDER_GIT_ROOT clone $lLUC_GIT_URL" || luc_core_echo "warn" "not cloned git repo" 

  # 
  return 0

}


# Todo
# store the token securely (crypted)
# retrieve it dynamically
# shortcut
luc_ovh_vps_provision_podman() { luc_ovh_vps_podman_provision $@; }
luc_ovh_vps_provision_luc()    { luc_ovh_vps_luc_provision $@; }

# # purpose: prepare an OVH VPS to manage podman container images
# # args: <VPS_NAME>
# luc_ovh_vps_podman_provision() {
#   local lMSG_USAGE="$(luc_core_method_name_get) <VPS_NAME>"  
#   local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u" 
#   local lOVH_VM="$1"
#   local lPM_TOOL

#   # purpose
#   luc_core_echo "purp" "prepare an OVH VPS to manage podman and buildah containers and container images"

#   # checkorexit args are provided
#   [ -z "$lOVH_VM"     ] ||
#   [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

#   # checkorexists VM is reachable
#   luc_core_echo "chec" "VM is reachable"
#   lECHOVAL=$(luc_ovh_vm_check_is_reachable $lOVH_VM); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 2

#   # getorexit VM USER
#   lECHOVAL=$(luc_ovh_vm_property_get $lOVH_VM USER); lRETVAL=$?
#   [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 3 || lVM_USER=$lECHOVAL
  
#   # checkorexit VM:USER is managed
#   luc_core_echo "chec" "User is manage"
#   [ "debian" == "$lVM_USER" ] && lPM_TOOL="apt"
#   [ "fedora" == "$lVM_USER" ] && lPM_TOOL="dnf"
#   [ "rocky"  == "$lVM_USER" ] && lPM_TOOL="dnf"
#   [ "ubuntu" == "$lVM_USER" ] && lPM_TOOL="apt"
#   [ ! -n "$lPM_TOOL" ] && luc_core_echo "warn" "USER not managed: $lVM_USER" && return 4

#   # provision podman
#   luc_core_echo "step" "provision podman"
#   ssh $lOVH_VM "sudo $lPM_TOOL -y install podman 1> /dev/null 2> /dev/null"  || {
#     luc_core_echo 'warn' 'failed to provision podman'
#     command -v osascript 1>/dev/null && osascript  -e 'say "failed to provision podman" using "Karen"'
#   } 
# }

# purpose: prepare an OVH VPS to manage Jekyll site
# args: <VPS_NAME>
luc_ovh_vps_jekyll_provision() {
  local lMSG_USAGE="$(luc_core_method_name_get) <VPS_NAME>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u" 
  local lOVH_VM="$1"
  # \$() mean the cli is evaluated on remote - works only when used with ssh
  local lVM_FOLDER_WKSPC="/home/\$(id -un)/wkspc" # \$ is evaluated on remote
  # \${} mean the var is evaluated on remote - it may be a remote envar -  - works only when used with ssh
  local lJEKYLL_FOLDER_ROOT="\${FOLDER_GIT_ROOT}/$luc_EV_JEKYLL_FOLDER_NAME"
  local lLUCSETUP="\${FOLDER_GIT_ROOT}/$luc_EV_LUC_CORE_FOLDER_NAME/$luc_EV_LUC_CORE_BOOT_RELPATH"

  # purpose
  luc_core_echo "purp" "prepare an OVH VPS to manage Jekyll site"

  # checkorexit args are provided
  [ -z "$lOVH_VM"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexists VM is reachable
  luc_core_echo "chec" "VM is reachable"
  lECHOVAL=$(luc_ovh_vm_check_is_reachable $lOVH_VM); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 2

  # checkorexit LUC tool is installed
  luc_core_echo "chec" "tool : LUC is installed"
  lECHOVAL=$(ssh $lOVH_VM ". /etc/profile && ls $lLUCSETUP 2>/dev/null"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo 'warn' 'LUC is not installed' && return 3
  
  # checkorexit podman tool is installed
  luc_core_echo "chec" "tool : podman is installed"
  lECHOVAL=$(ssh $lOVH_VM "which podman") lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "caut" "podman is not installed. Provision it now" && {
    lECHOVAL=$(ssh $lOVH_VM ". /etc/profile && luc_core_os_package_provision podman") lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 4
  }

  # check root jekyll folder exist
  luc_core_echo "chec" "root jekyll folder exist"
  lECHOVAL=$(ssh $lOVH_VM ". /etc/profile && ls $lJEKYLL_FOLDER_ROOT 2>/dev/null"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "caut" "remote folder not exists : $lJEKYLL_FOLDER_ROOT. Create it now" && {
    lECHOVAL=$(ssh $lOVH_VM ". /etc/profile && mkdir -p $lJEKYLL_FOLDER_ROOT") lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "failed to create remote folder $lJEKYLL_FOLDER_ROOT" && return 5
  }

}

# purpose: prepare an OVH VPS to CLI: luc
# args: <VPS_NAME> <GIT_ACCESS_TOKEN>
luc_ovh_vps_luc_provision() {
  local lMSG_USAGE="$(luc_core_method_name_get) <VPS_NAME> <GIT_ACCESS_TOKEN>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u" 
  local lOVH_VM="$1"
  local lGIT_ACCESS_TOKEN="$2"
  local lLOCAL_GITCONFIG="$HOME/.gitconfig"
  local lVM_FILE_RC='/etc/profile.d/luc.rc.ovh.sh'
  local lTEMPFILE="/tmp/temp-$(luc_core_id_get 5)"
  local lVM_HOME_USER="/home/\$(id -un)" # \$ is evaluated on remote when used with ssh - not work with scp
  local lVM_FOLDER_WKSPC="$lVM_HOME_USER/wkspc" 
  local lVM_FILE_GITCONFIG="$lVM_HOME_USER/.gitconfig"
  local lVM_FOLDER_GIT_ROOT="$lVM_FOLDER_WKSPC/git" 
  local lLUC_GIT_URL=$luc_EV_LUC_CORE_GIT_URL
  local lLUC_FOLDER_NAME=$luc_EV_LUC_CORE_FOLDER_NAME
  local lPM_TOOL
  local lFILE_STRING="
    # define envar
    shopt -s expand_aliases # make alias available just after it definition in the same script
    export FOLDER_GIT_ROOT="$lVM_FOLDER_GIT_ROOT"
    export LUCSETUP="\$FOLDER_GIT_ROOT/luc-bash/src/setup/srclib"
    alias srcluc='echo \"file $lVM_FILE_RC sourced (verbose=scrlucv)\" && . \$LUCSETUP 1>/dev/null'
    alias srclucv='. \$LUCSETUP'
    # source CLI:luc
    srcluc
    "

  # purpose
  luc_core_echo "purp" "prepare an OVH VPS to CLI: luc"

  # checkorexit args are provided
  [ -z "$lOVH_VM"           ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexists VM is reachable
  luc_core_echo "chec" "VM is reachable"
  lECHOVAL=$(luc_ovh_vm_check_is_reachable $lOVH_VM); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 2

  # getorexit VM USER
  luc_core_echo "step" "get VM : user"
  lECHOVAL=$(luc_ovh_vm_property_get $lOVH_VM USER); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 3 || lVM_USER=$lECHOVAL
  
  # checkorexit VM:USER is managed
  luc_core_echo "chec" "user is managed"
  [ "debian" == "$lVM_USER" ] && lPM_TOOL="apt"
  [ "fedora" == "$lVM_USER" ] && lPM_TOOL="dnf"
  [ "rocky"  == "$lVM_USER" ] && lPM_TOOL="dnf"
  [ "ubuntu" == "$lVM_USER" ] && lPM_TOOL="apt"
  [ ! -n "$lPM_TOOL" ] && luc_core_echo "warn" "USER not managed: $lVM_USER" && return 4

  # info
  luc_core_echo "info" "conf > VM reachable : $lOVH_VM"
  luc_core_echo "info" "conf > VM > USER    : $lVM_USER"
  luc_core_echo "info" "conf > VM > root git folder : $lVM_FOLDER_GIT_ROOT"
  luc_core_echo "info" "conf > VM > PM tool  : $lPM_TOOL"

  # update os
  luc_core_echo "step" "update os"
  ssh $lOVH_VM "sudo $lPM_TOOL -y update 1> /dev/null 2> /dev/null"  || {
    luc_core_echo 'warn' 'pbs updating os'
    command -v osascript 1>/dev/null && osascript -e 'say "failed to update the operating system" using "Karen"'
  } 

  # upgrade os
  luc_core_echo "step" "upgrade os"
  ssh $lOVH_VM "sudo $lPM_TOOL -y upgrade 1> /dev/null 2> /dev/null"  || {
    luc_core_echo 'warn' 'pbs upgrading os'
    command -v osascript 1>/dev/null  && osascript -e 'say "failed to upgrade the operating system" using "Karen"'
  }
      
  # install git tool
  luc_core_echo "step" "install git tool"
  ssh $lOVH_VM "! command -v git 1>/dev/null &&  sudo $lPM_TOOL -y install git"

  # provision git credential-askpass helper
  luc_core_echo "step" "provision git credential-askpass helper"
  lECHOVAL=$(luc_git_askpass_provision $lOVH_VM ); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "not set git askpass credential" 

  # create root git folder
  luc_core_echo "step" "create root git folder"
  ssh $lOVH_VM "mkdir -p $lVM_FOLDER_GIT_ROOT"

  # copy local .gitconfig file
  luc_core_echo "step" "copy local ~/.gitconfig file"
  [ -f "$lLOCAL_GITCONFIG" ] &&  cat $lLOCAL_GITCONFIG | ssh $lOVH_VM "[ ! -f $lVM_FILE_GITCONFIG ] && tee $lVM_FILE_GITCONFIG > /dev/null"   

  # clone git repo 
  luc_core_echo "step" "clone git repo"
  ssh $lOVH_VM "[ ! -d $lVM_FOLDER_GIT_ROOT/$lLUC_FOLDER_NAME ] && . /etc/profile && export GIT_TOKEN=$lGIT_ACCESS_TOKEN && git -C $lVM_FOLDER_GIT_ROOT clone $lLUC_GIT_URL"

  # create LUC rc file
  luc_core_echo "step" "create LUC rc file"
  echo "$lFILE_STRING" | sed 's/^[[:space:]]*//' | ssh $lOVH_VM "sudo tee $lVM_FILE_RC > /dev/null"
}

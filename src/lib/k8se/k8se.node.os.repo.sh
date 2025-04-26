luc_k8se_crio_os_repo_provision() {
  lpurpose="provision CRIO dnf|apt repository on all Nodes:OS of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION PROVISION CRIO DNF|APT PACKAGE REPOSITOTY
  for lVM_NAME in $lNODE_LIST; do
    lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
    luc_core_echo "doin" "node: $lVM_NAME"
    case $lVM_DISTRO in
        "rocky"|"alma"|"fedora") lCLI="luc_k8se_crio_os_rocky_repo_provision" ;;
        "debian"|"ubuntu")       lCLI="luc_k8se_crio_os_ubuntu_repo_provision" ;;
        *) continue ;;    
    esac 
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "bash -l -c $lCLI" 2>&1); lRETVAL=$?
    [ ! -z "$lECHOVAL" ] && echo "$lECHOVAL"
   done
  ###### RETURN
  return 0
}

luc_k8se_k8s_os_repo_provision() {
  lpurpose="provision K8s dnf|apt repository on all Nodes:OS of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"
   
  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION PROVISION CRIO DNF|APT PACKAGE REPOSITOTY
  for lVM_NAME in $lNODE_LIST; do
    lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
    luc_core_echo "doin" "node: $lVM_NAME"
    case $lVM_DISTRO in
        "rocky"|"alma"|"fedora") lCLI="luc_k8se_k8s_os_rocky_repo_provision" ;;
        "debian"|"ubuntu")       lCLI="luc_k8se_k8s_os_ubuntu_repo_provision" ;;
    esac 
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "bash -l -c $lCLI" 2>&1); lRETVAL=$?
    [ ! -z "$lECHOVAL" ] && echo "$lECHOVAL"
  done
  ###### RETURN
  return 0
} # function

luc_k8se_k8s_os_ubuntu_repo_provision() {
  lpurpose="provision K8s dnf|apt repository on alma|rocky|fedora"
  largs="<NONE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lREPO_NAME="${luc_EV_K8SE_K8S_OS_PACKAGE_REPOSITORY}"
  local lTOOL_VERSION="v${luc_EV_K8SE_K8s_VERSION}"
  local lFILE_REPO="/etc/apt/sources.list.d/${lREPO_NAME}.list"
  local lFILE_GPGKEY="/etc/apt/keyrings/${lREPO_NAME}-apt-keyring.gpg"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  # checkorexit cli exists
  lCLI='curl';
  lECHOVAL=$(luc_core_check_cli_is_installed $lCLI 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2
  # check file not exists - else mean repo conf already download => caution only
  lECHOVAL=$(luc_core_check_file_exits "$lFILE_REPO"); lRETVAL=$?
  [ 0 -eq "$lRETVAL" ] && luc_core_echo "caut" "$lECHOVAL"

  ###### ACTION
  # download gpg key into os file
  curl -fsSL https://pkgs.k8s.io/core:/stable:/${lTOOL_VERSION}/deb/Release.key | gpg --dearmor    | sudo tee $lFILE_GPGKEY > /dev/null
  # create repo file conf
  echo "deb [signed-by=${lFILE_GPGKEY}] https://pkgs.k8s.io/core:/stable:/${lTOOL_VERSION}/deb/ /" | sudo tee $lFILE_REPO   > /dev/null
  # update packages list
  sudo apt update -qq -y &> /dev/null

  ###### Final RETURN when everything is OK
  return 0
} # function

luc_k8se_k8s_os_rocky_repo_provision() {
  lpurpose="provision K8s dnf|apt repository on alma|rocky|fedora"
  largs="<NONE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lREPO_NAME="${luc_EV_K8SE_K8S_OS_PACKAGE_REPOSITORY}"
  local lTOOL_VERSION="v${luc_EV_K8SE_K8s_VERSION}"
  local lFILE_REPO="/etc/yum.repos.d/${lREPO_NAME}.repo"

  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  # checkorexit file not exists - else mean repo conf already download
  lECHOVAL=$(luc_core_check_file_exits "$lFILE_REPO"); lRETVAL=$?
  [ 0 -eq "$lRETVAL" ] && luc_core_echo "caut" "$lECHOVAL"

  ###### ACTION CREATE REPO FILE
  echo -e "
  [$lREPO_NAME]
  name=$lREPO_NAME
  enabled=1
  gpgcheck=1
  baseurl=https://pkgs.k8s.io/core:/stable:/${lTOOL_VERSION}/rpm/
  gpgkey=https://pkgs.k8s.io/core:/stable:/${lTOOL_VERSION}/rpm/repodata/repomd.xml.key
  " |  sed 's/^[ \t]*//' | sed '/^$/d' | sudo tee $lFILE_REPO > /dev/null

  ###### ACTION UPDATE OS PACKAGE
  sudo dnf update -qq -y &> /dev/null

  ###### Final RETURN when everything is OK
  return 0
} # function

luc_k8se_repo_clean() {
  lpurpose="delete all k8se repository on all nodes"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION DELETE K8SE DNF|APT PACKAGE REPOSITOTY
  lCLI="sudo rm -rf /etc/yum.repos.d/k8se*"
  luc_core_vm_all_cli_run "$lCLI"
  lCLI="sudo rm -rf /etc/apt/sources.list.d/k8se*"
  luc_core_vm_all_cli_run "$lCLI"
  lCLI="sudo rm -rf /etc/apt/keyrings/k8se*"
  luc_core_vm_all_cli_run "$lCLI"

  ###### RETURN
  return 0
}


luc_k8se_crio_service_start() {
  lpurpose="start service crio"
  largs="<NONE>"
  local lDISTRO=$(luc_core_os_name_get)
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lSERVICE_NAME="$luc_EV_K8SE_OS_SERVICE_CRIO" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION start service 
  lECHOVAL=$(luc_core_service_start $lSERVICE_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1 

  ##### ACTION Enable Service after reboot
  lECHOVAL=$(luc_core_service_enable $lSERVICE_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1 

  ##### RETURN
  return 0

} # function


luc_k8se_crio_os_ubuntu_repo_provision() {
  lpurpose="provision CRIO dnf|apt repository on ubuntu|debian"
  largs="<NONE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lREPO_NAME="${luc_EV_K8SE_CRIO_OS_PACKAGE_REPOSITORY}"
  local lTOOL_VERSION="v${luc_EV_K8SE_CR_VERSION}"
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
  curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/${lTOOL_VERSION}/deb/Release.key | gpg --dearmor    | sudo tee $lFILE_GPGKEY > /dev/null
  # create repo file conf
  echo "deb [signed-by=${lFILE_GPGKEY}] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/${lTOOL_VERSION}/deb/ /" | sudo tee $lFILE_REPO   > /dev/null
  # # update packages list
  sudo apt update -qq -y &> /dev/null

  ###### Final RETURN when everything is OK
  return 0
}

luc_k8se_crio_os_rocky_repo_provision() {
  lpurpose="provision CRIO dnf repository on alma|rocky|fedora"
  largs="<NONE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lREPO_NAME="${luc_EV_K8SE_CRIO_OS_PACKAGE_REPOSITORY}"
  local lTOOL_VERSION="v${luc_EV_K8SE_CR_VERSION}"
  local lFILE_REPO="/etc/yum.repos.d/${lREPO_NAME}.repo"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  # checkorexit file not exists - else mean repo conf already download
  lECHOVAL=$(luc_core_check_file_exits "$lFILE_REPO"); lRETVAL=$?
  [ 0 -eq "$lRETVAL" ] && luc_core_echo "caut" "$lECHOVAL"

  ###### ACTION
  # create repo file conf
  echo -e "
  [${lREPO_NAME}]
  name=${lREPO_NAME}
  enabled=1
  gpgcheck=1
  baseurl=https://download.opensuse.org/repositories/isv:/cri-o:/stable:/${lTOOL_VERSION}/rpm/
  gpgkey=https://download.opensuse.org/repositories/isv:/cri-o:/stable:/${lTOOL_VERSION}/rpm/repodata/repomd.xml.key
  " |  sed 's/^[ \t]*//' | sed '/^$/d' | sudo tee $lFILE_REPO > /dev/null

  # update packages list
  sudo dnf update -qq -y &> /dev/null

  ###### Final RETURN when everything is OK
  return 0
}



#### CRI-O conf
# export luc_EV_CRIO_CONFILE="/etc/crio/crio.conf"
# [crio.runtime]
# conmon_cgroup = "pod"
# cgroup_manager = "cgroupfs"
# [crio.image]
# pause_image="registry.k8s.io/pause:3.10"


# /etc/crio/crio.conf or 
# replace a drop-in configuration in /etc/crio/crio.conf.d/02-cgroup-manager.conf, for example:
# [crio.runtime]
# conmon_cgroup = "pod"
# cgroup_manager = "cgroupfs"
# For CRI-O, the CRI socket is /var/run/crio/crio.sock by default.
#[crio.image]
# pause_image="registry.k8s.io/pause:3.10"

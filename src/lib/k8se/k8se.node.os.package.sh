# prereq: package repository is installed
luc_k8se_crio_os_package_provision() {
  lpurpose="remote provision the container runtime on a set of NODEs/VMs of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"
  local lPAKAGE_SELINUX="container-selinux" 
  local lPAKAGE_CRIO="cri-o" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### CHOICE
  for lVM_NAME in $lNODE_LIST; do
    luc_core_echo "doin" "node: $lVM_NAME"
    lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
    case $lVM_DISTRO in
        "alma"|"rocky"|"fedora") lLIST_OS_PACKAGE="$lPAKAGE_CRIO $lPAKAGE_SELINUX" ;;
        "debian"|"ubuntu")       lLIST_OS_PACKAGE="$lPAKAGE_CRIO" ;;
        *) continue ;;    
    esac 
  ###### ACTION UNLOCK VERSION
    luc_core_echo "info" "unlock version"
    case $lVM_DISTRO in
      "debian"|"ubuntu")
        lCLI="sudo apt-mark unhold $lLIST_OS_PACKAGE"
        lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
        [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2
        ;;
      "alma"|"rocky"|"fedora")
        lCLI="sudo dnf versionlock add $lLIST_OS_PACKAGE"
        lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
        [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 3
        ;;
    esac 
    ##### ACTION PROVISION PACKAGES
    luc_core_echo "info" "provision > $lLIST_OS_PACKAGE"
    lCLI="luc_core_os_package_provision $lLIST_OS_PACKAGE"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2
    ###### ACTION LOCK VERSION
    luc_core_echo "info" "lock version"
    case $lVM_DISTRO in
      "debian"|"ubuntu")
        lCLI="sudo apt-mark hold $lLIST_OS_PACKAGE"
        lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
        [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 5
        ;;
      "alma"|"rocky"|"fedora")
        lCLI="sudo dnf versionlock delete $lLIST_OS_PACKAGE"
        lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
        [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2
        ;;
    esac 
  done
  
  ###### RETURN
  return 0
}
# prereq: package repository is installed
luc_k8se_k8s_os_package_provision() {
  lpurpose="remote provision some k8s CLI and/or components on a set of Nodes/VMs of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"
  local lLIST_OS_PACKAGE="kubeadm kubelet" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### CHOICE
  for lVM_NAME in $lNODE_LIST; do
    luc_core_echo "doin" "node: $lVM_NAME"
    lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
    case $lVM_DISTRO in
        "alma"|"rocky"|"fedora") lLIST_OS_PACKAGE="$lLIST_OS_PACKAGE" ;;
        "debian"|"ubuntu")       lLIST_OS_PACKAGE="$lLIST_OS_PACKAGE" ;;
        *) continue ;;    
    esac 
  ###### ACTION UNLOCK VERSION
  luc_core_echo "info" "unlock version"
  case $lVM_DISTRO in
    "debian"|"ubuntu")
      lCLI="sudo apt-mark unhold $lLIST_OS_PACKAGE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2
      ;;
    "alma"|"rocky"|"fedora")
      lCLI="sudo dnf versionlock add $lLIST_OS_PACKAGE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 3
      ;;
  esac 
  ###### ACTION PROVISION
    luc_core_echo "info" "provision > $lLIST_OS_PACKAGE"
    lCLI="luc_core_os_package_provision $lLIST_OS_PACKAGE"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 4
  ###### ACTION LOCK VERSION
  luc_core_echo "info" "lock version"
  case $lVM_DISTRO in
    "debian"|"ubuntu")
      lCLI="sudo apt-mark hold $lLIST_OS_PACKAGE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 5
      ;;
    "alma"|"rocky"|"fedora")
      lCLI="sudo dnf versionlock delete $lLIST_OS_PACKAGE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2
      ;;
  esac 

  done
  ###### RETURN
  return 0
}
# prereq: package repository is installed
luc_k8se_kubectl_os_package_provision() {
  lpurpose="remote provision the CLI:kubectl on a set of NODEs of a cluster"
  largs="<NODE_CPLANE>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) <NODE_LIST>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"
  local lLIST_OS_PACKAGE="kubectl" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### CHOICE
  for lVM_NAME in $lNODE_LIST; do
    luc_core_echo "doin" "node: $lVM_NAME"
    lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
    case $lVM_DISTRO in
        "alma"|"rocky"|"fedora") lLIST_OS_PACKAGE="$lLIST_OS_PACKAGE" ;;
        "debian"|"ubuntu")       lLIST_OS_PACKAGE="$lLIST_OS_PACKAGE" ;;
        *) continue ;;    
    esac 
  ###### ACTION UNLOCK VERSION
  luc_core_echo "info" "unlock version"
  case $lVM_DISTRO in
    "debian"|"ubuntu")
      lCLI="sudo apt-mark unhold $lLIST_OS_PACKAGE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2
      ;;
    "alma"|"rocky"|"fedora")
      lCLI="sudo dnf versionlock add $lLIST_OS_PACKAGE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 3
      ;;
  esac 
  ###### ACTION PROVISION
    luc_core_echo "info" "provision > $lLIST_OS_PACKAGE"
    lCLI="luc_core_os_package_provision $lLIST_OS_PACKAGE"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 4
  ###### ACTION LOCK VERSION
  luc_core_echo "info" "lock version"
  case $lVM_DISTRO in
    "debian"|"ubuntu")
      lCLI="sudo apt-mark hold $lLIST_OS_PACKAGE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 5
      ;;
    "alma"|"rocky"|"fedora")
      lCLI="sudo dnf versionlock delete $lLIST_OS_PACKAGE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2
      ;;
  esac 

  done
  ###### RETURN
  return 0
}

luc_k8se_nodes_os_package_provision() {
  lpurpose="update and upgrade all Nodes:OS of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"
  local lVM_DISTRO

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION PROVISION NEEDED OR MISSING STANDARD OS PACKAGES
  for lVM_NAME in $lNODE_LIST; do
    lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
    case $lVM_DISTRO in
        "alma")   lLIST_OS_PACKAGE="dnf-utils python3-dnf-plugin-versionlock" ;  lREASON="provision CLI needs-restarting versionlock"  ;;
        "debian") lLIST_OS_PACKAGE="rsync procps gnupg" ;                        lREASON="provision CLI rsync, syctl, gpg" ;;
        "rocky")   lLIST_OS_PACKAGE="python3-dnf-plugin-versionlock" ;           lREASON="provision CLI versionlock"  ;;
        *) continue ;;    
    esac 
    luc_core_echo "doin" "node: $lVM_NAME > $lREASON"
    lECHOVAL=$(luc_core_vm_os_package_provision "$lVM_NAME" "$lLIST_OS_PACKAGE"); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1
  done
  ###### RETURN
  return 0

}
luc_k8se_nodes_os_upgrade() {
  lpurpose="update and upgrade all Nodes:OS of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"
  local lVM_DISTRO

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # ###### DISPLAY INFO
  # luc_core_echo "chec" "os:distribution"
  # luc_k8se_nodes_os_ditro_display $lNODE_LIST
  ###### DISPLAY INFO
  # luc_core_echo "chec" "os:kernel:version before update"
  # luc_k8se_nodes_os_kernel_version_display $lNODE_LIST
  ###### ACTION UPDATE AND UPGRADE OS
  for lVM_NAME in $lNODE_LIST; do
  lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
  luc_core_echo "doin" "node: $lVM_NAME"
    lECHOVAL=$(luc_core_vm_os_upgrade "$lVM_NAME" "$lVM_DISTRO"); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1
  done
  # ##### ACTION PROVISION NEEDED OR MISSING STANDARD OS PACKAGES
  # luc_core_echo "step" "provision needed or missing standard OS packages"
  # for lVM_NAME in $lNODE_LIST; do
  #   lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
  #   case $lVM_DISTRO in
  #       "alma")   lLIST_OS_PACKAGE="dnf-utils python3-dnf-plugin-versionlock" ;          lREASON="provision CLI needs-restarting"  ;;
  #       "debian") lLIST_OS_PACKAGE="rsync procps gnupg" ; lREASON="provision CLI rsync, syctl, gpg" ;;
  #       *) continue ;;    
  #   esac 
  #   luc_core_echo "doin" "node: $lVM_NAME > $lREASON"
  #   lECHOVAL=$(luc_core_vm_os_package_provision "$lVM_NAME" "$lLIST_OS_PACKAGE"); lRETVAL=$?
  #   [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1
  # done
  ###### RETURN
  return 0

}

luc_k8se_nodes_os_reboot() {
  lpurpose="reboot nodes if needed"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) <NODE_LIST>"
  local lMSG_EXAMPLE="$(luc_core_method_name_get)"
  local lNODE_LIST="$@" 
  local lECHOVAL
  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION: REBBOT IF NEEDED
  for lVM_NAME in $lNODE_LIST; do
    # check reboot is needed
    lECHOVAL=$(luc_core_vm_os_check_need_reboot "$lVM_NAME" 2>&1); lRETVAL=$?
    # checkorexi pbs exists
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "node: $lVM_NAME > $lECHOVAL" && return 1
    luc_core_echo "info" "node: $lVM_NAME > restart > $lECHOVAL"
    # reboot when needed
    [ "yes" == "$lECHOVAL" ] && {
      lECHOVAL=$(luc_core_vm_reboot "$lVM_NAME"); lRETVAL=$?
    }
  done

  ###### RETURN
  return 0

}
# purpose: Manage containerd provisioning
# args: NONE
luc_k8se_crio_manage() {
  local lDISTRO=$(luc_core_os_name_get)
  local lMSG_PURPOSE="Manage containerd provisioning"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### CHOICE
  case "$lDISTRO" in
    "alpine")          luc_core_echo "caut" "Done nothing" && retun 0 ;;
    "rocky"|"alma")    luc_k8se_containerd_rocky_repo_add  ;;
    "ubuntu"|"debian") luc_k8se_containerd_ubuntu_repo_add ;;
    "mac")             luc_core_echo "caut" "Done nothing" && retun 0 ;;
    *) luc_core_echo "warn" "$(luc_core_method_name_get) : unknow distro: $lDISTRO."; return 1 ;;
  esac

  ###### Final RETURN when everything is OK
  return 0
} # function

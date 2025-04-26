# purpose: install tool : podman and buildah
# args: none
luc_cimb_tool_provision() {
  local lMSG_PURPOSE="install tool : podman and buildah"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION : PROVISION PACKAGES > OS  ##################
  lECHOVAL=$(luc_core_os_package_provision podman); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 3 || lVM_OS=$lECHOVAL

  ###### RETURN
  return 0

}

# purpose: remote install tool : podman and buildah
# args: <VM_NAME>
luc_cimb_tool_provision_remote() {
  local lMSG_PURPOSE="remote install tool : podman and buildah"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lVM_NAME="$1"
  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"   ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexists VM is reachable
  luc_core_echo "chec" "VM is reachable"
  lECHOVAL=$(luc_ovh_vm_check_is_reachable $lOVH_VM); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 2

}

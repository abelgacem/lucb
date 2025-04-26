# purpose: kubeadm provision/create/bootstrap a k8s cluster cplane
# args: NONE
luc_k8se_cplane_create() {
  local lMSG_PURPOSE="kubeadm provision/create/bootstrap a k8s cluster cplane"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  
  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"   ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit VM are provided
  # do
  luc_core_echo "info" "create master"

  # do
  luc_core_echo "info" "create worker"

  return 0
} # function

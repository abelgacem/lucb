# purpose: add a worker to a k8s cluster
# args: NONE
luc_k8se_worker_add() {
  local lMSG_PURPOSE="install keubelet on a VM, not a container"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  
  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1


  ###### Final RETURN when everything is OK
  return 0
} # function

# purpose: provision a k8s worker
# args: NONE
luc_k8se_worker_add() {
  local lMSG_PURPOSE="provision a k8s worker"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  
  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # do
  luc_core_echo "info" "provision kubeadm"
  # do
  luc_core_echo "info" "provision kubelet"

  ###### Final RETURN when everything is OK
  return 0
} # function

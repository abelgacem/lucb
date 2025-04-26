# purpose: Manage swap on all nodes for the cluster
# args: NONE
luc_k8se_swap_manage() {
  local lMSG_PURPOSE="Manage swap on all nodes for the cluster"  
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$luc_EV_K8SE_NODE_LIST" 
  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### Final RETURN when everything is OK
  return 0
  
} # function


  ###### ACTION
  # sudo swapoff -a
  # sudo sed -i '/swap/d' /etc/fstab


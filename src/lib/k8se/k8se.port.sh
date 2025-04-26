# purpose: Manage Ports on all nodes for the cluster
# args: NONE
luc_k8se_port_manage() {
  local lMSG_PURPOSE="Manage ports on all nodes"  
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



# # sudo nft add table inet filter
# # sudo nft add chain inet filter input { type filter hook input priority 0 \; }
# # sudo nft add rule inet filter input ip saddr { 10.0.0.0/8, 192.168.0.0/16 } accept
# # sudo nft add rule inet filter input ip saddr 0.0.0.0/0 drop

# Accept traffic from the internal network (10.0.0.0/8, 192.168.0.0/16).
# This means:
# - Accept traffic from the internal network (10.0.0.0/8, 192.168.0.0/16).
# - Drop all other incoming traffic from external sources.
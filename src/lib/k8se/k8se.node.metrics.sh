luc_k8se_nodes_metrics_display() {
  lpurpose="display some metrics for all Nodes of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"
  
  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1"  ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### CHECK
  luc_core_echo "chec" "os:Distro  > must be in debian|ubuntu|rocky|alma|rocky"
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME os:distro); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "info" "$lECHOVAL" && return 1 || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done
  ###### CHECK 
  luc_core_echo "chec" "os:RAM     > at least 2 Gib"
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME ram); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "info" "$lECHOVAL" && return 1 || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done
  ###### CHECK 
  luc_core_echo "chec" "os:nb CPU  > at least  2"
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME cpu); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "info" "$lECHOVAL" && return 1 || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done
  ###### CHECK 
  luc_core_echo "chec" "ip"
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME net:ip); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "info" "$lECHOVAL" && return 1 || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done
  ###### CHECK 
  luc_core_echo "chec" "gateway/interface"
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME net:route); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "info" "$lECHOVAL" && return 1 || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done
  ###### CHECK 
  luc_core_echo "chec" "os:uuid > must be uniq"
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME net:uuid); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "info" "$lECHOVAL" && return 1 || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done
  ###### CHECK 
  luc_core_echo "chec" "os:mac > must be uniq"
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME net:mac); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "info" "$lECHOVAL" && return 1 || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done
  ###### CHECK 
  luc_core_echo "chec" "os:init system (systemd vs init)"
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME os:init); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "info" "$lECHOVAL" && return 1 || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done
  ###### CHECK 
  luc_core_echo "chec" "os:cgroup > if systemd and cgroup2 it is ok"
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME os:cgroup); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "info" "$lECHOVAL" && return 1 || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done
    
}

luc_k8se_nodes_os_kernel_version_display() {
  lpurpose="display os:kernel:version of all Nodes of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"


  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  
  ###### ACTION: DISPLAY PROPERTY
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME os:kernel:version); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && {
      luc_core_echo "caut" "$lECHOVAL" && continue 
    } || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done

  ###### RETURN
  return 0   
}
luc_k8se_nodes_os_ditro_display() {
  lpurpose="display os:distro of all Nodes of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"


  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION: DISPLAY PROPERTY
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_property_get $lVM_NAME os:distro); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && {
      luc_core_echo "caut" "$lECHOVAL" && continue 
    } || luc_core_echo "info" "node: $lVM_NAME > $lECHOVAL"
  done

  ###### RETURN
  return 0   
}

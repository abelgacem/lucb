luc_k8se_nodes_os_service_enable() {
  lpurpose="enable all needed os services on all Nodes of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"
  local lSERVICE_LIST="$luc_EV_K8SE_OS_SERVICE_CRIO $luc_EV_K8SE_OS_SERVICE_KUBELET"
   
  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION ALLOW OS SERVICE TO START AFTER A REBBOT
  for lVM_NAME in $lNODE_LIST; do
    luc_core_echo "doin" "node: $lVM_NAME"
    for lOS_SERVICE in $lSERVICE_LIST; do
      lCLI="sudo systemctl enable $lOS_SERVICE"
      lPHASENAME="$lOS_SERVICE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lPHASENAME > $lECHOVAL" || {
        [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > ${lECHOVAL}"
      }
    done
  done
  ###### RETURN
  return 0
}

luc_k8se_nodes_os_service_status() {
  lpurpose="status all needed os services on all Nodes of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"
  local lSERVICE_LIST="$luc_EV_K8SE_OS_SERVICE_CRIO $luc_EV_K8SE_OS_SERVICE_KUBELET"
   
  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION STATUS OS SERVIVES
  for lVM_NAME in $lNODE_LIST; do
    luc_core_echo "doin" "node: $lVM_NAME"
    for lOS_SERVICE in $lSERVICE_LIST; do
      lCLI="luc_core_service_status $lOS_SERVICE"
      lPHASENAME="$lOS_SERVICE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lPHASENAME > $lECHOVAL" || {
        [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > ${lECHOVAL}"
      }
    done
  done
  ###### RETURN
  return 0
}

luc_k8se_nodes_os_service_start() {
  lpurpose="start all needed os services on all Nodes of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lSERVICE_LIST="$luc_EV_K8SE_OS_SERVICE_CRIO"
  local lNODE_LIST="$@"
   
  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION STATUS OS SERVIVES
  for lVM_NAME in $lNODE_LIST; do
    luc_core_echo "doin" "node: $lVM_NAME"
    for lOS_SERVICE in $lSERVICE_LIST; do
      lCLI="luc_core_service_start $lOS_SERVICE"
      lPHASENAME="$lOS_SERVICE"
      lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lPHASENAME > $lECHOVAL" || {
        [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > ${lECHOVAL}"
      }
    done
  done
  ###### RETURN
  return 0
}

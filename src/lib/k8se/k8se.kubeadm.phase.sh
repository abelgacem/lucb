luc_k8se_nodes_kubeadm_phase_ca() {
  lpurpose="play kubeadm > phase > generate CA"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)"
  local lNODE_LIST="$@" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION ANABLE SERVICE TO START AFTER REBBOT
  for lVM_NAME in $lNODE_LIST; do
  luc_core_echo "doin" "node: $lVM_NAME"  
    ###### ACTION : phase CA
    lCLI="luc_k8se_kubeadm_phase_ca"
    lPHASENAME="kubeadm > phase > CA"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && {
      luc_core_echo "warn" "$lPHASENAME > $lECHOVAL" && return $lRETVAL
    } || [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
  done  

}
luc_k8se_nodes_kubeadm_phase_kubelet() {
  lpurpose="play kubeadm > phase > 01"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)"
  local lNODE_LIST="$@" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION ANABLE SERVICE TO START AFTER REBBOT
  for lVM_NAME in $lNODE_LIST; do
  luc_core_echo "doin" "node: $lVM_NAME"  
    ###### ACTION : phase kubelet
    lCLI="luc_k8se_kubeadm_phase_kubelet"
    lPHASENAME="kubeadm > phase > kubelet config"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && {
      luc_core_echo "warn" "$lPHASENAME > $lECHOVAL" && return $lRETVAL
    } || [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
  done  

}

luc_k8se_kubeadm_phase_ca() {
  lpurpose="play kubeadm > phase > generate CAs"
  largs="NONE"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION
  lECHOVAL=$(kubeadm init phase certs ca 2>&1); lRETVAL=$?

  ###### RETURN
  echo "$lECHOVAL"
  return $lRETVAL
} # function

luc_k8se_kubeadm_phase_kubelet() {
  lpurpose="play kubeadm > phase > generate kubelet configfile"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION
  lECHOVAL=$(kubeadm init phase kubeconfig kubelet 2>&1); lRETVAL=$?

  ###### RETURN
  echo "$lECHOVAL"
  return $lRETVAL
} # function



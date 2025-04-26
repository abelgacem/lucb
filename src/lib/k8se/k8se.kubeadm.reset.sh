luc_k8se_node_cplane_reset() {
  lpurpose="remote reset the control plane"
  largs="<CPLANE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lFILE_CONF="/tmp/config.yaml"
  local lNODE_CPLANE="$@"
  local lCLI_JOIN
  # local lFILTER_ECHO="use|already|init|warning|error"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_CPLANE" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION INITIALIZE THE CONTROL PLANE
  luc_core_echo "doin" "node: $lNODE_CPLANE"  
  lCLI="luc_k8se_cplane_reset"
  lPHASENAME="kubeadm > phase > reset"
  lECHOVAL=$(luc_core_vm_cli_run "$lNODE_CPLANE" "bash -l -c $lCLI" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lPHASENAME > $(echo "$lECHOVAL" | grep -Eiv ${lFILTER_ECHO:-yo})" || {
    [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
  }
}

luc_k8se_cplane_reset() {
  lpurpose="reset the control plane"
  largs="<CPLANE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lFILE_CONF="/tmp/config.yaml"
   
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1"   ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  sudo kubeadm reset -f
  sudo rm -rf $HOME/.kube
  sudo rm -rf /etc/kubernetes
  sudo rm -rf /etc/cni
  sudo systemctl stop kubelet
  # sudo ip link delete cni0|flannel.1 : delete interface created for the CNI
  # delete iptables rules created by k8s 
  ## sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F
}
# prereq: VM names are configured in $HOME/.ssh/config[.d/xxx] and are ssh reachable
luc_k8se_node_worker_reset() {
  lpurpose="remote reset all worker nodes of a cluster"
  largs="<LIST_WORKER>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u o2a" 
  local lFILE_CONF="/tmp/config.yaml"
  # local lFILTER_ECHO="use|already|init|warning|error"
  local lNODE_WORKER="$@"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_WORKER" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1


  # ##### ACTION RESET ALL WORKER NODES
  for lVM_NAME in $lNODE_WORKER; do
    luc_core_echo "doin" "node: $lVM_NAME > worker"
    lPHASENAME="reset worker"
    lCLI="luc_k8se_worker_reset"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "bash -l -c $lCLI" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && {
      luc_core_echo "warn" "$lPHASENAME > $(echo "$lECHOVAL" | grep -Eiv ${lFILTER_ECHO:-yo})" && return $lRETVAL
    } || [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
  done

  ###### RETURN
  return 0
} # function


luc_k8se_worker_reset() {
  lpurpose="reset a worker"
  largs="<CPLANE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
   
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1"   ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  sudo kubeadm reset -f
  sudo rm -rf ${HOME}/.kube
  sudo rm -rf /etc/kubernetes
  sudo rm -rf /etc/cni
  sudo systemctl stop kubelet
  # sudo ip link delete cni0|flannel.1 : delete interface created for the CNI
  # delete iptables rules created by k8s 
  ## sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F


}

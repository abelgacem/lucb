luc_k8se_node_cni_init() {
  lpurpose="remote initialize the control plane"
  largs="<<LIST_NODE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lFILE_CONF="/tmp/config.yaml"
  local lNODE_LIST="$@"
  local lSOCKET_CR="$luc_EV_K8SE_CR_SOCKET"
  # local lFILTER_ECHO="use|already|init|warning|error"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # ##### ACTION PROVISION CNI TO ALL WORKERS OF THE CLUSTER
  for lVM_NAME in $lNODE_WORKER; do
    luc_core_echo "doin" "node: $lVM_NAME > worker"
    lPHASENAME="provision CNI"
    lCLI="$lCLI_JOIN"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && {
      luc_core_echo "warn" "$lPHASENAME > $(echo "$lECHOVAL" | grep -Eiv ${lFILTER_ECHO:-yo})" && return $lRETVAL
    } || [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
  done

  ##### ACTION INITIALIZE THE CONTROL PLANE
  luc_core_echo "doin" "node: $lNODE_CPLANE"  
  lCLI="luc_k8se_cni_init"
  lPHASENAME="CNI > init"
  lECHOVAL=$(luc_core_vm_cli_run "$lNODE_CPLANE" "bash -l -c $lCLI" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lPHASENAME > $(echo "$lECHOVAL" | grep -Eiv ${lFILTER_ECHO:-yo})" || {
    [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
  }
}

# check
# conf > /etc/cni/net.d/
# ls /etc/cni/net.d/
# 10-calico.conflist

# Calico, Cilium, Flannel, Weave, Multus.
# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
# kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
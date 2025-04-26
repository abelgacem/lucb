luc_k8se_node_cplane_init() {
  lpurpose="remote initialize the control plane"
  largs="<CPLANE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lFILE_CONF="/tmp/config.yaml"
  local lNODE_CPLANE="$@"
  local lSOCKET_CR="$luc_EV_K8SE_CR_SOCKET"
  local lCLI_JOIN
  # local lFILTER_ECHO="use|already|init|warning|error"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_CPLANE" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION INITIALIZE THE CONTROL PLANE
  luc_core_echo "doin" "node: $lNODE_CPLANE"  
  lCLI="luc_k8se_cplane_init"
  lPHASENAME="kubeadm > phase > init"
  lECHOVAL=$(luc_core_vm_cli_run "$lNODE_CPLANE" "bash -l -c $lCLI" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lPHASENAME > $(echo "$lECHOVAL" | grep -Eiv ${lFILTER_ECHO:-yo})" || {
    [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
  }
}

luc_k8se_cplane_init() {
  lpurpose="Initialize the control plane"
  largs="<CPLANE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lFILE_CONF="/tmp/config.yaml"
  local lSOCKET_CR="$luc_EV_K8SE_CR_SOCKET"
   
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1"   ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION CREATE CONFIG FILE
  echo -e "
  ---
  apiVersion: kubeadm.k8s.io/v1beta4
  kind: InitConfiguration
  nodeRegistration:
    ignorePreflightErrors:
      - NumCPU

  ---

  apiVersion: kubeadm.k8s.io/v1beta4
  kind: ClusterConfiguration
  kubernetesVersion: \"$luc_EV_K8SE_VERSION\"

  ---

  apiVersion: kubelet.config.k8s.io/v1beta1
  kind: KubeletConfiguration
  containerRuntimeEndpoint: \"$lSOCKET_CR\"
  failSwapOn: false

  ---

  apiVersion: kubeadm.k8s.io/v1beta4
  kind: JoinConfiguration
  nodeRegistration:    
    ignorePreflightErrors:
      - NumCPU
  ---

  apiVersion: kubeadm.k8s.io/v1beta4
  kind: ResetConfiguration
  cleanupTmpDir: true

  " | sed '/^$/d' | sed 's/^  //' | sudo tee $lFILE_CONF > /dev/null
  
  sudo kubeadm init --config=$lFILE_CONF
}

luc_k8se_node_worker_init() {
  lpurpose="remote initialize a worker"
  largs="<NAME_CPLANE> <LIST_WORKER>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u o2a" 
  local lFILE_CONF="/tmp/config.yaml"
  local lNODE_CPLANE="$1"
  # local lFILTER_ECHO="use|already|init|warning|error"
  shift; local lNODE_WORKER="$@"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_CPLANE" ] ||
  [ -z "$lNODE_WORKER" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION GET JOIN CLI
  luc_core_echo "doin" "node: $lNODE_CPLANE > cplane"
  lPHASENAME="join CLI"
  lCLI="sudo kubeadm token create --print-join-command"
  lECHOVAL=$(luc_core_vm_cli_run "$lNODE_CPLANE" "$lCLI" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && {
    luc_core_echo "warn" "$lPHASENAME > $lECHOVAL" && return $lRETVAL
  } || [ -z "$lECHOVAL" ] || {
    luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
    lCLI_JOIN="sudo $lECHOVAL"
  }

  # ##### ACTION ADD ALL WORKERS TO THE CLUSTER
  for lVM_NAME in $lNODE_WORKER; do
    luc_core_echo "doin" "node: $lVM_NAME > worker"
    lPHASENAME="init worker"
    lCLI="$lCLI_JOIN"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && {
      luc_core_echo "warn" "$lPHASENAME > $(echo "$lECHOVAL" | grep -Eiv ${lFILTER_ECHO:-yo})" && return $lRETVAL
    } || [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
  done

  ###### RETURN
  return 0
} # function

# sudo kubeadm join <control-plane-ip>:6443 --config=/tmp/config.yaml
# sudo kubeadm join 51.210.10.195:6443 --token g4awfr.8ewmk95ax90auuk7 --discovery-token-ca-cert-hash sha256:873acccf24fb8d36915e0d14ec93f1c7c04c3dd46f6c040522ecebf30527a2bc
# sudo kubeadm init --control-plane-endpoint <LOAD_BALANCER_IP> --pod-network-cidr=<CIDR>
# sudo kubeadm token create --print-join-command


# --pod-network-cidr=10.244.0.0/16,2001:db8:42:0::/56 
# --service-cidr=10.96.0.0/16,2001:db8:42:1::/112




# You should now deploy a pod network to the cluster.
# Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
#   https://kubernetes.io/docs/concepts/cluster-administration/addons/

# Then you can join any number of worker nodes by running the following on each as root:

# kubeadm join 51.210.10.195:6443 --token 3dzeq0.m1v3g6y1xqy23kkw \
# 	--discovery-token-ca-cert-hash sha256:b1a62d2ef9953a98539d3158f3af2ba5953589df9b7204449a9a40ffd65ca9af




# Advertise
# InitConfiguration.localAPIEndpoint
# JoinConfiguration.controlPlane.localAPIEndpoint.
# kubeadm init --config=kubeadm-config.yaml

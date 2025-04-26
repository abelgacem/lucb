luc_k8se_kubelet_service_configure() {
  lpurpose="start service kubelet"
  largs="NONE"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) $largs" 
  local lSERVICE_NAME="$luc_EV_K8SE_OS_SERVICE_KUBELET" 
  local lFILE_CONF_01="/etc/default/kubelet" 
  local lFILE_CONF_02="/var/lib/kubelet/config.yaml" 
  local lCR_SOCKET="$luc_EV_K8SE_CR_SOCKET" 

  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # ##### ACTION update conf
  echo -e "
  KUBELET_EXTRA_ARGS="--config=/var/lib/kubelet/config.yaml"
  " |  sed 's/^[ \t]*//' | sed '/^$/d' | sudo tee $lFILE_CONF_01 > /dev/null

  # ##### ACTION update conf
  echo -e "
  apiVersion: kubelet.config.k8s.io/v1beta1
  kind: KubeletConfiguration
  containerRuntimeEndpoint: "${lCR_SOCKET}"
  failSwapOn: false
  " | sed '/^$/d' | sed 's/^  //' | sudo tee $lFILE_CONF_02 > /dev/null

  ###### Final RETURN when everything is OK
  return 0
} # function



# sudo systemctl enable --now kubelet

# /etc/default/kubelet

  #   

# The object : KubeletConfiguration can be passed to kubeadm
# example:
# apiVersion: kubelet.config.k8s.io/v1beta1
# kind: KubeletConfiguration
# clusterDNS:
# - 10.96.0.10

# apiVersion: kubelet.config.k8s.io/v1beta1
# kind: KubeletConfiguration
# address: "192.168.0.8"
# port: 20250
# serializeImagePulls: false
# evictionHard:
#   memory.available:  "100Mi"
#   nodefs.available:  "10%"
#   nodefs.inodesFree: "5%"
#   imagefs.available: "15%"
#   imagefs.inodesFree: "5%"  

# For kubelets on all nodes, the --node-ip option can be passed in 
# InitConfiguration.nodeRegistration.kubeletExtraArgs Or
# JoinConfiguration.nodeRegistration.kubeletExtraArgs
luc_k8se_nodes_sysctl_configure() {
  lpurpose="configure kernel modules and parameters"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)"
  local lNODE_LIST="$@" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION CONFIGUTE KERNEL MODULES AND PARAMETER
  for lVM_NAME in $lNODE_LIST; do
    luc_core_echo "doin" "node: $lVM_NAME"
    ##### ACTION
    lCLI="luc_k8se_sysctl_module"
    lPHASENAME="modules"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && {
      luc_core_echo "warn" "$lPHASENAME > ${lECHOVAL}" && return $lRETVAL 
    } || [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
    # ##### ACTION
    lCLI="luc_k8se_sysctl_parameter"
    lPHASENAME="parameters"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && {
      luc_core_echo "warn" "$lPHASENAME > $lECHOVAL" && return $lRETVAL 
    } || [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
  done
}


luc_k8se_sysctl_module() {
  lpurpose="configure kernel modules"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)"
  local lFILE_CONF="/etc/modules-load.d/${luc_EV_K8SE_OS_SYSCTL}.conf"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION CREATE MODULE FILE
  echo -e "
  overlay
  br_netfilter
  " |  sed 's/^[ \t]*//' | sed '/^$/d' | sudo tee $lFILE_CONF > /dev/null

  ###### ACTION : LOAD MODULE FOR CURRENT SESSION
  lLIST="overlay br_netfilter"
  for lMODULE in $lLIST; do
    lECHOVAL=$(sudo modprobe $lMODULE  2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && echo "cannot load module: $lMODULE" && return 3
  done

  # sudo systemctl restart systemd-modules-load

  ###### CHECK PROVISIONING
  lLIST="overlay br_netfilter"
  for lMODULE in $lLIST; do
    lECHOVAL=$(lsmod | grep -q $lMODULE 2>&1) ; lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && echo "module not found: $lMODULE" && return 4
  done

  ###### RETURN
  return 0
}
luc_k8se_sysctl_parameter() {
  lpurpose="configure kernel parameters"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get)"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)"
  local lFILE_CONF="/etc/sysctl.d/${luc_EV_K8SE_OS_SYSCTL}.conf"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION CREATE PARAMETER FILE
  echo -e "
  # Enable IP forwarding - kernel parmeter
  net.ipv4.ip_forward = 1

  # Allow bridged IPv4 traffic to go through iptables  - br_netfilter module parmeter
  # Enable filtering of bridged traffic
  net.bridge.bridge-nf-call-iptables = 1

  # Allow bridged IPv6 traffic to go through iptables  - br_netfilter module parmeter
  # Enable filtering of IPv6 traffic on bridged interfaces
  net.bridge.bridge-nf-call-ip6tables = 1

  # Enable filtering of bridged traffic for all interfaces
  # net.bridge.bridge-nf-call = 1  
  " |  sed 's/^[ \t]*//' | sed '/^$/d' | sudo tee $lFILE_CONF > /dev/null

  ###### ACTION : ACTIVATE MODULES
  lECHOVAL=$(sudo /sbin/sysctl --system &> /dev/null 2>&1) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return $lRETVAL
  
  ###### CHECK PROVISIONING
  lLIST="net.ipv4.ip_forward net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables"
  for lPARAM in $lLIST; do
    value_current=$(sudo sysctl -n $lPARAM)
    value_set=$(grep $lPARAM $lFILE_CONF | cut -d "=" -f 2 | tr -d '[:space:]')
    [ "$value_current" != "$value_set" ] && echo "parameter not set: $lPARAM" && return 2
  done

  ###### RETURN  
  return 0

}

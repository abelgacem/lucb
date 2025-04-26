luc_k8se_nodes_luc_rc_provision() {
  lpurpose="provision LUC on all Nodes:OS of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lLUC_FOLDER_DST="$luc_EV_K8SE_LUC_HOME_DST"
  local lLUC_SETUPFILE="${lLUC_FOLDER_DST}/$luc_EV_K8SE_LUC_SETUP_RELPATH"  
  local lFILE_RC="/etc/profile.d/luc.rc.sh"  
  local lNODE_LIST="$@"
  

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION: PROVISION LUC RC FILE
  lCONTENT="export LUCSETUP=$lLUC_SETUPFILE"
  lCONTENT+=$(echo -e "
  . $lLUC_SETUPFILE &> /dev/null
  ")
  lCLI="echo \"$lCONTENT\" | sed 's/^[ \t]*//' | sed '/^$/d' | sudo tee $lFILE_RC &>/dev/null"
  for lVM_NAME in $lNODE_LIST; do
    luc_core_echo "doin" "node: $lVM_NAME > create LUC RC file"
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI" 2>&1); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1 
  done
  ###### RETURN
  return 0

}
luc_k8se_nodes_luc_folder_provision() {
  lpurpose="provision LUC on all Nodes:OS of a cluster"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lLUC_FOLDER_DST="$luc_EV_K8SE_LUC_HOME_DST"
  local lLUC_SETUPFILE="${lLUC_FOLDER_DST}/$luc_EV_K8SE_LUC_SETUP_RELPATH"  
  local lFILE_RC="/etc/profile.d/luc.rc.sh"  
  local lNODE_LIST="$@"
  
  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION: PROVISION LUC FOLDER
  for lVM_NAME in $lNODE_LIST; do
    luc_core_echo "doin" "node: $lVM_NAME > rsync folder LUC"
    lECHOVAL=$(luc_core_vm_folder_rsync "$lVM_NAME" "$lLUC_FOLDER_SRC" "$lLUC_FOLDER_DST" ); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1 
  done
  ###### RETURN
  return 0

}

# purpose: check nodes are ssh reachable
# args: <NODE_LIST>
luc_k8se_nodes_are_ssh_reachable() {
  local lMSG_PURPOSE="check nodes are ssh reachable"  
  local lMSG_USAGE="$(luc_core_method_name_get) <NODE_LIST>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)"
  local lNODE_LIST="$@" 
  
  # purpose
  # luc_core_echo "purp" "$lMSG_PURPOSE"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION: CHECK IS SSHABLE
  for lVM_NAME in $lNODE_LIST; do
    lECHOVAL=$(luc_core_vm_check_is_ssh_reachable $lVM_NAME); lRETVAL=$?
    [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1 
  done

  ###### RETURN
  return 0

}

# required to allow containers to access the host filesystem
luc_k8se_nodes_selinux_set_permissive() {
  lpurpose="configure selinux"
  largs="<NODE_LIST>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lNODE_LIST="$@"
  local lPAKAGE_SELINUX="/etc/selinux/config" 
  local lFILE_CONF="/etc/selinux/config"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_LIST"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  
  ###### ACTION
  for lVM_NAME in $lNODE_LIST; do
    lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
    case $lVM_DISTRO in
      "alma"|"rocky"|"fedora") 
        ###### UPDATE THE FILE
        lCLI=$(echo -e "
        sudo setenforce 0
        " | sed 's/^[ \t]*//' | sed '/^$/d' | sed 's/$/ \&\& /')
        lCLI+="sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/' $lFILE_CONF"
        luc_core_echo "doin" "node: $lVM_NAME"
        lECHOVAL=$(luc_core_vm_cli_run o2a "bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
        [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2
        ###### CHECK UPDATE IS DONE
        lCLI="grep 'SELINUX=permissive' $lFILE_CONF || { echo 'cannot configure' ; exit 1; }"
        lECHOVAL=$(luc_core_vm_cli_run o2a "bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
        [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2  
        ;;
    esac
  done

  ###### RETURN
  return 0
}
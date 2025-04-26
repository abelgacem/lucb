# purpose: Manage Todo List
# args: NONE
luc_k8se_todo_manage() {
  luc_core_echo "todo" "allow to provide a YAML to configure the install of K8se"
  luc_core_echo "todo" "on all node: install the low leve firewall tool nftables"
  luc_core_echo "todo" "on all node: firewall > close all ports"
  luc_core_echo "todo" "on all node: firewall > allow only those needed for the cluster communication"
  luc_core_echo "todo" "create master"
  luc_core_echo "todo" "create workers in the YAML"

} # function

luc_k8se_todo_copy() {
  local lLUC_FOLDER_DST="$luc_EV_K8SE_LUC_HOME_DST"
  local lLUC_SETUPFILE="${lLUC_FOLDER_DST}/$luc_EV_K8SE_LUC_SETUP_RELPATH"  
  local lFILE_RC="/tmp/test"  
  
  lCONTENT="export LUCSETUP=$lLUC_SETUPFILE"
  lCONTENT+=$(echo -e "
  . $lLUC_SETUPFILE &> /dev/null
  ")
  # lCONTENT="export LUCSETUP=$lLUC_SETUPFILE"
  # lCONTENT+=$(echo -e '
  # alias srcluc=\". \$LUCSETUP 1 >/dev/null\"
  # alias srclucv=\". \$LUCSETUP\"
  # srcluc
  # ') 
  # lCLI="echo \"$lCONTENT\" | sed 's/^[ \t]*//' | sed '/^$/d' | sudo tee $lFILE_RC &>/dev/null"
  lCLI="echo \"$lCONTENT\" | sed 's/^[ \t]*//' | sed '/^$/d' | tee $lFILE_RC &>/dev/null"

  luc_core_vm_cli_run o1u "$lCLI"

}

luc_k8se_todo_cli() {
  local lFILE_CONF="/etc/selinux/config"
  lCLI=$(echo -e "
  sudo setenforce 0
  " | sed 's/^[ \t]*//' | sed '/^$/d' | sed 's/$/ \&\& /')
  lCLI+="sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' $lFILE_CONF"
  
  ###### ACTION UPDATE THE FILE
  lECHOVAL=$(luc_core_vm_cli_run o2a "bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2

  ###### ACTION CHECK UPDATE IS DONE
  lCLI="grep 'SELINUX=permissive' $lFILE_CONF || { echo 'Not found' ; exit 1; }"
  lECHOVAL=$(luc_core_vm_cli_run o2a "bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2  
}  

luc_k8se_todo_nohup() {
  local lNODE_LIST="${luc_EV_K8SE_NODE_LIST//|/ }"
  # play a local background CLI that play a remote CLI on a set of VM
  # the set of VM is something like lLIST_VM="o1u o2a o3r"
  # The local backdround CLI is something like ssh o1u "bash -l -c luc_k8se_methode" & in which luc_k8se_methode is the remote CLI
  # I need to capture when all the REMOTE CLI ended, for each remote CLI execution
  # -  in a var called lECHOVAL the output of the remote CLI
  # -  in a var called lRETVAL  the return value of the execution of the remote CLI
  # I need to display in local for this set of VM, lECHOVAL and lRETVAL for each
  for lVM_NAME in $lNODE_LIST; do
    lCLI="luc_k8se_methode_sleep"
    luc_core_echo "doin" "node: $lVM_NAME"
    ##### ACTION
    # pid=$(ssh o1u 'ls -ial > /dev/null 2>&1 & echo $!')
    # ssh o1u 'nohup ls -ial > /dev/null 2>&1 & echo $! > /tmp/ls.pid'
    lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "bash -l -c $lCLI" 2>&1); lRETVAL=$?
  # get the local and reomte pid of the CLI
  # while one of the CLI is running sleep 2
  # 
  done
}  

luc_k8se_methode() {
  lSLEEP_TIME=$((RANDOM % 6 + 5))
  luc_core_echo "debu" "lSLEEP_TIME = $lSLEEP_TIME sseconde"
  sleep $lSLEEP_TIME
}  


  # ###### ACTION
  # luc_core_echo "step" "provision the cplane node"

  # # do
  # luc_core_echo "info" "create worker"

  # luc_core_echo "chec" "prerequisits : for the cluster"
  # luc_core_echo "chec" "prerequisits : for cplane"
  # luc_core_echo "chec" "prerequisits : for workers"

  # ###### ACTION
  # luc_core_echo "step" "Action on all nodes: install the CNR"
  # luc_core_echo "step" "download/cplane components container images"
  
  # ###### CHECK PROVIIONING
  # luc_core_echo "check" "Check on all nodes : CNR is provisioned"


  # local lOS_VERSION=$(lsb_release -rs)
  # local lOS_VERSION="22.04"
  # # checkorexit cli exists
  # lCLI='lsb_release';
  



# #sudo add-apt-repository -y "deb ${luc_EV_K8SE_REPO_LIBCONTAINER_UBUNTU}/ /"
# #sudo add-apt-repository -y "deb ${luc_EV_K8SE_REPO_CRIO_UBUNTU}/ /"
# #sudo systemctl enable --now cri-o
# # sudo dnf config-manager --add-repo="$luc_EV_K8SE_REPO_CRIO_ROCKY"
# # crio --version


luc_k8se_helm_provision() {
  lpurpose="remote provision the client Helm on a VM/Container"
  largs="<VM_NAME>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lVM_NAME="$1"
  local lHELM_URL="$luc_EV_K8SE_HELM_URL" 
  local lHELM_FOLDER_DST="/usr/local/bin" 
  local lHELM_FILE_PATH="${lHELM_FOLDER_DST}/helm" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION PROVISION
  luc_core_echo "doin" "node: $lVM_NAME"
  luc_core_echo "info" "helm > provision"
  lCLI="curl -sL $luc_EV_K8SE_HELM_URL |   sudo tar -xz -C $lHELM_FOLDER_DST --strip-components=1 --wildcards */helm"
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 4
  ###### CHECK HELM IS INSTALLED 
  luc_core_echo "chec" "helm is installed" 
  lCLI="luc_core_check_file_exits $lHELM_FILE_PATH"
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 4
  ###### RETURN
  return 0
}

luc_k8se_helm_delete() {
  lpurpose="remote provision the client Helm on a VM/Container"
  largs="<VM_NAME>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u o2a" 
  local lVM_NAME="$1"
  local lHELM_FOLDER_DST="/usr/local/bin" 
  local lHELM_FILE_PATH="${lHELM_FOLDER_DST}/helm" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION DELETE
  luc_core_echo "doin" "node: $lVM_NAME"
  luc_core_echo "info" "helm > delete"
  lCLI="sudo rm -rf $lHELM_FILE_PATH"
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 4

  ###### CHECK HELM IS DELETlHELM_FILE_PATHED
  luc_core_echo "chec" "helm is installed" 
  lCLI="luc_core_check_file_exits $lHELM_FILE_PATH"
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
  [ 0 -eq "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 5

  ###### RETURN
  return 0
}

luc_k8se_helm_repo_add() {
  lpurpose="provision a HELM repository"
  largs="<REPO_NAME>"
  local lMSG_PURPOSE="$lpurpose"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lREPO_NAME="$1"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lREPO_NAME"  ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1


 helm repo add bitnami https://charts.bitnami.com/bitnami

  ###### ACTION PROVISION
  luc_core_echo "doin" "node: $lVM_NAME"
  luc_core_echo "info" "helm > provision"
  lCLI="curl -sL $luc_EV_K8SE_HELM_URL |   sudo tar -xz -C $lHELM_FOLDER_DST --strip-components=1 --wildcards */helm"
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 4
  ###### CHECK HELM IS INSTALLED 
  luc_core_echo "chec" "helm is installed" 
  lCLI="luc_core_check_file_exits $lHELM_FOLDER_DST/helm"
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "sudo bash -l -c \"$lCLI\"" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 4
  ###### RETURN
  return 0
}

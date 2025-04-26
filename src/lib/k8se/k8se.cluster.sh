# args: <yaml file>
luc_k8se_cluster_create() {
  lpurpose="create a Vanilla k8s cluster version $luc_EV_K8SE_VERSION"
  largs="<yaml file>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u o2a" 
  local lNODE_LIST="${luc_EV_K8SE_NODE_LIST//|/ }"
  local lNODE_CPLANE="$luc_EV_K8SE_NODE_CPLANE"
  local lNODE_WORKER="$luc_EV_K8SE_NODE_WORKER"
  local lCR_NAME="$luc_EV_K8SE_CR_NAME" 
  local lCNR_NAME="$luc_EV_K8SE_PLUGIN_CNR_NAME" 
  local lLUC_FOLDER_SRC="$luc_EV_K8SE_LUC_HOME_SRC"
  local lLUC_FOLDER_DST="$luc_EV_K8SE_LUC_HOME_DST"
  local lLUC_SETUPFILE="${lLUC_FOLDER_DST}/$luc_EV_K8SE_LUC_SETUP_RELPATH"  
  local lTIME_START=$(date +"%s")
  local lOS_DETECTED lCLI lVM_NAME

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  ###### PREREQUISIT
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  ####### 
  luc_core_echo "step" "on all nodes: check node is ssh reachable"
  luc_k8se_nodes_are_ssh_reachable $lNODE_LIST      || return 1
  
  # ####### ####### ####### #######
  # # PART 01 - check VMs/Nodes
  # ####### ####### ####### #######
  # luc_core_echo "step" "on all nodes: check os:kernel:version before OS update"
  # luc_k8se_nodes_os_kernel_version_display $lNODE_LIST  || return 1
  # # vm > name > os:family :: os:pft :: os:version :: os:kversion  
  # ####### 
  # luc_core_echo "step" "on all nodes: check node is ssh reachable"
  # luc_k8se_nodes_os_kernel_version_display $lNODE_LIST  || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: manually checks the node metrics"
  # luc_k8se_nodes_metrics_display $lNODE_LIST        || return 1
  # ####### 
  

  # ####### ####### ####### #######
  # # PART 02 - upgrade VMs/Nodes OS
  # ####### ####### ####### #######
  # luc_core_echo "step" "on all nodes: update OS"
  # luc_k8se_nodes_os_upgrade $lNODE_LIST             || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: provision needed or missing OS packages"
  # luc_k8se_nodes_os_package_provision $lNODE_LIST   || return 1

  # ####### ####### ####### #######
  # # PART 03 - upgrade VMs/Nodes OS
  # ####### ####### ####### #######
  # luc_core_echo "step" "on all nodes: provision LUC RC file"
  # luc_k8se_nodes_luc_rc_provision $lNODE_LIST       || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: reboot when needed"
  # luc_k8se_nodes_os_reboot $lNODE_LIST              || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: check os:kernel:version after OS update"
  # luc_k8se_nodes_os_kernel_version_display $lNODE_LIST  || return 1
  # ####### 
  luc_core_echo "step" "on all nodes: provision LUC folder in $lLUC_FOLDER_DST"
  luc_k8se_nodes_luc_folder_provision $lNODE_LIST   || return 1
  # ###### 
  # luc_core_echo "step" "on nodes@rocky: configure SELINUX permissive"
  # luc_k8se_nodes_selinux_set_permissive $lNODE_LIST || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: configure kenel modules and parameters"
  # luc_k8se_nodes_sysctl_configure $lNODE_LIST       || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: provision CR dnfapt repository"
  # luc_k8se_crio_os_repo_provision $lNODE_LIST       || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: provision k8s dnfapt repository"
  # luc_k8se_k8s_os_repo_provision $lNODE_LIST        || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: provision CR dnfapt packages"
  # luc_k8se_crio_os_package_provision $lNODE_LIST    || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: provision K8s dnfapt packages"
  # luc_k8se_k8s_os_package_provision $lNODE_LIST     || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: enable needed os services"
  # luc_k8se_nodes_os_service_enable $lNODE_LIST      || return 1
  # ####### 
  # luc_core_echo "step" "on all nodes: start needed os services"
  # luc_k8se_nodes_os_service_start $lNODE_LIST       || return 1

  # ####### ####### ####### #######
  # # PART 04 - init cplane
  # ####### ####### ####### #######
  luc_core_echo "step" "on nodes@cplane: initialize the cplane"
  luc_k8se_node_cplane_init $lNODE_CPLANE 


  # ####### ####### ####### #######
  # # PART 05 - init workers
  # ####### ####### ####### #######
  luc_core_echo "step" "on nodes@worker: initialize the worker"
  luc_k8se_node_worker_init $lNODE_CPLANE $lNODE_WORKER  
  # ####### 
  luc_core_echo "step" "on all nodes: status os services"
  luc_k8se_nodes_os_service_status $lNODE_LIST      || return 1

  ####### ####### ####### #######
  # PART 06 - init kubectl on the cplane
  ####### ####### ####### #######
  # luc_core_echo "step" "on nodes@cplane: provision KUBECTL dnfapt packages"
  # luc_k8se_kubectl_os_package_provision $lNODE_CPLANE
  # luc_core_echo "step" "on nodes@cplane: configure KUBECTL"
  # luc_k8se_node_kubectl_configure $lNODE_CPLANE

  ####### ####### ####### #######
  # PART 07 - Install HELM CLIENT
  ####### ####### ####### #######
  luc_core_echo "step" "on nodes@cplane: provision HELM client from tgz"
  luc_k8se_helm_provision $lNODE_CPLANE || return 1

  ####### ####### ####### #######
  # PART 08 - init CNI PLUGIN
  ####### ####### ####### #######
  # luc_core_echo "step" "on all nodes: provision CNI plugin"
  # luc_k8se_node_cni_provision $lNODE_LIST
  
  ####### DURATION
  luc_core_echo "info" "$(luc_core_other_delay  $lTIME_START $(date +'%s'))"

  ####### RETURN 
  return 0
} # function

luc_k8se_cluster_reset() {
  lpurpose="reset a Vanilla k8s cluster version $luc_EV_K8SE_VERSION"
  largs="<NONE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u o2a" 
  local lNODE_LIST="${luc_EV_K8SE_NODE_LIST//|/ }"
  local lNODE_CPLANE="$luc_EV_K8SE_NODE_CPLANE"
  local lNODE_WORKER="$luc_EV_K8SE_NODE_WORKER"
  local lCR_NAME="$luc_EV_K8SE_CR_NAME" 
  local lCNR_NAME="$luc_EV_K8SE_PLUGIN_CNR_NAME" 
  local lLUC_FOLDER_SRC="$luc_EV_K8SE_LUC_HOME_SRC"
  local lLUC_FOLDER_DST="$luc_EV_K8SE_LUC_HOME_DST"
  local lLUC_SETUPFILE="${lLUC_FOLDER_DST}/$luc_EV_K8SE_LUC_SETUP_RELPATH"  
  local lTIME_START=$(date +"%s")
  local lOS_DETECTED lCLI lVM_NAME

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"

  ###### PREREQUISIT
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  ####### 
  # luc_core_echo "step" "on all nodes: check node is ssh reachable"
  luc_k8se_nodes_are_ssh_reachable $lNODE_LIST      || return 1
  
  # ####### 
  luc_core_echo "step" "on all nodes: provision LUC folder in $lLUC_FOLDER_DST"
  luc_k8se_nodes_luc_folder_provision $lNODE_LIST   || return 1
  # ####### 
  luc_core_echo "step" "on node@cplane: reset"
  luc_k8se_node_cplane_reset  $lNODE_CPLANE  || return 1
  # ####### 
  luc_core_echo "step" "on all nodes&worker: reset"
  luc_k8se_node_worker_reset  $lNODE_WORKER   || return 1
  ####### 
  luc_core_echo "step" "on all nodes: status os services"
  luc_k8se_nodes_os_service_status $lNODE_LIST      || return 1

  ####### DURATION
  luc_core_echo "info" "$(luc_core_other_delay  $lTIME_START $(date +'%s'))"

  ####### RETURN 
  return 0
} # function




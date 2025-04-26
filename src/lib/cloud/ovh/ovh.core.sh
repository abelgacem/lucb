# purpose: check an OVH VM is reachable
# note: no other echo inside the code - helper function - the return value and code are used
# args: <VM_NAME>
luc_ovh_vm_check_is_reachable() {
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME>" 
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u" 
  local lVM_NAME="$1"
  local lOVH_VM_REACHABLE=''
  
  # checkorexit args are provided
  [ -z "$lVM_NAME"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "check if an ovh VPS exists and is SSH reachable" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # getorexit list of reachable OVH VPS
  lECHOVAL=$(luc_ovh_vm_list); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 1 || lOVH_VM_REACHABLE="$lECHOVAL"

  # checkorexists VM exists and is reachable
  lECHOVAL=$(luc_core_check_string_is_inlist $lVM_NAME $lOVH_VM_REACHABLE); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "vm : $lVM_NAME not in list of reachable VM: $lOVH_VM_REACHABLE" && return 1 || return 0
}

# purpose: list all SSH reachable OVH VMs
# note: no other echo inside the code - helper function - the return value and code are used
# args: none
luc_ovh_vm_list() {
  local lMSG_PURPOSE="list all SSH reachable OVH VM" 
  local lMSG_USAGE="$(luc_core_method_name_get)" 
  local lFILE_SSH_CONFIG_01="${luc_EV_OVH_SSH_CONF_FILE_01}"
  local lFILE_SSH_CONFIG_02="${luc_EV_OVH_SSH_CONF_FILE_02}"
  local lLIST_VM="$luc_EV_OVH_NAME_VPS_MANAGED"
  local lVM_REACHABLE=''
  
  ####### PREREQUISITS
  # checkorexit args are provided
  [ "--help" == "$1" ] && luc_core_echo "purp" "get the list of accessible ovh vps" && luc_core_echo "usag" "$lMSG_USAGE" && return 1
  # checkorexit file exists
  lECHOVAL=$(luc_core_check_file_exits $lFILE_SSH_CONFIG_01); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 1
  # checkorexit file exists
  lECHOVAL=$(luc_core_check_file_exits $lFILE_SSH_CONFIG_02); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 1

  ####### ACTIONS
  # get list vm reachable (maybe use flag ConnectTimeout=3)
  for ITEM in $(echo $lLIST_VM | tr '|' ' '); do
    lECHOVAL=$(ssh -o BatchMode=yes  $ITEM true >/dev/null 2>&1) ; lRETVAL=$?
    [ 0 -eq "$lRETVAL" ] && lVM_REACHABLE+="$ITEM|"
  done

  # return
  [ -z "$lVM_REACHABLE" ] && luc_core_echo "warn" "no OVH VPS available" && return 2 || echo $lVM_REACHABLE && return 0

}

# purpose: get the reachable OVH VPS
# note: no other echo inside the code - helper function - the return value and code are used
# args: <VM_NAME> <PROPERTY>
luc_ovh_vm_property_get() {
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <PROPERTY>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u user" 
  local lVM_NAME="$1"
  local lPROPERTY="$2"

  # checkorexit args are provided
  [ -z "$lVM_NAME"     ] ||
  [ -z "$lPROPERTY"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexists VM is reachable
  lECHOVAL=$(luc_ovh_vm_check_is_reachable $lVM_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo $lECHOVAL && return 2
  
  # get VM property
  lCHOICE="$(echo "$lPROPERTY" | tr '[:upper:]' '[:lower:]')"
  case "$lCHOICE" in
    user)
      # lVALUE=$(ssh -G $lVM_NAME | grep '^user ' | awk '{print $2}')
      lVALUE=$(ssh $lVM_NAME 'id -un')
      ;;
    ip)
      lVALUE=$(ssh -G $lVM_NAME | grep '^hostname ' | awk '{print $2}')
      ;;
    *)
      luc_core_echo "warn" "porperty not yet managed > VM:$lVM_NAME:$lPROPERTY" && return 1
      ;;
  esac
  # do
  echo $lVALUE; return 0  

}


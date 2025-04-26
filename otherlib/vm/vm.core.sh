# todo: does not work for localhost
# args: lHOST_IP
vm_host_check_is_ssh_reachable() {
  local lHOST_IP="$1"

  # Check if an argument is provided
  [ -z "$1" ] && luc_core_echo "warn" "No Host name provided." && return 1
  #  
  ssh -q $lHOST_IP exit && return 0 || return 1
  # ping -c 1 -W 1 $lHOST_IP &> /dev/null && return 0 || return 1
}

vm_id_get() {

  # Check
  CLI='ip'; luc_core_check_cli_is_installed ${CLI} || { 
    luc_core_echo "warn" "${CLI} is not installed." ; return 1 
  }   

  # Check
  CLI='jq'; luc_core_check_cli_is_installed ${CLI} || { 
    luc_core_echo "warn" "${CLI} is not installed." ; return 1 
  }   
    
  # define var
  IP_ADDRESS=$(ip addr show | grep "inet " | grep -v "127.0.0.1" |awk '{print $2}' | cut -d/ -f1)
  MAC_ADDRESS=$(ip link show | grep "link/ether" | awk '{print $2}')
  UUID=$(sudo cat /sys/class/dmi/id/product_uuid)
  # 
  luc_core_echo "caut" "using sudo."
  # Check cli 
  CLI='jq'; luc_core_check_cli_is_installed ${CLI} || { 
    luc_core_echo "warn" "${CLI} is not installed." ; return 1 
  }   
  #
  # output the JSON output using jq
  jq -n \
    --arg ip   "$IP_ADDRESS" \
    --arg mac  "$MAC_ADDRESS" \
    --arg uuid "$UUID" \
    '{ip: $ip, mac: $mac, uuid: $uuid}'
}



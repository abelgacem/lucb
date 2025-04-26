# purpose: set the status for several host:ports
# args: "$host $port $proto $direction $status"
vm_port_status_set() {
  ARGS=($1) # create array from ui
  NBARG="$#ARGS[@]"
  [ "$NBARG" -ne 5 ] && {
    luc_core_echo "warn" "bad number of arg. must provide exactly 5: host, port, proto, direction, status"
    luc_core_echo "warn" "example: \"o1u 6443 tcp in(bound)|out(bound) open|close\""
    return 1
  }
  lHOST_IP=$ARGS[0]
  lHOST_PORT=$ARGS[1]
  lPORT_PROTO=$ARGS[2]
  lPORT_DIR=$ARGS[3]
  lPORT_STATE=$ARGS[4]
  # check state
  [[ ! " open close " =~ " ${lPORT_STATE} " ]] && {
    luc_core_echo "warn" "state must be open|close"  
    return 1 
  }
  [ "$lPORT_STATE" == "open" ]   && lPORT_STATE="A"
  [ "$lPORT_STATE" == "close" ]  && lPORT_STATE="D"
  # check direction
  [[ ! " in out " =~ " $lPORT_DIR " ]] && {
    luc_core_echo "warn" "state must be in|out"  
    return 1 
  }
  [ "$lPORT_DIR" == "out" ] && lPORT_DIR="OUTPUT"
  [ "$lPORT_DIR" == "in" ]  && lPORT_DIR="INPUT"
  luc_core_echo "debu" "$lHOST_IP, $lHOST_PORT, $lPORT_PROTO, $lPORT_DIR, $lPORT_STATE"
  echo 
  ssh $lHOST_IP "sudo iptables -${lPORT_STATE} $lPORT_DIR -p ${lPORT_PROTO} --dport $lHOST_PORT-j ACCEPT && sudo iptables-save"
}

# purpose: get the status for a host:port
# required: $port
# optional: $host
# args: "$host" "$port" or "$port" ($host default to localhost)
vm_port_status_get() {
  
  # check arg
  [ "$#" -eq 2 ] && {
    local HOST_PORT=$2
    local HOST_IP=$1
  }

  # check arg
  [ "$#" -eq 1 ] && {
    local HOST_IP="localhost"
    local HOST_PORT=$1
  }

  # check arg
  [ "$#" -eq 0 ] || [ "$#" -gt 2 ] && {
    luc_core_echo "warn" "bad number of arg"
    return 1
  }  
  
  # Check
  CLI='nc'; luc_core_check_cli_is_installed ${CLI} || { 
    luc_core_echo "warn" "${CLI} is not installed." ; return 1 
  }   
  # Check
  CLI='jq'; luc_core_check_cli_is_installed ${CLI} || { 
    luc_core_echo "warn" "${CLI} is not installed." ; return 1 
  }   
  
  # works for remote host and localhost
  [ "$HOST_IP" == "localhost" ] && {
    lPORT_STATUS=$(nc -zw 1 localhost  $HOST_PORT &> /dev/null && echo 0 || echo 1)
  } || {    
    lPORT_STATUS=$(ssh $HOST_IP"nc -zw 1 localhost  $HOST_PORT &> /dev/null" && echo 0 || echo 1)
  }
  # send response based on status
  [ "$lPORT_STATUS" -eq 0 ] && {
    jq -n \
    --arg status "open" \
    --arg host   "$HOST_IP" \
    --arg port   "$HOST_PORT" \
    '{status: $status, host: $host, port: $port}'
  } || {
    jq -n \
    --arg status "close" \
    --arg host   "$HOST_IP" \
    --arg port   "$HOST_PORT" \
    '{status: $status, host: $host, port: $port}'
    
  }
}


# get the status for several host:ports
# args: "$host" "$port01 ... portN" or "$port01 ... portN" ($host default to localhost)
vm_port_status_list() {
  # check arg
  [ "$#" -eq 2 ] && {
    local HOST_IP=$1
    local lPORTS=$2
  }

  [ "$#" -eq 1 ] && {
    local HOST_IP="localhost"
    local lPORTS=$1
  } 
  [ "$#" -eq 0 ] || [ "$#" -gt 2 ] && {
    luc_core_echo "warn" "bad number of arg"
    return 1
  }    
  #
  luc_core_echo "info" "check status port $HOST_IP:$lPORTS"
  for lPORT in $lPORTS; do
    vm_port_status_get $HOST_IP "$lPORT"
  done
}



# purpose: set local port forwarding
# args: <LOCAL_PORT> <RSERVER_PORT> <RSERVER_NAME>
luc_ssh_pf_set() {
  local lMSG_PURPOSE="set local port forwarding"  
  local lMSG_USAGE="$(luc_core_method_name_get) <LOCAL_PORT> <RSERVER_PORT> <RSERVER_NAME>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lLOCAL_PORT="$1" 
  local lRSERVER_PORT="$2" 
  local lRSERVER_NAME="$3" 

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lLOCAL_PORT"   ] ||
  [ -z "$lRSERVER_PORT" ] ||
  [ -z "$lRSERVER_NAME" ] ||
  [ "--help" == "$1"    ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # debu
  luc_core_echo "debu" "lLOCAL_PORT=$lLOCAL_PORT"
  luc_core_echo "debu" "lRSERVER_PORT=$lRSERVER_PORT"
  luc_core_echo "debu" "lRSERVER_NAME=$lRSERVER_NAME"

  # checkorexit local port is available
  luc_core_echo "chec" "local port is available"
  lECHOVAL=$(luc_ssh_port_local_is_available $lLOCAL_PORT); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1

  
  # checkorexit vm is reachable
  luc_core_echo "chec" "VM is ssh reachable"
  lECHOVAL=$(luc_ssh_vm_is_reachable $lRSERVER_NAME) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 3

  # checkorexit remote port is used and reachable
  luc_core_echo "chec" "remote port is used and reachable"
  lECHOVAL=$(luc_ssh_port_remote_is_reachable $lRSERVER_PORT $lRSERVER_NAME) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 3


  # set port forwarding
  luc_core_echo "step" "access remote port on localhost: $lLOCAL_PORT"
  lECHOVAL=$(ssh -f -N -L $lLOCAL_PORT:localhost:$lRSERVER_PORT $lRSERVER_NAME) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 4 

  # checkorexit server/port is onlie
  luc_core_echo "chec" "$lRSERVER_NAME:$lRSERVER_PORT is accessible via localhost:$lLOCAL_PORT"
  lECHOVAL=$(curl -I http://localhost:9000/) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && luc_core_echo "info" "All is OK. $lECHOVAL"
  

  # return
  return 0 
}

# purpose: unset local port forwarding
# args: <LOCAL_PORT>
luc_ssh_pf_unset() {
  local lMSG_PURPOSE="unset local port forwarding"  
  local lMSG_USAGE="$(luc_core_method_name_get) <LOCAL_PORT>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 
  local lLOCAL_PORT="$1" 

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 
  
  # checkorexit args are provided
  [ -z "$lLOCAL_PORT"   ] ||
  [ "--help" == "$1"    ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit local port is unavailable
  luc_core_echo "chec" "local port is unavailable"
  lECHOVAL=$(luc_ssh_port_local_is_available $lLOCAL_PORT); lRETVAL=$?  
  [ 0 -eq "$lRETVAL" ] && luc_core_echo "caut" "Port: $lLOCAL_PORT already free" && return 1

  
  # unset port forwarding
  luc_core_echo "step" "unset port forwarding on localhost: $lLOCAL_PORT"
  lECHOVAL=$(kill -9 $(lsof -t -i :$lLOCAL_PORT) > /dev/null 2>&1) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 4   

  # checkorexit port is available
  luc_core_echo "chec" "local port is available"
  lECHOVAL=$(luc_ssh_port_local_is_available $lLOCAL_PORT); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "caut" "lECHOVAL" && return 1

  # return
  return 0 
}

# purpose: get local port that is forward 
# args: <LOCAL_PORT>
luc_ssh_pf_list() {
  local lMSG_PURPOSE="get local port that is forward"  
  local lMSG_USAGE="$(luc_core_method_name_get) <LOCAL_PORT>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 12" 

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ "--help" == "$1"    ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # get list of listening port
  luc_core_echo "chec" "local port is available"
  lECHOVAL=$(lsof -nP -iTCP -sTCP:LISTEN | grep -v '::1'); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "caut" "pbs" && return 1

  # return
  echo "$lECHOVAL"
  return 0 
}

# purpose: check remote server is reachable
# note: helper function
# args: <RSERVER_NAME>
luc_ssh_vm_is_reachable() {
  local lMSG_PURPOSE="ssh check if a remote server port is reachable"
  local lMSG_USAGE="$(luc_core_method_name_get) <RSERVER_NAME> <RSERVER_PORT>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u 4000" 
  local lRSERVER_NAME="$1" 

  # checkorexit args are provided
  [ -z "$lRSERVER_NAME"   ] ||
  [ "--help" == "$1"    ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit vm is reachable
   lECHOVAL=$(ssh -v -o BatchMode=yes -o ConnectTimeout=2 $lRSERVER_NAME true >/dev/null 2>&1) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "VM is not reachable: $lRSERVER_NAME" && return 1 || return 0
  #

}
# purpose: check local port is available
# note: helper function
# args: <LOCAL_PORT>
luc_ssh_port_local_is_available() {
  local lMSG_PURPOSE="ssh check if a local port is available"  
  local lMSG_USAGE="$(luc_core_method_name_get) <LOCAL_PORT>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 4000" 
  local lLOCAL_PORT="$1" 

  # checkorexit args are provided
  [ -z "$lLOCAL_PORT"   ] ||
  [ "--help" == "$1"    ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit local port is available
  lECHOVAL=$(lsof -i :$lLOCAL_PORT); lRETVAL=$?  
  [ 0 -eq "$lRETVAL" ]  && echo "local port is in use by a process: $lECHOVAL" && return 1 || return 0   
}

# purpose: check if a remote server port is used and reachable
# note: helper function
# args: <RSERVER_PORT> <RSERVER_NAME> 
luc_ssh_port_remote_is_reachable() {
  local lMSG_PURPOSE="ssh check if a remote server port is used and reachable"  
  local lMSG_USAGE="$(luc_core_method_name_get) <RSERVER_NAME> <RSERVER_PORT>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o3u 4000" 
  local lRSERVER_PORT="$1" 
  local lRSERVER_NAME="$2" 

  # checkorexit args are provided
  [ -z "$lRSERVER_PORT" ] ||
  [ -z "$lRSERVER_NAME" ] ||
  [ "--help" == "$1"    ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  
  # checkorexit vm is reachable
   lECHOVAL=$(ssh $lRSERVER_NAME "lsof -i :$lRSERVER_PORT"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "remote port is not used by a process: $lRSERVER_NAME:$lRSERVER_PORT" && return 1
  #
  return 0  
}

# purpose: set port forwarding to and from remote server:port
# note: the remote port is extracted from podman on the server
# args: <LOCAL_PORT> <RSERVER_NAME> <CONTAINER_NAME>
luc_ssh_pf_jekyll_set() {
  local lMSG_PURPOSE="set port forwarding to and from remote server port"  
  local lMSG_USAGE="$(luc_core_method_name_get) <LOCAL_PORT> <RSERVER_NAME> <CONTAINER_NAME>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 9000 o3u mxc-jekyll" 
  local lLOCAL_PORT="$1" 
  local lRSERVER_NAME="$2" 
  local lCONTAINER_NAME="$3" 

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lLOCAL_PORT"   ] ||
  [ -z "$lRSERVER_NAME" ] ||
  [ -z "$lCONTAINER_NAME" ] ||
  [ "--help" == "$1"    ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  
  # checkorexit vm is reachable
  luc_core_echo "chec" "VM is ssh reachable"
  lECHOVAL=$(luc_ssh_vm_is_reachable $lRSERVER_NAME) ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 2

  # getorexit remote port
  luc_core_echo "step" "get remote host port from podman:container:$lCONTAINER_NAME"
  lECHOVAL=$(ssh o3u "podman port $lCONTAINER_NAME | cut -d: -f2") ; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "couls not get PORT" && return 3 || lRSERVER_PORT="$lECHOVAL"

  # getorexit remote port
  luc_core_echo "debu" "lRSERVER_PORT=$lRSERVER_PORT"
  luc_core_echo "step" "set port forwarding"
  luc_ssh_pf_set $lLOCAL_PORT $lRSERVER_PORT $lRSERVER_NAME
  
  # ssh o3u "podman port $lCONTAINER_NAME | awk -F':' '{print $1}' "
  # ssh o3u "podman port $lCONTAINER_NAME | awk '{print $3}' | cut -d: -f2"
  # ssh o3u "podman port $lCONTAINER_NAME "
  # lECHOVAL=$(luc_ssh_port_remote_is_reachable $lRSERVER_PORT $lRSERVER_NAME) ; lRETVAL=$?
  # [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 3

}





luc_core_service_status() {
  lpurpose="ckeck a service status"
  largs="<SERVICE_NAME>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) crio" 
  local lSERVICE_NAME="$1"  
  
  # PREREQUISIT
  # checkorexit args are provided
  [ -z "$lSERVICE_NAME" ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1


  ###### ACTION GET STATE
  lECHOVAL=$(echo "$(sudo systemctl is-active $lSERVICE_NAME),  $(sudo systemctl is-enabled $lSERVICE_NAME)" 2>&1); 
  
  # ###### REQUEST UNTIL TRANSIENT STATE IS OVER
  # while echo "$lECHOVAL" | grep -q "activating"; do
  #   sleep 2
  #   lECHOVAL=$(echo "$(sudo systemctl is-active $lSERVICE_NAME) AND $(sudo systemctl is-enabled $lSERVICE_NAME)" 2>&1)
  # done

  ###### ACTION DEFINE STATUS
  echo "$lECHOVAL" | grep -q -E '(activating|inactive|disabled)'  && echo "$lECHOVAL" && return 1 
  
  
  # RETURN
  echo "$lECHOVAL"
  return 0
}

luc_core_service_enable() {
  lpurpose="enable a service after rebbot"  
  largs="<SERVICE_NAME>"  
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) crio" 
  local lSERVICE_NAME="$1"  

  # PREREQUISIT
  # checkorexit args are provided
  [ -z "$lSERVICE_NAME" ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # ACTION
  sudo systemctl enable "$lSERVICE_NAME" &> /dev/null || {
    echo "❌ Failed to enable service: $lSERVICE_NAME" && return 1
  }
  
  # RETURN
  return 0
}

luc_core_service_start() {
  lpurpose="start a service after rebbot"
  largs="<SERVICE_NAME>"
  local lMSG_PURPOSE="start a service after rebbot"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) crio" 
  local lSERVICE_NAME="$1"  

  ####### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lSERVICE_NAME" ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ####### ACTION : START THE SERVICE
  sudo systemctl daemon-reload &> /dev/null
  lECHOVAL=$(sudo systemctl restart "$lSERVICE_NAME" 2>&1); lRETVAL=$?

  ####### RETURN
  echo "$lECHOVAL"
  return $lRETVAL
}

# purpose : list log for a service
# args: <SERVICE_NAME>
luc_core_service_log() {
  local lMSG_PURPOSE="list log for a service"  
  local lMSG_USAGE="$(luc_core_method_name_get) <SERVICE_NAME>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) crio" 
  local lSERVICE_NAME="$1"  

  # PREREQUISIT
  # checkorexit args are provided
  [ -z "$lSERVICE_NAME" ] ||
  [ "--help" == "$1"    ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # ACTION
  # sudo journalctl -u $lSERVICE_NAME --no-pager -n 50
  sudo journalctl -xeu $lSERVICE_NAME
  # RETURN
  return 0
}

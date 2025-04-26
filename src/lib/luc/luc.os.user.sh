
# purpose : create os:alpine sudo user
# constraint : user must be root
# args: <lNAME_USER_OS>
luc_core_os_alpine_user_sudo_provision() {
  local lNAME_USER_OS=$1
  local lUSAGE_MSG="$(luc_core_method_name_get) <lNAME_USER_OS>"

  # checkorexit args are provided
  [ -z "$lNAME_USER_OS" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12 test -v /tmp/luc:/test:ro"
    return 1
  }

  # create user
  adduser -D -g ${lNAME_USER_OS} -h /home/${lNAME_USER_OS} -s /bin/sh ${lNAME_USER_OS}
  # make it sudo
  adduser ${lNAME_USER_OS} wheel
  [ -d "/etc/doas.d" ] && echo "permit nopass :wheel as root" >> /etc/doas.d/doas.conf || echo "permit nopass :wheel as root" >> /etc/doas.conf
}

# purpose : create os:rocky sudo user
# constraint : user must be root
# args: <lNAME_USER_OS>
luc_core_os_rocky_user_sudo_provision() {
  local lNAME_USER_OS=$1
  local lUSAGE_MSG="$(luc_core_method_name_get) <lNAME_USER_OS>"

  # checkorexit args are provided
  [ -z "$lNAME_USER_OS" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12 test -v /tmp/luc:/test:ro"
    return 1
  }

  # create user
  useradd ${lNAME_USER_OS} -s /bin/bash -m
  # update ownership
  chown -R ${lNAME_USER_OS}:${lNAME_USER_OS} /home/${lNAME_USER_OS}
  # make it sudo
  usermod -aG wheel ${lNAME_USER_OS}
  mkdir -p /etc/sudoers.d/
  echo "$lNAME_USER_OS ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/sudo_${lNAME_USER_OS}
}

# purpose : create os:ubuntu sudo user
# constraint : user must be root
# args: <lNAME_USER_OS>
luc_core_os_ubuntu_user_sudo_provision() {
  local lNAME_USER_OS=$1
  local lUSAGE_MSG="$(luc_core_method_name_get) <lNAME_USER_OS>"
  luc_core_echo "purp" "provision sudo user on $lNAME_USER_OS" 

  # checkorexit args are provided
  [ -z "$lNAME_USER_OS" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12 test -v /tmp/luc:/test:ro" 
    return 1
  }

  # create user
  useradd ${lNAME_USER_OS} -s /bin/bash -m -d /home/${lNAME_USER_OS}
  # update ownership
  chown -R ${lNAME_USER_OS}:${lNAME_USER_OS} /home/${lNAME_USER_OS}
  # make it sudo  
  mkdir -p /etc/sudoers.d/
  echo "$lNAME_USER_OS ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/sudo_${lNAME_USER_OS}
}

# purpose : provision sudo os user
# constraint : user must be root
# args: <lNAME_USER_OS>
luc_core_os_user_sudo_provision() {
  local lNAME_USER_OS=$1
  local lDISTRO=$(luc_core_os_name_get)
  local lUSAGE_MSG="$(luc_core_method_name_get) <lNAME_USER_OS>"
  luc_core_echo "purp" "provision sudo user >  $lDISTRO:$lNAME_USER_OS"
  
  # checkorexit args are provided
  [ -z "$lNAME_USER_OS" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12 test -v /tmp/luc:/test:ro" 
    return 1
  }

  # checkorexit user as root
  luc_core_os_user_check_is_root || return 1

  # create sudo user as root
  case "$lDISTRO" in
    "alpine")          luc_core_os_alpine_user_sudo_provision "$lNAME_USER_OS" ;;
    "rocky"|"alma")    luc_core_os_rocky_user_sudo_provision  "$lNAME_USER_OS" ;;
    "ubuntu"|"debian") luc_core_os_ubuntu_user_sudo_provision "$lNAME_USER_OS" ;;
    "mac")             luc_core_echo "caut" "Done nothing" && retun 0 ;;
    *) luc_core_echo "warn" "$(luc_core_method_name_get) : unknow distro: $lDISTRO."; return 1 ;;
  esac
  

  # add user to group root
  [ "alpine" == "$lDISTRO" ] && addgroup $lNAME_USER_OS root || usermod -aG root $lNAME_USER_OS
  
  # add var to envfile
  luc_core_ve_set "luc_EV_NAME_USER_SUDO" "$lNAME_USER_OS"

  # done
  luc_core_echo "done"
  return 0
}

# purpose: Check User is root
# args: NONE
luc_core_os_user_check_is_root() {
  lERROR_MSG="$(luc_core_method_name_get) > user must be root"  
    
  [ -z "$EUID" ] && {
    lUSER_ID=$(id -u)
    [ "$lUSER_ID" -eq 0 ] && return 0 || luc_core_echo "warn" "$lERROR_MSG" && return 1
  }
  
  [ "$EUID" -eq 0 ] && return 0 || luc_core_echo "warn" "$lERROR_MSG" && return 1
}

# prerequisit: user must exists
# purpose : provision os user workspace
# args : <lNAME_OS_USER> <lNAME_WORKSPACE>
luc_core_os_user_workspace_provision() {
  local lNAME_USER_OS=$1
  local lNAME_WORKSPACE=$2
  local lWORKSPACE_PATH="/home/$lNAME_USER_OS/$lNAME_WORKSPACE"
  local lUSAGE_MSG="$(luc_core_method_name_get) <lNAME_USER_OS> <lNAME_WORKSPACE>"
  luc_core_echo "purp" "provision user worksapce >  $lNAME_USER_OS:$lNAME_WORKSPACE"

  # checkorexit args are provided
  [ -z "$lNAME_USER_OS" ]   ||
  [ -z "$lNAME_WORKSPACE" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12 test -v /tmp/luc:/test:ro" 
    return 1
  }  

  # checkorexit user exists
  ! id "$lNAME_USER_OS" &>/dev/null && luc_core_echo "warn" "$(luc_core_method_name_get) > User does not exists: $lNAME_USER_OS" && return 1
  
  # checkorexit folder exists
  [ -d "$lWORKSPACE_PATH" ] && luc_core_echo "done" "already" && return 0
  
  # create user:workspace
  mkdir ${lWORKSPACE_PATH} && chown ${lNAME_USER_OS}:${lNAME_USER_OS} ${lWORKSPACE_PATH}
  
  # # addorexit envar to envfile
  # lECHOVAL=$(luc_core_ve_set "luc_EV_NAME_USER_WORKSPACE" "$lNAME_WORKSPACE"); lRETVAL=$?
  # [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  
  # done
  luc_core_echo "done" && return 0
}

# purpose : usermod user
# constraint : must be sudo
# args : <lNAME_USER_OS> <NAME_GROUP>
luc_core_os_user_group_update() {
  local lNAME_USER_OS=$1
  local lNAME_GROUP=$2
  local lDISTRO=$(luc_core_os_name_get)
  local lUSAGE_MSG="$(luc_core_method_name_get) <lNAME_USER_OS> <NAME_GROUP>"
  luc_core_echo "purp" "update os user group"

  # checkorexit args are provided
  [ -z "$lNAME_USER_OS" ]   ||
  [ -z "$lNAME_GROUP" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12 test -v /tmp/luc:/test:ro" 
    return 1
  }  

  # checkorexit user exists
  ! id "$lNAME_USER_OS" &>/dev/null && luc_core_echo "warn" "$(luc_core_method_name_get) > User does not exists: $lNAME_USER_OS" && return 1

  # checkorexit group exists
  ! grep -w "$lNAME_GROUP" /etc/group &>/dev/null && luc_core_echo "warn" "$(luc_core_method_name_get) > Group does not exists: $lNAME_GROUP" && return 1

  [ "alpine" == "$lDISTRO" ] && doas sed -i 's/:1000:1000:/:1000:0:/' /etc/passwd || sudo usermod -g "$lNAME_GROUP" "$lNAME_USER_OS"
  return 0
}

# purpose : add user to another group
# constraint : must be sudo
# args : <lNAME_USER_OS> <NAME_GROUP>
luc_core_os_user_group_add() {
  local lNAME_USER_OS=$1
  local lNAME_GROUP=$2
  local lDISTRO=$(luc_core_os_name_get)
  local lUSAGE_MSG="$(luc_core_method_name_get) <lNAME_USER_OS> <NAME_GROUP>"
  luc_core_echo "purp" "update os user group"

  # checkorexit args are provided
  [ -z "$lNAME_USER_OS" ]   ||
  [ -z "$lNAME_GROUP" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) 12 test -v /tmp/luc:/test:ro" 
    return 1
  }  

  # checkorexit user exists
  ! id "$lNAME_USER_OS" &>/dev/null && luc_core_echo "warn" "$(luc_core_method_name_get) > User does not exists: $lNAME_USER_OS" && return 1

  # checkorexit group exists
  ! grep -w "$lNAME_GROUP" /etc/group &>/dev/null && luc_core_echo "warn" "$(luc_core_method_name_get) > Group does not exists: $lNAME_GROUP" && return 1

  [ "alpine" == "$lDISTRO" ] && doas addgroup "$lNAME_USER_OS" "$lNAME_GROUP" || sudo usermod -aG "$lNAME_GROUP" "$lNAME_USER_OS"
  return 0
}

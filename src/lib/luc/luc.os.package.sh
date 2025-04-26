
# luc_core_os_check_package_is_installed() {
#   lpurpose="ckeck an OS package is installed"
#   largs="<PACKAGE>"
#   local lOS_DISTRO=$(luc_core_os_name_get)
#   local lMSG_PURPOSE="$lpurpose"  
#   local lMSG_USAGE="$(luc_core_method_name_get) $args"  
#   local lPACKAGE_NAME="$1"  

#   # checkorexit args are provided
#   [ -z "$lPACKAGE_NAME" ] ||
#   [ "--help" == "$1"    ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

#   # upgrade package
#   case "$lOS_DISTRO" in
#     "rocky"|"alma"|"fedora") luc_core_os_rocky_check_package_is_installed  $lPACKAGE_NAME ;;
#     "ubuntu"|"debian")       luc_core_os_ubuntu_check_package_is_installed $lPACKAGE_NAME;;
#   esac
# }

# purpose : update os packages
# constraint: must be played as root 
# args: NONE
luc_core_os_package_update() {
  local lOS_DISTRO=$(luc_core_os_name_get)
  local lMSG_PURPOSE="update os packages for $lOS_DISTRO"  
  luc_core_echo "purp" "$lMSG_PURPOSE"

  # checkorexit user is root
  lECHOVAL=$(luc_core_os_user_check_is_root); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # upgrade package
  case "$lOS_DISTRO" in
    "alpine")          luc_core_os_alpine_package_update ;;
    "rocky"|"alma")    luc_core_os_rocky_package_update ;;
    "ubuntu"|"debian") luc_core_os_ubuntu_package_update ;;
    "mac")             luc_core_echo "caut" "Done nothing" && retun 0 ;;
    *) luc_core_echo "warn" "$(luc_core_method_name_get) : unknow distro: $lOS_DISTRO."; return 1 ;;
  esac

  return 0
}

# purpose : upgrade os packages
# constraint: must be played as root 
# args: NONE
luc_core_os_package_upgrade() {
  local lOS_DISTRO=$(luc_core_os_name_get)
  local lMSG_PURPOSE="upgrade os packages for $lOS_DISTRO"  
  luc_core_echo "purp" "$lMSG_PURPOSE"

  # checkorexit user is root
  lECHOVAL=$(luc_core_os_user_check_is_root); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

  # upgrade package
  case "$lOS_DISTRO" in
    "alpine")          luc_core_os_alpine_package_upgrade ;;
    "rocky"|"alma")    luc_core_os_rocky_package_upgrade ;;
    "ubuntu"|"debian") luc_core_os_ubuntu_package_upgrade ;;
    "mac")             luc_core_echo "caut" "Done nothing" && retun 0 ;;
    *) luc_core_echo "warn" "$(luc_core_method_name_get) : unknow distro: $lOS_DISTRO."; return 1 ;;
  esac

  return 0
}

# prereq: must be played as sudo user
luc_core_os_package_provision() {
  lpurpose="provision os packages"
  largs="provision os packages"
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) ruby-full build-essential zlib1g-dev" 
  local lOS_PACKAGE_LIST="$@"
  local lOS_DISTRO=$(luc_core_os_name_get)
  local lMSG_PURPOSE="$lpurpose : $lOS_PACKAGE_LIST"  

  # checkorexit args are provided
  [ -z "$lOS_PACKAGE_LIST" ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # CHOICE
  case "$lOS_DISTRO" in
    "ubuntu"|"debian")       
      lECHOVAL=$(luc_core_os_ubuntu_package_provision $lOS_PACKAGE_LIST); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
      ;;
    "rocky"|"alma"|"fedora")
      lECHOVAL=$(luc_core_os_rocky_package_provision $lOS_PACKAGE_LIST); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
      ;;
    "alpine")                luc_core_os_alpine_package_provision $lOS_PACKAGE_LIST ;;
  esac

  return 0

}


# # purpose: remote provision OS packages
# # constraint: must be played as sudo user
# # args: <VM_NAME> <VM_DISTRO> <PACKAGE01> <PACKAGE02> ...
# luc_core_os_package_provision_remote() {
#   local lMSG_PURPOSE="remote provision OS packages"  
#   local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <VM_DISTRO> <PACKAGE01> <PACKAGE02> ..."  
#   local lMSG_EXAMPLE="$(luc_core_method_name_get) ruby-full build-essential zlib1g-dev" 
#   local lVM_NAME="$1"
#   local lOS_DISTRO="$2"
#   shift 2; local lOS_PACKAGE_LIST="$@"

#   ###### PREREQUISIT
#   # checkorexit args are provided
#   [ -z "$lOS_DISTRO"          ] ||
#   [ -z "$lVM_NAME"         ] ||
#   [ -z "$lOS_PACKAGE_LIST" ] ||
#   [ "--help" == "$1"       ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

#   ###### CHOICE
#   case "$lOS_DISTRO" in
#     "ubuntu"|"debian") luc_core_os_ubuntu_package_provision_remote $lVM_NAME $lOS_PACKAGE_LIST ;;
#     "rocky"|"alma")    luc_core_os_rocky_package_provision_remote  $lVM_NAME $lOS_PACKAGE_LIST ;;
#     *) echo "unknow distro: $lOS_DISTRO"; return 1 ;;
#   esac

#   ###### RETURN
#   return 0

# }

# purpose : update and upgrade os:alpine packages
# constraint: must be played as root 
# args: NONE
luc_core_os_alpine_package_upgrade() {
  apk upgrade &> /dev/null
  # apk update && apk upgrade && apk add --no-cache --quiet doas
}


# purpose : update and upgrade os:rocky packages
# constraint: must be played as root (this point is not checked)
# note: TODO TODO TODO - not use that code for prod
# note: code is different for containers and VM
# args: NONE
luc_core_os_rocky_package_upgrade() {
  ## CODE FOR VM
  dnf upgrade -q -y &> /dev/null

  ## CODE FOR CONTAINERS
  # dnf update -q -y && dnf upgrade -q -y && dnf install -q -y sudo > /dev/null
  # # SECURITY ISSUES - workaround for "sudo su -" to work - ONLY FOR DEV  !!!!
  # cp -r /etc/pam.d/ /etc/pamd.origin
  # rm -rf /etc/pam.d/*
  # echo -e "#%PAM-1.0\nauth required pam_permit.so\naccount required pam_permit.so\npassword required pam_permit.so\nsession required pam_permit.so" > /etc/pam.d/other
}


# constraint: must be played as root 
# purpose : update and upgrade os:ubuntu packages
# args: NONE
luc_core_os_ubuntu_package_upgrade() {
  ## for VM
  DEBIAN_FRONTEND=noninteractive apt  upgrade -qq -y  &> /dev/null
  ## for CONTAINER
  # apt update -qq -y > /dev/null && DEBIAN_FRONTEND=noninteractive apt  upgrade -qq -y && DEBIAN_FRONTEND=noninteractive apt install -qq -y sudo > /dev/null
}


# purpose : provision os:alpine packages
# constraint: must be played as sudo user
# args: <PACKAGE01> <PACKAGE02> ...
luc_core_os_alpine_package_provision() {
  lOS_PACKAGE_LIST="$@"

  doas apk update && doas apk upgrade && doas apk add --no-cache --quiet $lOS_PACKAGE_LIST
  doas rm -f /var/cache/apk/*
}

# prereq: must be played as sudo user
luc_core_os_rocky_package_provision() {
  lpurpose="provision os:rocky packages"
  largs="lOS_PACKAGE_LIST"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) ruby-full build-essential zlib1g-dev" 
  local lOS_PACKAGE_LIST="$@"

  # checkorexit args are provided
  [ -z "$lOS_PACKAGE_LIST" ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # ACTION : PROVISION PACKAGE
  lECHOVAL=$(dnf install -q -y $lOS_PACKAGE_LIST &> /dev/null); lRETVAL=$?
  lECHOVAL=$(dnf update -q -y &> /dev/null); lRETVAL=$?
  lECHOVAL=$(dnf clean all    &> /dev/null); lRETVAL=$?
  
  ACTION : CHECK PROVISIONING
  for lPACKAGE_NAME in $lOS_PACKAGE_LIST; do
    dnf list installed "$lPACKAGE_NAME" &>/dev/null || {
      echo "package not installed : $lPACKAGE_NAME" && return 1
    } 
  done
  
 
}

# prereq: must be played as sudo user
luc_core_os_ubuntu_package_provision() {
  lpurpose="provision os:ubuntu packages"
  largs="<PACKAGE01> <PACKAGE02> ..."
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) ruby-full build-essential zlib1g-dev" 
  local lOS_PACKAGE_LIST="$@"

  # checkorexit args are provided
  [ -z "$lOS_PACKAGE_LIST" ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  ###### ACTION : PROVISION PACKAGE
  luc_core_echo "doin" "providion"
  lECHOVAL=$(DEBIAN_FRONTEND=noninteractive apt install -qq -y $lOS_PACKAGE_LIST &> /dev/null); lRETVAL=$?
  lECHOVAL=$(DEBIAN_FRONTEND=noninteractive apt update -qq -y  &> /dev/null ); lRETVAL=$?
  lECHOVAL=$(DEBIAN_FRONTEND=noninteractive apt -qq clean      &> /dev/null ); lRETVAL=$?
  
  ###### ACTION : CHECK PROVISIONING
  luc_core_echo "chec" "provisioning"
  for lPACKAGE_NAME in $lOS_PACKAGE_LIST; do
    dpkg -l | grep -q "$lPACKAGE_NAME" || {
    echo "package not installed : $lPACKAGE_NAME" && return 1
  }
  done

  # RETURN
  return 0
}

# # purpose : remote provision os:debian|ubuntu with os:packages
# # constraint: must be played as sudo user
# # args: <VM_NAME> <PACKAGE> <PACKAGE> ...
# luc_core_os_ubuntu_package_provision_remote() {
#   local lMSG_PURPOSE="remote provision os:debian|ubuntu with os:packages"  
#   local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME>"  
#   local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
#   local lCLI
#   local lVM_NAME="$1" 
#   shift; local lOS_PACKAGE_LIST="$@"

#   # purpose
#   luc_core_echo "purp" "$lMSG_PURPOSE > $lOS_PACKAGE_LIST"

#   ###### PREREQUISIT
#   # luc_core_echo "chec" "args are provided"
#   [ -z "$lVM_NAME"         ] ||
#   [ -z "$lOS_PACKAGE_LIST" ] ||
#   [ "--help" == "$1"       ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  


#   # ssh $lVM_NAME "sudo apt update -qq -y > /dev/null && sudo apt upgrade -qq -y && sudo DEBIAN_FRONTEND=noninteractive apt install -qq -y $lOS_PACKAGE_LIST"
#   # ssh $lVM_NAME "sudo apt -qq clean"

#   # ssh "$lVM_NAME" "sudo apt update -qq -y > /dev/null 2>&1 && sudo apt upgrade -qq -y > /dev/null 2>&1 && sudo DEBIAN_FRONTEND=noninteractive apt install -qq -y "$lOS_PACKAGE_LIST" > /dev/null 2>&1"
#   # ssh "$lVM_NAME" "sudo apt -qq clean > /dev/null 2>&1"
#   lCLI="sudo bash -c \"DEBIAN_FRONTEND=noninteractive apt install -qq -y $lOS_PACKAGE_LIST  &> /dev/null \""
#   luc_core_vm_cli_run "$lVM_NAME" "$lCLI"
#   lCLI="sudo bash -c \"DEBIAN_FRONTEND=noninteractive apt  update -qq -y  &> /dev/null \""
#   luc_core_vm_cli_run "$lVM_NAME" "$lCLI"

#   ###### CHECK PROVISIONING

#   ###### RETURN
#   return 0

# }

# # purpose : remote provision os:rocky|alma with os:packages
# # args: <VM_NAME> <PACKAGE> <PACKAGE> ...
# luc_core_os_rocky_package_provision_remote() {
#   local lMSG_PURPOSE="remote provision os:rocky|alma with os:packages"  
#   local lMSG_USAGE="$(luc_core_method_name_get) <PACKAGE> <PACKAGE> ..."  
#   local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u yum-utils" 
#   local lCLI
#   local lVM_NAME="$1"
#   shift; local lOS_PACKAGE_LIST="$@"

#   # purpose
#   luc_core_echo "purp" "$lMSG_PURPOSE > $lOS_PACKAGE_LIST"

#   ###### PREREQUISIT
#   # luc_core_echo "chec" "args are provided"
#   [ -z "$lVM_NAME"      ] ||
#   [ -z "$lOS_PACKAGE_LIST" ] ||
#   [ "--help" == "$1"    ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

#   # ssh "$lVM_NAME" "sudo dnf update -q -y  && sudo dnf upgrade -q -y && sudo dnf install -q -y $lOS_PACKAGE_LIST "
#   # ssh "$lVM_NAME" "sudo dnf clean all"

#   # ssh "$lVM_NAME" "sudo dnf update -q -y > /dev/null 2>&1 && sudo dnf upgrade -q -y > /dev/null 2>&1 && sudo dnf install -q -y "$lOS_PACKAGE_LIST" > /dev/null 2>&1"
#   # ssh "$lVM_NAME" "sudo dnf clean all > /dev/null 2>&1"

#   ###### ACTION INSTALL
#   lCLI="sudo bash -c \"dnf install -qq -y $lOS_PACKAGE_LIST  &> /dev/null \""
#   luc_core_vm_cli_run "$lVM_NAME" "$lCLI"

#   ###### ACTION UPDATE
#   # lCLI="sudo bash -c \"sudo dnf update -q -y > /dev/null 2>&1 \""
#   lCLI="sudo bash -c \"sudo dnf update -q -y &> /dev/null  \""
#   luc_core_vm_cli_run "$lVM_NAME" "$lCLI"

#   ###### CHECK PROVISIONING ##################### 
#   ###### RETURN
#   return 0

# }


# purpose : ckeck an OS:rocky|almalfedora package is installed
# args: <PACKAGE>
luc_core_os_rocky_check_package_is_installed() {
  local lOS_DISTRO=$(luc_core_os_name_get)
  local lMSG_PURPOSE="ckeck an OS package is installed"  
  local lPACKAGE_NAME="$1"  


  ##### ACTION : lookup package
  dnf list installed "$lPACKAGE_NAME" &>/dev/null || {
    echo "package not installed : $lPACKAGE_NAME" && return 1
  } 

  ##### RETURN
  return 0
}

# purpose : ckeck an OS:ubuntu|debian package is installed
# args: <PACKAGE_NAME>
luc_core_os_ubuntu_check_package_is_installed() {
  local lOS_DISTRO=$(luc_core_os_name_get)
  local lMSG_PURPOSE="ckeck an OS package is installed"  
  local lMSG_USAGE="$(luc_core_method_name_get) <PACKAGE_NAME>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) cri-o" 
  local lPACKAGE_NAME="$1"  
  
  ###### PREREQUISIT
  # luc_core_echo "chec" "args are provided"
  [ -z "$lPACKAGE_NAME" ] ||
  [ "--help" == "$1"    ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  
  ##### ACTION : lookup package
  dpkg -l | grep -q "$lPACKAGE_NAME" || {
    echo "package not installed : $lPACKAGE_NAME" && return 1
  }

  ##### RETURN
  return 0
}

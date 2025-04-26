# purpose: SSH play CLI into a VM
# prereq: the vm is configured in a file like .ssh/config.d/xxx
# prereq: the vm is ssh reachable
# args: <VM_NAME> <CLI> 
luc_core_vm_cli_run() {
  local lMSG_PURPOSE="play CLI into a remote VM with ssh"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <CLI>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u 'ls -l'" 
  local lVM_NAME="$1" 
  local lCLI="$2"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"   ] ||
  [ -z "$lCLI"       ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit VM is reachable
  lECHOVAL=$(luc_core_vm_check_is_ssh_reachable $lVM_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1
  
  ###### ACTION : SSH PLAY CLI
  lECHOVAL=$(ssh "$lVM_NAME" "$lCLI"); lRETVAL=$?
  
  ###### RETURN
  echo   "$lECHOVAL"; 
  return "$lRETVAL"
}


# purpose : update and upgrade a VM:OS (packages and kernel version)
# prereq: the vm is configured in a file like .ssh/config.d/xxx
# prereq: the vm is ssh reachable
# args: <VM_NAME> <VM_DISTRO>
luc_core_vm_os_upgrade() {
  local lMSG_PURPOSE="update and upgrade a VM:OS packages and kernel"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <VM_DISTRO>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u rocky" 
  local lVM_NAME="$1"
  local lVM_DISTRO="$2"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"   ] ||
  [ -z "$lVM_DISTRO" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### CHOICE
  case "$lVM_DISTRO" in
    "rocky"|"alma"|"fedora") 
      lECHOVAL=$(luc_core_vm_os_rocky_upgrade  "$lVM_NAME" "$lVM_DISTRO" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 2
      ;;
    "ubuntu"|"debian")       
      lECHOVAL=$(luc_core_vm_os_ubuntu_upgrade  "$lVM_NAME" "$lVM_DISTRO" 2>&1); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 3
       ;;
    *) echo "unknow distro: $lVM_DISTRO"; return 4 ;;
  esac

  ###### RETURN
  return 0
}


# purpose : update and upgrade a VM:OS:rocky|alma|feodra (packages and kernel version)
# prereq: the vm is configured in a file like .ssh/config.d/xxx
# prereq: the vm is ssh reachable
# args: <VM_NAME> <VM_DISTRO>
luc_core_vm_os_rocky_upgrade() {
  local lMSG_PURPOSE="update and upgrade a VM:OS:rocky|alma|feodra (packages and kernel version)"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <VM_DISTRO>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lVM_NAME="$1"
  local lVM_DISTRO="$2"
  local lCLI

  ###### PREREQUISIT
  # args are provided
  [ -z "$lVM_NAME"   ] ||
  [ -z "$lVM_DISTRO" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit VM_DISTRO
  lECHOVAL=$(luc_core_check_string_is_inlist "$lVM_DISTRO" "rocky|alma|feodra"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 2

  ###### ACTION UPDATE & UPGRADE OS
  lCLI="sudo bash -c \"dnf update -q -y &> /dev/null && dnf upgrade -qq -y &> /dev/null \""
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
  
  # RETURN
  echo   "$lECHOVAL"
  return $lRETVAL
}

# purpose : update and upgrade a VM:OS:ubuntu|debian (packages and kernel version)
# prereq: the vm is configured in a file like .ssh/config.d/xxx
# prereq: the vm is ssh reachable
# args: <VM_NAME> <VM_DISTRO>
luc_core_vm_os_ubuntu_upgrade() {
  local lMSG_PURPOSE="update and upgrade a VM:OS:ubuntu|debian (packages and kernel version)"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <VM_DISTRO>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lVM_NAME="$1"
  local lVM_DISTRO="$2"
  local lCLI 

  ###### PREREQUISIT
  # check args are provided
  [ -z "$lVM_NAME"   ] ||
  [ -z "$lVM_DISTRO" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1


  # checkorexit VM_DISTRO
  lECHOVAL=$(luc_core_check_string_is_inlist "$lVM_DISTRO" "ubuntu|debian"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 2  

  ###### ACTION UPDATE & UPGRADE OS
  lCLI="sudo bash -c \"DEBIAN_FRONTEND=noninteractive apt update -q -y &> /dev/null &&  DEBIAN_FRONTEND=noninteractive apt upgrade -qq -y &> /dev/null \""
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI" 2>&1); lRETVAL=$?
  ## tail -f /var/log/apt/term.log
  
  # RETURN
  echo   "$lECHOVAL"
  return $lRETVAL
}


# purpose: check a VM is ssh reachable
# note: the vm is configued in a file .ssh/config.d/xxx and is reachable
# note: no other echo inside the code - helper function - the return value and code are used
# args: <VM_NAME>
luc_core_vm_check_is_ssh_reachable() {
  local lMSG_PURPOSE="check a VM is ssh reachable"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lVM_NAME="$1" 


  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"   ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION : SSH PLAY CLI
  lECHOVAL=$(ssh $lVM_NAME true 2>&1 ); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "VM is not reachable: $lVM_NAME - $lECHOVAL" 
  
  ###### RETURN
  return "$lRETVAL"
}

# purpose : check a VM:OS need reboot after updates
# note: no other echo inside the code - helper function - the return value and code are used
# args: <VM_NAME>
luc_core_vm_os_check_need_reboot() {
  local lMSG_PURPOSE="check a VM:OS need reboot after updates"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u rocky" 
  local lVM_NAME=$1
  local lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"   ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit VM is reachable
  lECHOVAL=$(luc_core_vm_check_is_ssh_reachable $lVM_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1

  ###### ACTION DEFINE VAR

  ###### CHOICE
  case "$lVM_DISTRO" in
    "alpine") lECHOVAL="TODO"; lRETVAL=$? ;;
    "rocky"|"alma"|"feodra")    
       lCLI="echo \$(needs-restarting -r) | grep -q \"Reboot is required\" && echo yes ||  echo no"
       lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
        ;;
    "ubuntu"|"debian") 
       lCLI="[ -f /var/run/reboot-required ] && echo yes ||  echo no"
       lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
        ;;
    *) echo "unknow distro: $lDISTRO."; return 1 ;;
  esac
  
  ##### RETURN
  echo "$lECHOVAL"
  return 0
}

# purpose : reboot a VM
# note: no other echo inside the code - helper function - the return value and code are used
# args: <VM_NAME>
luc_core_vm_reboot() {
  local lMSG_PURPOSE="reboot a VM"
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lVM_NAME=$1

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"   ] ||
  [ "--help" == "$1" ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit VM is reachable
  lECHOVAL=$(luc_core_vm_check_is_ssh_reachable $lVM_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1

  ###### ACTION: REBOOT THE VM
  # sutdown -r now (works)
  local lCLI="sudo bash -c \"reboot\""
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
  sleep 1

  ###### ACTION: WAIT FOR VM TO BE SSH REACHABME
  until ssh "$lVM_NAME" "true"  2>/dev/null; do
    luc_core_echo "info" "Waiting for $lVM_NAME to come back online..."
    sleep 3  # Wait 3 seconds before retrying
  done

  ##### RETURN
  return 0
}  


# purpose: Remote get a VM property
# note: the vm is configured in a file .ssh/config.d/xxx and is reachable
# note: no other echo inside the code - helper function - the return value and code are used
# args: <VM_NAME> <PROPERTY>
luc_core_vm_property_get() {
  local lMSG_PURPOSE="Remote get a VM property"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <PROPERTY>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u user|ip" 
  local lVM_NAME="$1" 
  local lPROPERTY="$2"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"     ] ||
  [ -z "$lPROPERTY"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit VM is reachable
  lECHOVAL=$(luc_core_vm_check_is_ssh_reachable $lVM_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  
  ###### ACTION : GET THE PROPERTY
  lCHOICE="$(echo "$lPROPERTY" | tr '[:upper:]' '[:lower:]')"
  lRETVAL="" ; lECHOVAL=""
  case "$lCHOICE" in
    os:distro)
     lCLI='cat /etc/os-release | grep "^ID=" | sed "s/ID=//" | sed "s/\"//g" | sed "s/linux//" '
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    os:init)
     lCLI="ps -p 1 -o comm="
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    os:cgroup)
     lCLI="cat /proc/self/mountinfo | grep cgroup | cut -d'-' -f2"
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    os:kernel:version)
     lCLI="uname -r"
      lECHOVAL=$(ssh "$lVM_NAME" "uname -r")
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    sysctl)
     lCLI="echo TODO"
     lECHOVAL=$($lCLI); lRETVAL=$?
      ;;
    user)
     lCLI="id -un"
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    cpu)
     lCLI="nproc"
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    ram)
     lCLI="free -th | grep Total | awk '{print \$2}'"
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    net:route)
     lCLI="ip route show | grep -i default"
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    net:ip)
     lCLI="ip -br a | grep -v lo"
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    net:ifname)
     lCLI="ip -brief link show | grep -v lo | awk '{print \$1}'"
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    net:mac)
     lCLI="ip -brief link show | grep -v lo | awk '{print \$1 , \$3}'"
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    net:uuid)
     lCLI="sudo bash -c \"cat /sys/class/dmi/id/product_uuid\""
     lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
      ;;
    ip)
     lECHOVAL=$(ssh -G $lVM_NAME | grep '^hostname ' | awk '{print $2}'); lRETVAL=$?
      ;;
    *)
     lECHOVAL="porperty not yet managed > VM > $lVM_NAME > $lPROPERTY"; lRETVAL=1
      ;;
  esac

  ###### RETURN
  echo "$lECHOVAL"
  return 0

}


# purpose: Remote play CLI in a set of VMs
# note: the vm is configured in a file .ssh/config.d/xxx and is reachable
# args: <CLI> 
luc_core_vm_all_cli_run() {
  local lMSG_PURPOSE="Remote play CLI in a VM"  
  local lMSG_USAGE="$(luc_core_method_name_get) <CLI>"  
  local lMSG_EXAMPLE="
  $(luc_core_method_name_get) 'ls -l'
  $(luc_core_method_name_get) 
  " 
  local lLIST_VM="o1u o2a o3r o4d"
  local lCLI="$1"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

    
  ###### ACTION : SSH PLAY CLI
  [ -z "$lCLI" ] && {
    # lCLI="rm -rf /tmp/luc-bash"
    # lCLI="ls /tmp/"
    # lCLI="uname -r"
    # lCLI="ls /var/run/reboot-required"
    # lCLI="cat /var/run/reboot-required"
    # lCLI="cat /var/run/reboot-required.pkgs" # - ubuntu and debian
    # lCLI="needs-restarting -r" # rocky
    # lCLI="/sbin/sysctl --version"
    # lCLI="ps -p 1 -o comm="
    # lCLI="which add-apt-repository"
    # lCLI="dnf config-manager --help"
    # lCLI="cat /proc/self/mountinfo"
    # lCLI="cat /proc/self/mountinfo | grep cgroup | cut -d'-' -f2"
    # lCLI="lsb_release -a"
    # lCLI="cat /etc/os-release"
    # lCLI="sudo bash -c \"xxx\""
    # lCLI="sudo bash -c \"rm -rf /etc/apt/sources.list.d/k8se*\""
    lCLI="sudo bash -c \"rm -rf /etc/yum.repos.d/k8se*\""
    # lCLI="ls -ial"

  }
  luc_core_echo "debu" "lCLI     : $lCLI"
  luc_core_echo "debu" "lLIST_VM : $lLIST_VM"
  for vm in $lLIST_VM; do echo $vm ; ssh "$vm" "$lCLI"; done

  ###### RETURN 
  return 0

}



# purpose : provision a VM:OS with OS packages
# prereq: the vm is configured in a file like .ssh/config.d/xxx
# prereq: the vm is ssh reachable
# args: <VM_NAME> <PACKAGE01> <PACKAGE02>
luc_core_vm_os_package_provision() {
  local lMSG_PURPOSE="provision a VM:OS with OS packages"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <PACKAGE01> <PACKAGE02> ..."  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u gnupgp" 
  local lVM_NAME="$1"
  shift; local lOS_PACKAGE_LIST="$@"
  local lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lVM_NAME"      ] ||
  [ -z "$lOS_PACKAGE_LIST" ] ||
  [ "--help" == "$1"    ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit VM is reachable
  lECHOVAL=$(luc_core_vm_check_is_ssh_reachable $lVM_NAME); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL" && return 1

  ###### ACTION DEFINE VAR

  ###### CHOICE
  case "$lVM_DISTRO" in
    "rocky"|"alma"|"fedora") 
      lECHOVAL=$(luc_core_vm_os_rocky_package_provision  "$lVM_NAME" $lOS_PACKAGE_LIST); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 2
      ;;
    "ubuntu"|"debian")       
      lECHOVAL=$(luc_core_vm_os_ubuntu_package_provision  "$lVM_NAME" $lOS_PACKAGE_LIST ); lRETVAL=$?
      [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 3
      ;;
    *) echo "unknow distro: $lVM_DISTRO"; return 4 ;;
  esac

  ###### RETURN
  return 0
}


# purpose: provision a VM:OS:rocky|alma|feodra with OS packages
# prereq: the vm is configured in a file like .ssh/config.d/xxx
# prereq: the vm is ssh reachable
# args: <VM_NAME> <PACKAGE01> <PACKAGE02>
luc_core_vm_os_rocky_package_provision() {
  local lMSG_PURPOSE="provision a VM:OS:rocky|alma|feodra with OS packages"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <PACKAGE01> <PACKAGE02>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lVM_NAME="$1"
  shift; local lOS_PACKAGE_LIST="$@"
  local lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
  
  ###### PREREQUISIT
  # args are provided
  [ -z "$lVM_NAME"      ] ||
  [ -z "$lOS_PACKAGE_LIST" ] ||
  [ "--help" == "$1"    ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit VM is reachable
  lECHOVAL=$(luc_core_vm_check_is_ssh_reachable "$lVM_NAME"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  ###### ACTION DEFINE VAR

  # checkorexit OS is mahaged - duplicated code below - cf. luc_core_vm_property_get
  lECHOVAL=$(luc_core_check_string_is_inlist "$lVM_DISTRO" "rocky|alma|feodra"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 2

  ###### ACTION INSTALL PACKAGE AND UPDATE
  lCLI="sudo bash -c \"dnf install -q -y $lOS_PACKAGE_LIST &> /dev/null && dnf update -q -y &> /dev/null && dnf clean all  &> /dev/null  \""
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
    

  # RETURN
  echo   "$lECHOVAL"
  return $lRETVAL
}

# purpose: provision a VM:OS:ubuntu|debian with OS packages
# prereq: the vm is configured in a file like .ssh/config.d/xxx
# prereq: the vm is ssh reachable
# args: <VM_NAME> <PACKAGE01> <PACKAGE02>
luc_core_vm_os_ubuntu_package_provision() {
  local lMSG_PURPOSE="provision a VM:OS:ubuntu|debian with OS packages"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <PACKAGE01> <PACKAGE02>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lVM_NAME="$1"
  local lVM_DISTRO="$(luc_core_vm_property_get $lVM_NAME os:distro)"
  shift; local lOS_PACKAGE_LIST="$@"

  ###### PREREQUISIT
  # args are provided
  [ -z "$lVM_NAME"         ] ||
  [ -z "$lOS_PACKAGE_LIST" ] ||
  [ "--help" == "$1"       ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  # checkorexit VM is reachable
  lECHOVAL=$(luc_core_vm_check_is_ssh_reachable "$lVM_NAME"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1
  echo titi

  ###### ACTION DEFINE VAR

  # checkorexit OS is mahaged - duplicated code below - cf. luc_core_vm_property_get
  lECHOVAL=$(luc_core_check_string_is_inlist "$lVM_DISTRO" "ubuntu|debian"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 2

  ###### ACTION INSTALL PACKAGE AND UPDATE
  lCLI="sudo bash -c \"DEBIAN_FRONTEND=noninteractive apt install -qq -y $lOS_PACKAGE_LIST &> /dev/null && DEBIAN_FRONTEND=noninteractive apt update -qq -y &> /dev/null && DEBIAN_FRONTEND=noninteractive apt -qq clean     &> /dev/null   \""
  lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?

  # RETURN
  echo   "$lECHOVAL"
  return $lRETVAL
}


# purpose: rsync a folder from local to a remote VM
# prereq: the vm is configured in a file like .ssh/config.d/xxx
# prereq: the vm is ssh reachable
# args: <VM_NAME> <FOLDER_SRC> <FOLDER_DST>
luc_core_vm_folder_rsync() {
  local lMSG_PURPOSE="rsync a folder from local to a remote VM"  
  local lMSG_USAGE="$(luc_core_method_name_get) <VM_NAME> <FOLDER_SRC> <FOLDER_DST>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u /folder_src /folder_dst" 
  local lVM_NAME="$1"
  local lFOLDER_SRC="$2"
  local lFOLDER_DST="$3"
  
  ###### PREREQUISIT
  # args are provided
  [ -z "$lVM_NAME"    ] ||
  [ -z "$lFOLDER_SRC" ] ||
  [ -z "$lFOLDER_DST" ] ||
  [ "--help" == "$1"    ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit VM is reachable
  lECHOVAL=$(luc_core_vm_check_is_ssh_reachable "$lVM_NAME"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # checkorexit folder source exists
  lECHOVAL=$(luc_core_check_folder_exits $lFOLDER_SRC); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 2

  # ###### INFO  ##################
  # luc_core_echo "debu" "lFOLDER_LUC_HOME_SRC: $lFOLDER_LUC_HOME_SRC"
  # luc_core_echo "debu" "lFOLDER_LUC_HOME_DST: $lVM_NAME > $lFOLDER_LUC_HOME_DST"

  ###### ACION: REMOTE COPY FOLDER  ################## 
  # luc_core_echo "step" "provision folder : $lFOLDER_LUC_HOME_SRC"
  # note: --delete => files at dest that not exists in src
  # note: ending / => the folder content is copied not the folder
  lECHOVAL=$(rsync -av --delete --quiet $lFOLDER_SRC/ ${lVM_NAME}:$lFOLDER_DST/); lRETVAL=$?

  ###### CHECK PROVISIONING ##################### 
  # luc_core_echo "chec" "LUC folder exists"
  # lCLI="sudo bash -c \"dnf install -q -y $lOS_PACKAGE_LIST &> /dev/null && dnf update -q -y &> /dev/null && dnf clean all  &> /dev/null  \""
  # lECHOVAL=$(luc_core_vm_cli_run "$lVM_NAME" "$lCLI"); lRETVAL=$?
  # ssh ${lVM_NAME} "ls $lFOLDER_LUC_HOME_DST" > /dev/null  || return 1

  # RETURN
  echo   "$lECHOVAL"
  return $lRETVAL
}



# example
# luc_core_vm_all_cli_run 'sudo bash -c "rm -rf /etc/apt/sources.list.d/k8se* ; rm -rf /etc/yum.repos.d/k8se*"'
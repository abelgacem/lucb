#!/bin/bash

# Section.Description > Script.Bash > Configure > Tool : Ssh
## - centos:8
## - ubuntu:20.04

# Prerequisit
## Play > Create > User:Folder


# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Other


##########################################
# Method                                ##
##########################################
alias mxt-define-ssh-conf="mxt-ssh-conf-define"
function mxt-ssh-conf-define() {
  # Define > Var
  lFileSrcName="key.ssh.priv.vm.ovh"
  lFileSrcFolder="/Users/max/Documents/NotInCloud/RepoDevops/secret/keyssh"
  lListVmDst="o1u o2c"
  lFileDstFolder="/tmp"
  lFileSrcPath="${lFileSrcFolder}/${lFileSrcName}"
  lFileDstPath="${lFileDstFolder}/${lFileName}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Install > Ovh : Key.Priv > to > Vm > $lListVmDst:/tmp"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  #[ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action 
  lAction="for vm in ${lListVmDst}; do scp ${lFileSrcPath} ${vm}:${lFileDstFolder}; done"
  #echo -e "      - Degub > Play > Cli > ${lAction}" 
  eval ${lAction};
}

##########################################
# Action                                ##
##########################################
mxt-ssh-conf-define
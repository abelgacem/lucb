#!/bin/bash

# Section.Description > Script.Bash > Configure > Tool : Ssh
## - centos:8
## - ubuntu:20.04

# Prerequisit
## Create > User:Folder
## Copy > Key.Priv > to > /tmp


# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Other


##########################################
# Method                                ##
##########################################
alias mx-provision-key-priv-ovh="mx-key-priv-ovh-provision"
function mx-key-priv-ovh-provision() {
  # Dependency
  # Define > Var
  lFileSrcName="key.ssh.priv.vm.ovh"
  lFileFolderSrc="/tmp"
  lFileFolderDst="${HOME}/.ssh/secret/keyssh"
  lFileSrcPath="${lFileFolderSrc}/${lFileSrcName}"
  lFileDstPath="${lFileFolderDst}/${lFileSrcName}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Install > Ovh : Key.Priv"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action 
  lAction="cp ${lFileSrcPath} ${lFileDstPath} && chmod 600 ${lFileDstPath}"
  #echo -e "      - Degub > Play > Cli > ${lAction}" 
  eval ${lAction};
}

##########################################
# Action                                ##
##########################################
mx-key-priv-ovh-provision
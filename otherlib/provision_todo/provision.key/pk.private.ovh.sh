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
  lFileFolderDst="${HOME}/debug/secret/keyssh"
  lFileSrcPath="${lFileFolderSrc}/${lFileSrcName}"
  lFileDstPath="${lFileFolderDst}/${lFileSrcName}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Provision > File > ${lFileDstPath}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Check > file.Src > Exists
  [ -f ${lFileSrcPath} ] || { echo -e "File > Not Exists > ${lFileSrcPath}"; return; }
  # Check > folder.Dst > Exists
  #[ -d ${lFileFolderDst} ] || { echo -e "Folder > Not Exists > ${lFileFolderDst}"; return; }
  # Action
  #mkdir -p ${lFileFolderDst} && chmod 644 ${lFileFolderDst}
  #lAction="mkdir -p ${lFileFolderDst} && chmod 600 ${lFileFolderDst}"
  lAction="mkdir -p ${lFileFolderDst} && chmod -R 700 ${lFileFolderDst} && cp ${lFileSrcPath} ${lFileDstPath} && chmod 600 ${lFileDstPath}"
  #lAction="mkdir -p ${lFileFolderDst} && cp ${lFileSrcPath} ${lFileDstPath} && chmod -R 600 ${lFileFolderDst}"
  echo -e "Mx > Play > Cli > ${lAction}" 
  eval ${lAction};
  # Check.Post > File > Exists
  lAction="ls ${lFileDstPath}"
  lResult="$(${lAction})"
  printf "Mx > Check.Post > File > Exists > ${lResult}\n"

}

##########################################
# Action                                ##
##########################################
mx-key-priv-ovh-provision
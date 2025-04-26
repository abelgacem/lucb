#!/bin/bash

# Section.Description > Script.Bash > Configure > Tool : Ssh
## - centos:8
## - ubuntu:20.04

# Prerequisit
## Create > User:Folder


# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Other


##########################################
# Method                                ##
##########################################
alias mxo-provision-var-global="mxo-var-global-provision"
function mxo-var-global-provision() {
  # Dependency
  # Define > Var
  lFileName="mx.sh"
  lFileFolder="${HOME}/debug"
  lFilePath="${lFileFolder}/${lFileName}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Provision > File > ${lFilePath}"
  # Check.pre > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check.pre > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Check.pre > folder > exists
  [ -d ${lFileFolder} ] || { printf "Mx > Warning > Folder : ${lFileFolder} > NotExists (Create It Now)\n"; mkdir -p ${lFileFolder}; }
  # Check.pre > folder > exists
  [ -d ${lFileFolder} ] || { printf "Mx > Error > Folder : ${sGitPathRoot} > NotExists (Cannot Create it)\n"; return; }
  # Action
  cat <<EOM > "${lFilePath}"
  # ${lFilePath}  
  # Alias.Global
  source ~/debug/var/mx.var.sh
  source ~/debug/var/mx.terraform.sh
EOM
  chmod 700 ${lFilePath}
  # Check.Post > File > Exists
  lAction="ls ${lFilePath}"
  lResult="$(${lAction})"
  printf "Mx > Check.Post > File > Exists > ${lResult}\n"
}

##########################################
# Action                                ##
##########################################
mxo-var-global-provision
#!/bin/bash

# Section.Description > Script.Bash > Provision (i.e install) > Os:Package.Basic
## - centos:8
## - ubuntu:20.04

# Dependency
# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## List
sTreeFolder="${gUserTree}"

##########################################
# Method                                ##
##########################################
alias mxo-provision-user-folder="mxo-user-folder-provision"
function mxo-user-folder-provision() {
  # Define > Var
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  #echo -e "sTreeFolder = ${sTreeFolder}"
  ## Other
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Create > User : Folder > ${sTreeFolder}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Check > App > exists
  AppName="tree"; which ${AppName} || { printf "Mx > Error > App : ${AppName} > NotExists \n"; return; }
  # Action 
  lAction="mkdir -p ${sTreeFolder}"
  echo -e "Mx > Play > Cli > ${lAction}" 
  eval ${lAction};
  # Check.Post > Folder > Exists
  lAction="tree -a -L 3 ${HOME}"
  printf "Mx > Check.Post > Tree > Exists > $(${lAction})\n"

}

##########################################
# Action                                ##
##########################################
mxo-user-folder-provision
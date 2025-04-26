#!/bin/bash

# Section.Description > Script.Bash > Provision (i.e install) > Os:Package.Basic
## - centos:8
## - ubuntu:20.04

# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## List
sListPackage="tree"

##########################################
# Method                                ##
##########################################
alias mxt-provision-basic="mxt-basic-provision"
function mxt-basic-provision() {
  # Dependency
  source /etc/os-release
  # Define > Var
  ## Simulate > AssociativeArray
  declare -A OsInstall
  OsInstall["centos:8"]="sudo dnf install -y ${sListPackage}"
  OsInstall["ubuntu:20.04"]="sudo apt-get install -y ${sListPackage}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  ## From > Dependency
  lOsType=${ID}
  lOsVersion=${VERSION_ID}
  ## Other
  lOsFqdn="${lOsType}:${lOsVersion}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Provision > Tool.Basic > for > Os > ${lOsFqdn}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action 
  ## TODO > Check > Os > Is > managed/or not > By > Code { echo -e 'OS: Not managed'; return; })
  lAction=${OsInstall["${lOsFqdn}"]}
  #echo -e "      - Degub > Play > Cli > ${lAction}" 
  eval ${lAction};
}

##########################################
# Action                                ##
##########################################
mxt-basic-provision
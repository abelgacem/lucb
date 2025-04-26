#!/bin/bash

# Section.Description > Script.Sh > Install > Docker > on > Os:Linux
## centos:8
## ubuntu:20.04

# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Other

##########################################
# Method                                ##
##########################################
alias mxt-provision-java="mxt-java-provision"
function mxt-java-provision() {
  # Dependency
  source /etc/os-release
  # Define > Var
  ## Simulate > AssociativeArray
  declare -A OsInstall
  OsInstall["centos:8"]="sudo dnf install -y xxxs"
  OsInstall["ubuntu:20.04"]="sudo apt-get install -y openjdk-16-jre-headless"
  OsInstall["ubuntu:21.04"]="${OsInstall['ubuntu:20.04']}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  ## From > Dependency
  lOsType=${ID}
  lOsVersion=${VERSION_ID}
  ## Other
  lOsFqdn="${lOsType}:${lOsVersion}"
  # Info
  echo "Mx > Play   > Script > ${lDebugPath}"
  echo "Mx > Action > Provision > Tool.Middleware  > Javas  > for > Os > ${lOsFqdn}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; } #|| { echo "Info > User > is > NotRoot"; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action
  lAction=${OsInstall["${lOsFqdn}"]}
  echo "Mx > Play   > CLI > ${lAction}"
  eval ${lAction}
}

##########################################
# Action                                ##
##########################################
mxt-java-provision



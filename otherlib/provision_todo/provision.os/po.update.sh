#!/bin/bash

# Section.Description > Script.Bash > Update & Upgrade > Os.Linux:PackageManager & Os.Linux:Library
## - centos:8
## - ubuntu:20.04

# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Other

##########################################
# Method                                ##
##########################################
alias mxo-update="mxo-update"
function mxo-update() {
  # Dependency
  source /etc/os-release
  # Define > Var
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  ## Simulate > AssociativeArray
  declare -A OsInstall
  OsInstall["almalinux:8.4"]="sudo dnf update -y && sudo dnf upgrade -y"
  OsInstall["centos:8"]="sudo dnf update -y && sudo dnf upgrade -y"
  OsInstall["ubuntu:20.04"]="sudo apt-get update -y && sudo apt-get upgrade -y"
  ## From > Dependency
  lOsType=${ID}
  lOsVersion=${VERSION_ID}
  ## Other
  lOsFqdn="${lOsType}:${lOsVersion}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Update & Upgrade > Os.Linux:PackageManager & Os.Linux:Library > for > Os > ${lOsFqdn}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action 
  ## TODO > Check > Os > Is > managed/or not > By > Code { echo -e 'OS: Not managed'; return; })
  lAction=${OsInstall["${lOsFqdn}"]}
  # Action
  echo "Mx > Cli    > ${lAction}"
  eval ${lAction};
}

##########################################
# Action                                ##
##########################################
mxo-update
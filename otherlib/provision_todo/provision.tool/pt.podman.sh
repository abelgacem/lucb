#!/bin/bash

# Section.Description > Script.Sh > Install > Podman > on > Os:Linux
## centos:8
## ubuntu:20.04

# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Other

##########################################
# Prerequisit                           ##
##########################################
function mxt-podman-install-prerequisit-ubuntu-20.04() {
  # Define > Var    
  lFileName="podman.list"
  lFileFolder="/etc/apt/sources.list.d"
  lFilePath="${lFileFolder}/${lFileName}"
  lUrl01="http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${lOsVersion}/"
  lUrl02="https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${lOsVersion}/Release.key"
  echo "deb ${lUrl01} /" | sudo tee ${lFilePath};
  sudo wget --quiet -O - ${lUrl02} | sudo apt-key add -
  sudo apt-get update -y;
}
##########################################
# Method                                ##
##########################################
alias mx-install-podman="mxt-podman-install"
mxt-podman-install() {
  # Dependency
  source /etc/os-release
  # Define > Var
  ## Simulate > AssociativeArray
  declare -A OsInstall
  OsInstall["centos:8"]="sudo dnf install -y podman"
  OsInstall["ubuntu:20.04"]="sudo apt-get install -y podman"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  ## From > Dependency
  lOsType=${ID}
  lOsVersion=${VERSION_ID}
  ## Other
  lOsFqdn="${lOsType}:${lOsVersion}"
  # Info
  echo "Mx > Play > Script > ${lDebugPath}"
  echo "Mx > Action > Provision > Tool  > Podman  > for > Os > ${lOsFqdn}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Warning > User > is > Root => Exit"; return; } #|| { echo "Info > User > is > NotRoot"; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action
  lAction=${OsInstall["${lOsFqdn}"]}
  mxt-podman-install-prerequisit-${lOsFqdn/:/-};      # Call Function. Replace char ':' by char '/' in var ${lOsFqdn}
  eval ${lAction}
}

##########################################
# Action                                ##
##########################################
mxt-podman-install
unset -f mxt-podman-install-prerequisit-ubuntu-20.04

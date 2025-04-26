#!/bin/bash

# Section.Description > Script.Bash > Provision > Tool > Git > for > Os
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
# Prerequisit                           ##
##########################################
function mxt-git-install-prerequisit-ubuntu-20.04() {
  ## Update > Repo.Apt > to > latest
  sudo apt-get update -y;
  ## Upgrade > package.All:Version > to > latest
  sudo apt-get upgrade -y;
}
##########################################
# Method                                ##
##########################################
alias mxt-provision-git="mxt-git-provision"
function mxt-git-provision() {
  # Dependency
  source /etc/os-release
  # Define > Var
  ## Simulate > AssociativeArray
  declare -A OsInstall
  OsInstall["almalinux:8.4"]="sudo dnf update -y && sudo dnf upgrade -y"
  OsInstall["centos:8"]="sudo dnf install -y git"
  OsInstall["ubuntu:20.04"]="mx-git-install-prerequisit-ubuntu-20.04"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  ## From > Dependency
  lOsType=${ID}
  lOsVersion=${VERSION_ID}
  ## Other
  lOsFqdn="${lOsType}:${lOsVersion}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Provision > Tool > Git > for > Os > ${lOsFqdn}"
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
  echo -e "      - Degub > Play > Cli > ${lAction}" 
  #eval ${lAction};
}
##########################################
# Action                                ##
##########################################
mxt-git-install
unset -f mxt-git-install-prerequisit-ubuntu-20.04

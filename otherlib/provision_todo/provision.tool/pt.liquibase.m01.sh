#!/bin/bash

# Section.Description > Script.Sh > Install > Docker > on > Os:Linux
## centos:8
## ubuntu:20.04

# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## liquibase
sUrlDomain="github.com/liquibase/liquibase/releases/download/v4.7.1"
sUrlFile="liquibase-4.7.1.tar.gz"
sFolderTmp="/tmp"
sFolderDestPath="/usr/local"
sFolderDestName="liquibase"
##########################################
# Method                                ##
##########################################
mxt-liquibase-download() {
  echo -e "Mx > Download > Liquibase > to > Folder > ${sFolderTmp}/${sUrlFile}"
  lAction="curl -o ${sFolderTmp}/${sUrlFile} -L ${sUrlDomain}/${sUrlFile}"
  # echo -e "Play  > ${lAction}"
  eval ${lAction}
}
##########################################
# Method                                ##
##########################################
mxt-liquibase-config() {
  [ -d ${sFolderDestPath}/${sFolderDestName} ] && { echo -e "Mx > Already > Configured"; return; }
  echo -e "Mx > Configure > liquibase > to > Folder > ${sFolderDestPath}/${sFolderDestName}"
  sudo mkdir -p ${sFolderDestPath}/${sFolderDestName}
  sudo tar xzf  ${sFolderTmp}/${sUrlFile} -C ${sFolderDestPath}/${sFolderDestName}
  echo -e "Mx > Update > \$PATH > to > .bash_profile"
  echo  "PATH=$PATH:${sFolderDestPath}/${sFolderDestName}" >> ~/.bash_profile
}
##########################################
# Method                                ##
##########################################
alias mxt-provision-liquibase="mxt-liquibase-provision"
function mxt-liquibase-provision() {
  # Dependency
  source /etc/os-release
  # Define > Var
  ## Simulate > AssociativeArray
  declare -A OsInstall
  OsInstall["linux-x86-64"]="echo xxxx"
  OsInstall["almalinux:8.5"]="${OsInstall['linux-x86-64']}"
  OsInstall["centos:8"]="${OsInstall['linux-x86-64']}"
  OsInstall["ubuntu:20.04"]="${OsInstall['linux-x86-64']}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  ## From > Dependency
  lOsType=${ID}
  lOsVersion=${VERSION_ID}
  ## Other
  lOsFqdn="${lOsType}:${lOsVersion}"
  
  # Info
  echo "Mx > Play   > Script > ${lDebugPath}"
  echo "Mx > Action > Provision > Tool  > liquibase  > for > Os > ${lOsFqdn}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; } #|| { echo "Info > User > is > NotRoot"; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action
  mxt-liquibase-download;
  mxt-liquibase-config;
}

##########################################
# Action                                ##
##########################################
mxt-liquibase-provision
unset -f mxt-liquibase-download
unset -f mxt-liquibase-config



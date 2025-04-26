#!/bin/bash

# Section.Description > Script.Sh > Install > Docker > on > Os:Linux
## centos:8
## ubuntu:20.04

# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Jre
sUrlDomain="cdn.azul.com/zulu/bin"
sUrlFile="zulu17.32.13-ca-jre17.0.2-linux_x64.tar.gz"
sFolderTmp="/tmp"
sFolderDestPath="/usr/local"
sFolderDestName="jre"
##########################################
# Method                                ##
##########################################
mxt-jre-download() {
  echo -e "Mx > Download > Jre > to > Folder > ${sFolderTmp}/${sUrlFile}"
  lAction="curl -o ${sFolderTmp}/${sUrlFile} -L ${sUrlDomain}/${sUrlFile}"
  # echo -e "Play  > ${lAction}"
  eval ${lAction}
}
##########################################
# Method                                ##
##########################################
mxt-jre-config() {
  [ -d ${sFolderDestPath}/${sFolderDestName} ] && { echo -e "Mx > Already > Configured"; return; }
  echo -e "Mx > Configure > Jre > to > Folder > ${sFolderDestPath}/${sFolderDestName}"
  sudo tar xzf  ${sFolderTmp}/${sUrlFile} -C ${sFolderDestPath}
  sudo ln -s ${sFolderDestPath}/${sUrlFile/.tar.gz/}  ${sFolderDestPath}/${sFolderDestName}
  echo -e "Mx > Update > \$PATH > to > .bash_profile"
  echo  "PATH=$PATH:${sFolderDestPath}/${sFolderDestName}/bin" >> ~/.bash_profile
}
##########################################
# Method                                ##
##########################################
alias mxt-provision-jre="mxt-jre-provision"
function mxt-jre-provision() {
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
  echo "Mx > Action > Provision > Tool  > Jre  > for > Os > ${lOsFqdn}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; } #|| { echo "Info > User > is > NotRoot"; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action
  mxt-jre-download;
  mxt-jre-config;
  # lAction=${OsInstall["${lOsFqdn}"]}
  #mxt-jre-install-prerequisit-${lOsFqdn/:/-};     # Call Function. Replace char ':' by char '/' in var ${lOsFqdn}
  #eval ${lAction}; 
  #mxt-jre-install-postrequisit-${lOsFqdn/:/-};    # Call Function. Replace char ':' by char '/' in var ${lOsFqdn}
  #sudo usermod -aG docker $USER; # Add > User.Current > to > froup > Docker
}

##########################################
# Action                                ##
##########################################
mxt-jre-provision
unset -f mxt-jre-download
unset -f mxt-jre-config



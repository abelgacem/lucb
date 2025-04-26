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
# Prerequisit                           ##
##########################################
function mxt-docker-install-prerequisit-ubuntu-21.04() {
  mxt-docker-install-prerequisit-ubuntu-20.04
}
function mxt-docker-install-prerequisit-ubuntu-20.04() {
  # Define > Var    
  lFileName="docker.list"
  lFileFolder="/etc/apt/sources.list.d"
  lFilePath="${lFileFolder}/${lFileName}"
  lUrl01="https://download.docker.com/linux/ubuntu"
  lUrl02="https://download.docker.com/linux/ubuntu/gpg"
  echo "deb [arch=amd64] ${lUrl01} ${VERSION_CODENAME} stable" | sudo tee ${lFilePath};
  sudo wget --quiet -O - ${lUrl02} | sudo apt-key add -
  sudo apt-get update -y;
}
##########################################
# Prerequisit                           ##
##########################################
function mxt-docker-install-prerequisit-centos-8() {
  # Define > Var    
  lRepoYum=/etc/yum.repos.d/
  lRepoFile=docker-ce.repo
  lRepoUrl=https://download.docker.com/linux/centos/${lRepoFile}
  # Provision Repo.(Yum, Docker)
  sudo dnf install -y wget
  sudo wget -P ${lRepoYum} ${lRepoUrl}
}
##########################################
# Prerequisit                           ##
##########################################
function mxt-docker-install-prerequisit-almalinux-8.4() {
  # Define > Var    
  lRepoYum=/etc/yum.repos.d/
  lRepoFile=docker-ce.repo
  lRepoUrl=https://download.docker.com/linux/centos/${lRepoFile}
  # Provision Repo.(Yum, Docker)
  sudo dnf install -y wget
  sudo wget -P ${lRepoYum} ${lRepoUrl}
}
##########################################
# Postrequisit                          ##
##########################################
function mxt-docker-install-postrequisit-almalinux-8.4() {
  sudo systemctl enable --now docker
}
##########################################
# Postrequisit                          ##
##########################################
function mxt-docker-install-postrequisit-centos-8() {
  sudo systemctl enable --now docker
}
##########################################
# Postrequisit                          ##
##########################################
function mxt-docker-install-postrequisit-ubuntu-21.04() {
  mxt-docker-install-postrequisit-ubuntu-20.04
}

function mxt-docker-install-postrequisit-ubuntu-20.04() {
  sudo systemctl enable --now docker
  #sudo systemctl disable firewalld
}
##########################################
# Method                                ##
##########################################
mxt-dockercompose-install() {
  lFileNameBin=docker-compose
  lFileName=${lFileNameBin}-$(uname -s)-$(uname -m)
  lFileUrl=https://github.com/docker/compose/releases/download/1.29.2/${lFileName}
  lFilePath=/usr/bin
  ## Copy File
  sudo curl -L ${lFileUrl} -o ${lFilePath}/${lFileNameBin}
  sudo chmod +x ${lFilePath}/${lFileNameBin}
}
##########################################
# Method                                ##
##########################################
alias mxt-provision-docker="mxt-docker-provision"
function mxt-docker-provision() {
  # Dependency
  source /etc/os-release
  # Define > Var
  ## Simulate > AssociativeArray
  declare -A OsInstall
  OsInstall["almalinux:8.4"]="sudo dnf update -y && sudo dnf upgrade -y"
  OsInstall["centos:8"]="sudo dnf install -y docker-ce --nobest --allowerasing && mxt-dockercompose-install"
  OsInstall["ubuntu:20.04"]="sudo apt-get install -y docker-ce && mxt-dockercompose-install"
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
  echo "Mx > Action > Provision > Tool  > Docker  > for > Os > ${lOsFqdn}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; } #|| { echo "Info > User > is > NotRoot"; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action
  lAction=${OsInstall["${lOsFqdn}"]}
  mxt-docker-install-prerequisit-${lOsFqdn/:/-};     # Call Function. Replace char ':' by char '/' in var ${lOsFqdn}
  eval ${lAction}; 
  mxt-docker-install-postrequisit-${lOsFqdn/:/-};    # Call Function. Replace char ':' by char '/' in var ${lOsFqdn}
  sudo usermod -aG docker $USER; # Add > User.Current > to > froup > Docker
}

##########################################
# Action                                ##
##########################################
mxt-docker-provision
unset -f mxt-docker-install-prerequisit-ubuntu-20.04
unset -f mxt-docker-install-prerequisit-centos-8

unset -f mxt-docker-install-postrequisit-centos-8
unset -f mxt-docker-install-postrequisit-ubuntu-20.04

unset -f mxt-dockercompose-install



#!/bin/bash

# Section.Description > Script.Sh > Install > HasiCorp:Terraform > on > Os:Linux
## centos:8
## ubuntu:20.04

# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Other
sToolName="Terraform"

##########################################
# Prerequisit                           ##
##########################################
function mxt-terraform-install-prerequisit-ubuntu-21.04() {
  mxt-terraform-install-prerequisit-ubuntu-20.04
}
function mxt-terraform-install-prerequisit-ubuntu-20.04() {
  # Define > Var    
  lFileName="hashicorp.list"
  lFileFolder="/etc/apt/sources.list.d"
  lFilePath="${lFileFolder}/${lFileName}"
  lUrl01="https://apt.releases.hashicorp.com"
  lUrl02="https://apt.releases.hashicorp.com/gpg"
  echo "deb [arch=amd64] ${lUrl01} ${VERSION_CODENAME} main" | sudo tee ${lFilePath};
  sudo wget --quiet -O - ${lUrl02} | sudo apt-key add -
  sudo apt-get update -y;
}
##########################################
# Prerequisit                           ##
##########################################
function mxt-terraform-install-prerequisit-centos-8() {
  # Define > Var    
  lRepoYum=/etc/yum.repos.d/
  lRepoFile=hashicorp.repo
  lRepoUrl=https://rpm.releases.hashicorp.com/RHEL/${lRepoFile}
  # Provision Repo.(Yum, terraform)
  sudo dnf install -y wget
  sudo wget -P ${lRepoYum} ${lRepoUrl}
}
##########################################
# Prerequisit                           ##
##########################################
function mxt-terraform-install-prerequisit-almalinux-8.5() {
  # Define > Var    
  lRepoYum=/etc/yum.repos.d/
  lRepoFile=hashicorp.repo
  lRepoUrl=https://rpm.releases.hashicorp.com/RHEL/${lRepoFile}
  # Provision Repo.(Yum, terraform)
  sudo dnf install -y wget
  sudo wget -P ${lRepoYum} ${lRepoUrl}
}
##########################################
# Method                                ##
##########################################
alias mxt-provision-terraform="mxt-terraform-provision"
function mxt-terraform-provision() {
  # Dependency
  source /etc/os-release
  # Define > Var
  ## Simulate > AssociativeArray
  declare -A OsInstall
  OsInstall["almalinux:8.5"]="sudo dnf install -y terraform"
  OsInstall["centos:8"]="sudo dnf install -y terraform"
  OsInstall["ubuntu:20.04"]="sudo apt-get install -y terraform"
  OsInstall["ubuntu:21.04"]="${OsInstall['ubuntu:20.04']}"
  # mxt-terraform-install-prerequisit-ubuntu-21.04="mxt-terraform-install-prerequisit-ubuntu-20.04"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  ## From > Dependency
  lOsType=${ID}
  lOsVersion=${VERSION_ID}
  ## Other
  lOsFqdn="${lOsType}:${lOsVersion}"
  # Info
  echo "Mx > Play   > Script > ${lDebugPath}"
  echo "Mx > Action > Provision > Tool  > terraform  > for > Os > ${lOsFqdn}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; } #|| { echo "Info > User > is > NotRoot"; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action
  lAction=${OsInstall["${lOsFqdn}"]}
  echo -e "debug - lAction = ${lAction}"
  echo -e "debug - prereq = mxt-terraform-install-prerequisit-${lOsFqdn/:/-}"
  mxt-terraform-install-prerequisit-${lOsFqdn/:/-};     # Call Function. Replace char ':' by char '/' in var ${lOsFqdn}
  eval ${lAction}; 
}

##########################################
# Action                                ##
##########################################
mxt-terraform-provision
unset -f mxt-terraform-install-prerequisit-ubuntu-20.04
unset -f mxt-terraform-install-prerequisit-ubuntu-21.04
unset -f mxt-terraform-install-prerequisit-centos-8



#!/bin/bash

# Section.Description > Script.Sh > Install > Gitlab (As Container) > on > Os:Linux
## centos:8
## ubuntu:20.04

# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
sGitlabDockerRepository="gitlab/gitlab-ee"
sGitlabDockerImageTag="14.8.2-ee.0"
## Other

# Gitlab as docker Container
# DB.External Postgres

# SMTP Server for mail : External > Postfix or Sendmail
# MTA = Mail Transport Agent

# Gitlab Version 14.1

sudo docker pull gitlab/gitlab-ee:14.8.2-ce.0
export GITLAB_HOME=/srv/gitlab

##########################################
# Prerequisit                           ##
##########################################
function mxt-gitlab-install-prerequisit-ubuntu-21.04() {
  mxt-gitlab-install-prerequisit-ubuntu-20.04
}
function mxt-gitlab-install-prerequisit-ubuntu-20.04() {
}
##########################################
# Prerequisit                           ##
##########################################
function mxt-gitlab-install-prerequisit-centos-8() {
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
function mxt-gitlab-install-prerequisit-almalinux-8.4() {
  # Define > Var    
  lRepoYum=/etc/yum.repos.d
  lRepoFile=docker-ce.repo
  lRepoUrl=https://download.docker.com/linux/centos/${lRepoFile}
  # Provision Repo.(Yum, Docker)
  sudo dnf install -y wget
  sudo wget -P ${lRepoYum} ${lRepoUrl}
}
##########################################
# Postrequisit                          ##
##########################################
function mxt-gitlab-install-postrequisit-almalinux-8.4() {
  sudo systemctl enable --now docker
}
##########################################
# Postrequisit                          ##
##########################################
function mxt-gitlab-install-postrequisit-centos-8() {
  sudo systemctl enable --now docker
}
##########################################
# Postrequisit                          ##
##########################################
function mxt-gitlab-install-postrequisit-ubuntu-20.04() {
  sudo systemctl enable --now docker
  #sudo systemctl disable firewalld
}
##########################################
# Method                                ##
##########################################
alias mxt-provision-gitlab="mxt-gitlab-provision"
function mxt-gitlab-provision() {
  # Dependency
  source /etc/os-release
  # Define > Var
  ## Folder
  lGitlabRootFolder="/srv/container/vol"
  lFileFolder="${HOME}/.docker"
  lFilePath="${lFileFolder}/${lFileName}"

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
  echo "Mx > Action > Provision > Tool  > Gitlab  > for > Os > ${lOsFqdn}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; } #|| { echo "Info > User > is > NotRoot"; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  
  # Action
  docker pull ${sGitlabDockerRepository}:${sGitlabDockerImageTag}

  # lAction=${OsInstall["${lOsFqdn}"]}
  # mxt-docker-install-prerequisit-${lOsFqdn/:/-};     # Call Function. Replace char ':' by char '/' in var ${lOsFqdn}
  # eval ${lAction}; 
  # mxt-docker-install-postrequisit-${lOsFqdn/:/-};    # Call Function. Replace char ':' by char '/' in var ${lOsFqdn}
}

##########################################
# Action                                ##
##########################################
mxt-gitlab-provision
unset -f mxt-gitlab-install-prerequisit-ubuntu-20.04
unset -f mxt-gitlab-install-prerequisit-centos-8
unset -f mxt-gitlab-install-postrequisit-centos-8
unset -f mxt-gitlab-install-postrequisit-ubuntu-20.04



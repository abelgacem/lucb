#!/bin/bash

# Section.Description > Script.Bash > Configure > Tool : Ssh
## - centos:8
## - ubuntu:20.04

# Prerequisit
## Create > User:Folder


# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Other


##########################################
# Method                                ##
##########################################
alias mxo-provision-var-global="mxo-var-global-provision"
function mxo-var-global-provision() {
  # Dependency
  # Define > Var
  lFileName="mx.terraform.sh"
  lFileFolder="${HOME}/debug/var"
  lFilePath="${lFileFolder}/${lFileName}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Provision > File > ${lFilePath}"
  # Check.pre > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check.pre > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Check.pre > folder > exists
  [ -d ${lFileFolder} ] || { printf "Mx > Warning > Folder : ${lFileFolder} > NotExists (Create It Now)\n"; mkdir -p ${lFileFolder}; }
  # Check.pre > folder > exists
  [ -d ${lFileFolder} ] || { printf "Mx > Error > Folder : ${sGitPathRoot} > NotExists (Cannot Create it)\n"; return; }
  # Action
  cat <<EOM > "${lFilePath}"
  # ${lFilePath}
  # Var.Global
  # Alias.Global
  alias cdterra='cd /tmp/terraform'
  alias ti='terraform init'
  alias tg='terraform get'
  alias tp='terraform plan'
  alias td='terraform destroy -auto-approve'
  alias ta='terraform apply -auto-approve'
  alias tc='rm -rf .terraform.lock.hcl && rm -rf terraform.tfstate* && rm -rf mxfile0*'
EOM
  # Check.Post > File > Exists
  lAction="ls ${lFilePath}"
  lResult="$(${lAction})"
  printf "Mx > Check.Post > File > Exists > ${lResult}\n"
}

##########################################
# Action                                ##
##########################################
mxo-var-global-provision
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
  lFileName="mx.var.sh"
  lFileFolder="/etc/profile.d"
  lFilePath="${lFileFolder}/${lFileName}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Provision > Var  > Global"
  echo "Mx > Action > Create > File > ${lFilePath}"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action
  cat <<EOM  | sudo tee "${lFilePath}"  >/dev/null
  # ${lFilePath
  # Var.Global
  export gUserTree="\${HOME}/{.ssh,debug/{git,lib,var,secret/keyssh}}"
  export gUserSecretFolder="\${HOME}/debug/secret"
  export gUserKeySshFolder="\${HOME}/debug/secret/keyssh"
  # Alias.Global
  alias srcb='source \${HOME}/mx.sh'
  alias ll='ls -ial'
  alias    h='history'
  alias  psa='ps -ef'
EOM
}

##########################################
# Action                                ##
##########################################
mxo-var-global-provision
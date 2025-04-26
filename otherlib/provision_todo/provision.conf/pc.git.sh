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
# Method                                ##
##########################################
alias mxt-provision-git-conf="mxt-git-conf-provision"
mxt-git-conf-provision() {
  # Define > Var
  lFileName=".gitconfig"
  lFileFolder="${HOME}"
  lFilePath="${lFileFolder}/${lFileName}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Provision > conf > Git"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Warning > User > is > Root => Exit"; return; } #|| { echo "Info > User > is > NotRoot"; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action
  #printf "Create > ${lFilePath}\n"
  mkdir -p ${lFileFolder}
  cat <<EOM > "${lFilePath}"
  [alias]
    # display status
    mxdst = status --short
    # display stagged file
    mxdsf = diff --name-only --cached
    # display last commit
    mxdlc = log -2  --pretty=format:'%h - %an, %ar : %s'
    # commit with no commit msg
    mxcnm = commit -m 'SC'
    # Open External tool with git
    mxcode =  !code

  [color]
    ui = true
    status = auto
    branch = auto
  [user]
    email = abelgacem
    name = abelgacem
  [commit]
    #template = /Users/Max/.gitmessage
    #template = 'SC'
EOM
}

##########################################
# Action                                ##
##########################################
mxt-git-conf-provision

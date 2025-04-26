#!/bin/bash

# Section.Description > Script.Bash > Configure > Tool : Ssh

# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})

##########################################
# Method                                ##
##########################################
alias mxt-provision-ssh-conf="mxt-ssh-conf-provision"
function mxt-ssh-conf-provision() {
  # Dependency
  # Define > Var
  lFileName="config"
  lFileFolder="${HOME}/.ssh"
  lFilePath="${lFileFolder}/${lFileName}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Configure > Ssh"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action
  mkdir -p ${lFileFolder}
  cat <<EOM > "${lFilePath}"
# ~/.ssh/config

#### Needed for Vscode:Edit.Remote ######
Host o1m
  HostName 51.210.10.195

#### Config For Ovh ######

 Host o1*
  HostName 51.210.10.195

Host o2*
  HostName 51.77.213.243

Host o3*
  HostName 92.222.22.21

Host o4*
  HostName 141.94.26.17

Host o*a
  User almalinux
Host o*c
  User centos
Host o*u
  User ubuntu
Host o*m
  User mxadmin

Host o*
  IdentityFile ~/debug/secret/keyssh/key.ssh.priv.vm.ovh
  Port 22

#################### Github
Host githubpub
  Preferredauthentications publickey
  IdentityFile ~/.ssh/keysshpriv/key.ssh.priv.git.perso
  HostName github.com
  User git

Host *
  StrictHostKeyChecking no
  # To disable Msg >  @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
  UserKnownHostsFile /dev/null
  # To disable Msg > Warning: Permanently added
  LogLevel ERROR
  # Spped > Connection
  ## Share > Connection
	ControlMaster auto
	ControlPath  /tmp/mx-sockets-ssh-%r@%h-%p
	ControlPersist 600  
  ## Test/Understand
  ServerAliveInterval  60
  ServerAliveCountMAx 20
EOM
chmod 600 ${lFilePath}
# Check.Post > File > Exists
lAction="ls ${lFilePath}"
lResult="$(${lAction})"
printf "Mx > Check.Post > File > Exists > ${lResult}\n"

}

##########################################
# Action                                ##
##########################################
mxt-ssh-conf-provision
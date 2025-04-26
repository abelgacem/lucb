#!/bin/bash

# Section.Description > Provision > Conf:Ssh

# Define > Var
sThisFilePath=$0
sUserSsh=$(id -nu)
siUserName=${1:-$sUserSsh}
sFileName="config"
sFolderPath="/home/${siUserName}/.ssh"
sFilePath="${sFolderPath}/${sFileName}"

# Provision > File > ${gK8sRepoYumPathname} (Repo.Yum)
sAction="Mx > Provision > File > ${sFilePath}"; echo "${sAction}"
cat <<EOF  >> ${sFilePath}

#### Config For Ovh ######

 Host o1*
  HostName 51.210.10.195

Host o2*
  HostName 51.77.213.243

Host o3*
  HostName 92.222.22.21

Host o*c
  User centos
Host o*u
  User ubuntu
Host o*m
  User mxadm

Host o*
  IdentityFile ~/.ssh/sshkeypriv/sshkeyovh
  Port 22

#################### Github
Host githubpub
  Preferredauthentications publickey
  IdentityFile ~/.ssh/sshkeypriv/key.ssh.priv.git.perso
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

EOF

sAction="Mx > Chmod > File : ${sFilePath}"; echo -e "${sAction}"
sudo chmod 644 ${sFilePath}

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
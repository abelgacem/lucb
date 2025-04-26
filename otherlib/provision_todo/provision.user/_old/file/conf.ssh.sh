#!/bin/bash

# Section.Description > Provision > File > in > Os:User:Home
## Provision > Alias.Ssh
## Configure > Ssh:Client

# Section.Deppendency > none

# Parse > Arg
while getopts ":m:n:t:w:a:b:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;
    a) siOtpSType=$OPTARG;;       ## checked > by > caller
    b) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
## Map > File.this > To > Otp.File
siFileName="config"
siFileFolder="/home/${siUserOsUsed}/.ssh"
siFilePath="${siFileFolder}/${siFileName}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}:${siUserOsUsed}][${siOtpWord}][${siOtpSType}]"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siUserOsProvided}"
## Display > Info
printf "    - Do    %-48s > From Scratch\n" "${sDebugPath}"
# cat << Content
  
#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content

# Check > User.Remote > Exists
sAction="ssh ${siVmName} id ${siUserOsUsed} 2> /dev/null && echo  exist"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warning %-48s > Not Exists > user : %s\n" "${sDebugPath}" "${siUserOsUsed}" ; exit; }

# Check > Folder.Remote > Exists
sAction="ssh ${siVmName} sudo [ -d ${siFileFolder} ] && echo notexists"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warning %-48s > Not Exists > folder : %s\n" "${sDebugPath}" "${siFileFolder}" ; exit; }

cat <<EOF | ssh ${siVmName} sudo tee ${siFilePath} >/dev/null
# ${siFilePath}

#### Config For Ovh ######

 Host o1*
  HostName 51.210.10.195

Host o2*
  HostName 51.77.213.243

Host o3*
  HostName 92.222.22.21

Host o4*
  HostName 141.94.26.17

Host o*c
  User centos
Host o*u
  User ubuntu
Host o*m
  User mxadmin

Host o*
  IdentityFile ~/.ssh/keysshpriv/key.ssh.priv.vm.ovh
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
EOF

sAction="ssh ${siVmName} sudo chown -R ${siUserOsUsed}:${siUserOsUsed} /home/${siUserOsUsed}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}
# Check > Action > File > exist

sAction="ssh ${siVmName} sudo ls ${siFilePath}"
#echo -e "      - Check ${sDebugPath} > File > Exists > ${sCheck}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}" "${sCheck}"

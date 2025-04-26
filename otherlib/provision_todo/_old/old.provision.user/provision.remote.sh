#!/bin/bash

# Define > Var.Script
sFolderThisFile=$(dirname $BASH_SOURCE)
siVmName=${1}

# Depnedency 01
. $(dirname $BASH_SOURCE)/provision.env.sh

# Depnedency 02
. $(dirname $BASH_SOURCE)/${gLibUserFileName}
. $(dirname $BASH_SOURCE)/${gLibFileFileName}

# Check > Arg
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

# Define > Var
sAction="Mx > Playing > script > ${siVmName} : ${BASH_SOURCE}"

echo "${sAction}"

# Configure > Sshd
sAction="Mx > Configure > Sshd"; echo "${sAction}"
sudo sed -ie 's/#ClientAliveInterval 0/ClientAliveInterval 30/'  /etc/ssh/sshd_config
sudo sed -ie 's/#TCPKeepAlive yes/TCPKeepAlive yes/'             /etc/ssh/sshd_config

# Configure > Sudoers
## Work on Centos v7.9
sAction="Mx > Configure > Sudoers"; echo "${sAction}"
sudo sed -ie 's/# %wheel/%wheel/g' /etc/sudoers

# Provision > User
mx-user-create        ${gOsUser}
mx-user-folder-create ${gOsUser} .ssh
mx-user-keypub-add    ${gOsUser} "/tmp/${gSshKeyPubOvhFileName}"
mx-user-group-add     ${gOsUser} "wheel"

## Clean > Folder:/tmp
mx-file-tmp-delete "${gCodeFileName}"
mx-file-tmp-delete "${gCodeEnvFileName}"
mx-file-tmp-delete "${gLibUserFileName}"
mx-file-tmp-delete "${gLibFileFileName}"
mx-file-tmp-delete "${gSshKeyPubOvhFileName}"




#!/bin/bash

# Define > Var.Script
sFolderThisFile=$(dirname $BASH_SOURCE)
siVmName=${1}

# Depnedency 01
. $(dirname $BASH_SOURCE)/provision.env.sh
. $(dirname $BASH_SOURCE)/${gLibFileFileName}


# Check > Arg
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

# Define > Var.Script
sAction="Mx > Playing > script > ${siVmName} : ${BASH_SOURCE}"; echo "${sAction}"


# Provision > Package
sAction="Mx > Provision > Package.Basic"; echo "${sAction}"
sudo yum install ${gListPakageBasic} -q -y


# Provision > Package
## Mandatory to install Version > 2
sAction="Mx > Provision > Package:Git"; echo "${sAction}"
sudo yum remove git* -q -y
sudo yum install ${gGitRpmUrl} -q -y
sudo yum install git -q -y

# Start > Service
sudo systemctl enable firewalld
sudo systemctl start firewalld


## Clean > /Tmp
mx-file-tmp-delete "${gCodeFileName}"
mx-file-tmp-delete "${gCodeEnvFileName}"

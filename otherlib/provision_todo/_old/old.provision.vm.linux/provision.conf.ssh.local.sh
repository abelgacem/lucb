#!/bin/bash

# Section.Description > Provision > File.Code

# Define > Var.Script
## Input.Mandatory
siVmName=${1}
## Input.Optional
siUserName=${2}
## Other
sFolderThisFile=$(dirname $BASH_SOURCE)
sFileName="provision.conf.ssh.remote.sh"
sFilePath="${sFolderThisFile}/${sFileName}"

# Check > input > is > provided
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

sAction="Mx > Copy : ${sFilePath} > to > Vm : ${siVmName}:/tmp"; echo -e "${sAction}"
rsync ${sFilePath} ${siVmName}:/tmp

sAction="Mx > Play > Script : ${siVmName}:/tmp/${sFileName}"; echo -e "${sAction}"
ssh ${siVmName} "/tmp/${sFileName} ${siUserName}"
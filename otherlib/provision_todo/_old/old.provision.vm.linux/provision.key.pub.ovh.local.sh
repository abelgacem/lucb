#!/bin/bash

# Section.Description > Provision > File.Code

# Define > Var.Script
## Input.Mandatory
siVmName=${1}
## Input.Optional
siUserName=${2}
## Other
sFolderThisFile=$(dirname $BASH_SOURCE)
sFileName="provision.key.git.perso.remote.sh"
sFilePath="${sFolderThisFile}/${sFileName}"

sKeyName="key.ssh.vm.ovh.pub"
sKeyFileName="${sKeyName}"
sKeyFolderPath="/Users/max/Documents/NotInCloud/RepoDevops/sshkey"
sKeyFilePath="${sKeyFolderPath}/${sKeyFileName}"


# Check > input > is > provided
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

sAction="Mx > Copy : ${sKeyFilePath} > to > Vm : ${siVmName}:/tmp"; echo -e "${sAction}"
rsync ${sKeyFilePath} ${siVmName}:/tmp

sAction="Mx > Copy : ${sFilePath} > to > Vm : ${siVmName}:/tmp"; echo -e "${sAction}"
rsync ${sFilePath} ${siVmName}:/tmp

sAction="Mx > Play > Script : ${siVmName}:/tmp/${sFileName}"; echo -e "${sAction}"
ssh ${siVmName} "/tmp/${sFileName} ${siUserName}"
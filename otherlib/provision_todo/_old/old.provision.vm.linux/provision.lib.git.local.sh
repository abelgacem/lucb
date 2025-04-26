#!/bin/bash

# Section.Description > Provision > File.Code

# Define > Var
## Input.Mandatory
siVmName=${1}
## Input.Optional
siUserName=${2}
## Other
sFolderThisFile=$(dirname $BASH_SOURCE)
sFileName="provision.lib.git.remote.sh"
sFilePath="${sFolderThisFile}/${sFileName}"

sLibGitFileName="git.lib.sh"
sLibGitFolderPath="/usr/local/etc/git/code/lib/bash"
sLibGitFilePath="${sLibGitFolderPath}/${sLibGitFileName}"

# Check > input > is > provided
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

sAction="Mx > Copy : ${sLibGitFilePath} > to > Vm : ${siVmName}:/tmp"; echo -e "${sAction}"
rsync ${sLibGitFilePath} ${siVmName}:/tmp

sAction="Mx > Copy : ${sFilePath} > to > Vm : ${siVmName}:/tmp"; echo -e "${sAction}"
rsync ${sFilePath} ${siVmName}:/tmp

sAction="Mx > Play > Script : ${siVmName}:/tmp/${sFileName}"; echo -e "${sAction}"
ssh ${siVmName} "/tmp/${sFileName} ${siUserName}"
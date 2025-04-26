#!/bin/bash

# Section.Description
## Provision > Git > Version.Last > on > Os:Centos:7

# Define > Var.Script
sFilename="provision.git.remote.sh"
sFolderThisFile=$(dirname $BASH_SOURCE)
sFilePathname="${sFolderThisFile}/${sFilename}"
siVmName=${1}

# Check > Arg
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

sAction="Mx > Copy : ${sFilePathname} > to > Vm : ${siVmName}:/tmp"; echo -e "${sAction}"
rsync ${sFilePathname} ${siVmName}:/tmp

sAction="Mx > Play > Script : ${siVmName}:/tmp/${sFilename}"; echo -e "${sAction}"
ssh ${siVmName} "/tmp/${sFilename}"
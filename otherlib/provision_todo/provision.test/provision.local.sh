#!/bin/bash

# Define > Var.Script
sFolderThisFile=$(dirname $BASH_SOURCE)
siVmName=${1}

# Dependency 01
. $(dirname $BASH_SOURCE)/provision.env.sh
# Dependency 02
sFile="${gLibFileFileName}"; mx-git-file-get code main lib/bash/${sFile} /tmp ; . /tmp/${sFile}

# Check > Arg
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

## Proviion > File > Code
sgFile="${sFolderThisFile}/${gCodeFileName}"    && mx-file-copy-remote ${sgFile} ${siVmName}
sgFile="${sFolderThisFile}/${gCodeEnvFileName}" && mx-file-copy-remote ${sgFile} ${siVmName}

## Clean > /Tmp
mx-file-tmp-delete "${gCodeFileName}"
mx-file-tmp-delete "${gCodeEnvFileName}"
mx-file-tmp-delete "${gLibFileFileName}"

# Play > script > on > Vm.remote
# ssh ${siVmName} "/tmp/${gCodeFileName} ${siVmName}"


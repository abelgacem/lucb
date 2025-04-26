#!/bin/bash

# Define > Var
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

## Copy.Git  > File > Lib.bash > to > vm:/tmp > via > /tmp
sgFileName="${gLibFileFileName}"
mx-git-file-get code main lib/bash/${sgFileName} /tmp
mx-file-copy-remote /tmp/${sgFileName} ${siVmName}

## Copy.Git  > File > Lib.bash > to > vm:/tmp > via > /tmp
sgFileName="${gLibUserFileName}"
mx-git-file-get code main lib/bash/${sgFileName} /tmp
mx-file-copy-remote /tmp/${sgFileName} ${siVmName}

## Copy.Git  > File > Ssh:Config:Ovh > to > vm:/tmp > via > /tmp
sgFileName="${gSshConfigOvhFileName}"
mx-git-file-get conf main ssh/${sgFileName} /tmp
mx-file-copy-remote /tmp/${sgFileName} ${siVmName}

## Copy.Rsync > File > User:Key(Priv, Ssh):Ovh > to > vm:/tmp > via > /tmp
sgFile="${gSshKeyPrivFolderName}/${gSshKeyPrivOvhFileName}"             && mx-file-copy-remote ${sgFile} ${siVmName}
sgFile="${gSshKeyPrivFolderName}/${gSshKeyPrivGithubPersonalFileName}" && mx-file-copy-remote ${sgFile} ${siVmName}

## Clean > /Tmp
mx-file-tmp-delete "${gCodeFileName}"
mx-file-tmp-delete "${gCodeEnvFileName}"
mx-file-tmp-delete "${gLibFileFileName}"
mx-file-tmp-delete "${gLibUserFileName}"
mx-file-tmp-delete "${gSshConfigOvhFileName}"
mx-file-tmp-delete "${gSshKeyPrivOvhFileName}"
mx-file-tmp-delete "${gSshKeyPrivGithubPersonalFileName}"

# Play > script > on > Vm.remote
ssh ${siVmName} "/tmp/${gCodeFileName} ${siVmName}"

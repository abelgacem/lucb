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

## Copy.Git  > File > Lib.bash > to > vm:/tmp > via > /tmp
lFileName=${gLibFileFileName}
mx-git-file-get code main lib/bash/${lFileName} /tmp
mx-file-copy-remote /tmp/${lFileName} ${siVmName}

## Copy.Git  > File > Lib.bash > to > vm:/tmp > via > /tmp
lFileName=${gLibUserFileName}
mx-git-file-get code main lib/bash/${lFileName} /tmp
mx-file-copy-remote /tmp/${lFileName} ${siVmName}

## Copy.Git  > File > Lib.bash > to > vm:/tmp > via > /tmp
lFileName=${gLibAliasFileName}
mx-git-file-get code main lib/bash/${lFileName} /tmp
mx-file-copy-remote /tmp/${lFileName} ${siVmName}

## Copy.Git  > File > Lib.bash > to > vm:/tmp > via > /tmp
lFileName=${gLibGitFileName}
mx-git-file-get code main lib/bash/${lFileName} /tmp
mx-file-copy-remote /tmp/${lFileName} ${siVmName}


## Clean > /Tmp
mx-file-tmp-delete "${gCodeFileName}"
mx-file-tmp-delete "${gCodeEnvFileName}"
mx-file-tmp-delete "${gLibFileFileName}"
mx-file-tmp-delete "${gLibUserFileName}"
mx-file-tmp-delete "${gLibAliasFileName}"
mx-file-tmp-delete "${gLibGitFileName}"

# Play > script > on > Vm.remote
ssh ${siVmName} "/tmp/${gCodeFileName} ${siVmName}"



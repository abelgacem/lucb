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

# Define > Var
sAction="Mx > Playing > script > ${siVmName} : ${BASH_SOURCE}"; echo "${sAction}"

# Provision > File.Conf
sAction="Mx > Provision > File:${gGitConfigFilePath}"; echo "${sAction}"
[ ! -f "${gGitConfigFilePath}" ] && {
  sudo touch "${gGitConfigFilePath}"
  sudo chown ${gOsUser}:${gOsUser} ${gGitConfigFilePath}
  echo -e "[user]"               > ${gGitConfigFilePath}
  echo -e "  email = abelgacem" >> ${gGitConfigFilePath}
  echo -e "  name  = abelgacem" >> ${gGitConfigFilePath}
}


## Clean > /Tmp
mx-file-tmp-delete "${gCodeFileName}"
mx-file-tmp-delete "${gCodeEnvFileName}"

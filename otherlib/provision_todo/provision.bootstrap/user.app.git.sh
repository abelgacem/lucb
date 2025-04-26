#!/bin/bash

# Section.Description > Bootstrap > 1 VM:User > to
## Git.Clone > Repo.(Git, Personal) [Easily]

# Dependency
. $(dirname $BASH_SOURCE)/../_provision/provision.sh

# Parse > Arg
while getopts ":m:n:t:w:a:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;
    a) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
# This
sThisFilePath=$0
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
## Section.Debug
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord}"
[ -z "${siUserOsProvided}" ] || siListArg="${siListArg} -a ${siUserOsProvided}"
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}]"
# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${siListArg}       = ${siListArg}
# Content

# Display > Info
# printf "  - Action > Provision > Vm : %s > User : %s > Git : Conf,Lib [Y/N] \n" "${siVmName}" "${siUserOsUsed}" 
# { read -n1 response && [ "$response" != "${response#[YyoO]}" ] || exit; }

# # Pause > if > siNoPause=xxx
# [ -z ${siNoPause} ] || { read -n1 response && [ "$response" != "${response#[YyoO]}" ] || exit; }


# Prerequisite
# printf "  - Prereq    > Begin \n"
# mx-provision vm.linux ${siVmName} bootstrap    vm                              ${siUserOsUsed}
# mx-provision vm.linux ${siVmName} bootstrap    user                              ${siUserOsUsed}
# printf "  - Prereq    > End\n"
mx-provision vm.linux ${siVmName} package      centos.1    git
mx-provision vm.linux ${siVmName} user         folder      mx/git                ${siUserOsUsed}
mx-provision vm.linux ${siVmName} user         file        conf.git              ${siUserOsUsed} # Configure App:Git:Login,Alias
mx-provision vm.linux ${siVmName} user         file        key.priv   git.perso  ${siUserOsUsed} # Allow > to > Ssh > to > Github
mx-provision vm.linux ${siVmName} user         file        lib        git        ${siUserOsUsed} # Allow > to > get > Repo.Git


# Usage
## mxp vm.linuc o1c bootstrap user.git mxadmin
## mxp vm.linuc o1m bootstrap user.git
#!/bin/bash

# Section.Description > Bootstrap > 1 VM > with > App:Provision

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
## 
sHostname="ovh0${siVmName:1:1}"
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
#   \${siUserOsUsed}    = ${siUserOsUsed}
# Content

#mx-provision vm.linux ${siVmName} bootstrap    vm
#mx-provision vm.linux ${siVmName} bootstrap    vm.user                           ${siUserOsUsed}
#mx-provision vm.linux ${siVmName} bootstrap    user.app.git                      ${siUserOsUsed}
mx-provision vm.linux ${siVmName} bootstrap    user.app.container                ${siUserOsUsed}

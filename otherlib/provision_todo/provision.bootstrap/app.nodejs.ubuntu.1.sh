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
##
sHostname="ovh0${siVmName:1:1}"
## Section.Debug
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord}"
[ -z "${siUserOsProvided}" ] || siListArg="${siListArg} -a ${siUserOsProvided}"
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}]"
# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${siListArg}       = ${siListArg}
#   \${siUserOsUsed}    = ${siUserOsUsed}
# Content

# # Display > Info
# printf "  - Action > Provision > Vm : %s > App : Provision  > for >  User : %s [Y/N]\n" "${siVmName}" "${siUserOsUsed}" 
# { read -n1 response && [ "$response" != "${response#[YyoO]}" ] || exit; }

mx-provision vm.linux ${siVmName} bootstrap    vm.ubuntu.1
mx-provision vm.linux ${siVmName} etc          repo.apt   nodejs
mx-provision vm.linux ${siVmName} package      ubuntu.1   nodejs



## mx-provision vm.linux ${siVmName} etc          set         hostname              ${sHostname}
## mx-provision vm.linux ${siVmName} etc          set         etchost.add           ${sHostname}
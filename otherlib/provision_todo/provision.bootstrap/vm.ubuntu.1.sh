#!/bin/bash

# Section.Description > Bootstrap > 1 VM > with > 1 > User.(Sudo,Ssh) that
## have Alias.Global
## Can ssh > Vm.Ovh:All

# Dependency
. $(dirname $BASH_SOURCE)/../_provision/provision.sh

# Parse > Arg
while getopts ":m:n:t:w:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;
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
##
sHostname="ovh0${siVmName:1:1}"
## Section.Debug
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord}"
[ -z "${siUserOsProvided}" ] || siListArg="${siListArg} -a ${siUserOsProvided}"
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}]"
# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${siListArg}       = ${siListArg}
# Content

# Display > Info
# printf "  - Action > Upgarde   > Vm : %s : Yum : Repo \n" "${siVmName}"
# printf "  - Action > Provision > Vm : %s > with > Package : Basic \n" "${siVmName}"
# printf "  - Action > Provision > Vm : %s > with > file in /etc/profile.d %s\n" "${siVmName}"

mx-provision vm.linux ${siVmName} package      ubuntu.1   update
mx-provision vm.linux ${siVmName} package      ubuntu.1   basic
mx-provision vm.linux ${siVmName} etc          file       alias
#mx-provision vm.linux ${siVmName} etc          file       var.postgres.ubuntu.1
#mx-provision vm.linux ${siVmName} etc          file         var
#mx-provision vm.linux ${siVmName} bootstrap    etchost.ovh
#mx-provision vm.linux ${siVmName} etc          set         hostname       ${sHostname}
#mx-provision vm.linux ${siVmName} etc          set         etchost.add   "51.210.10.195:o1"

#!/bin/bash

# Section.Description > Bootstrap > 1 VM > with > /etc/hosts:OVH 

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
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord} -a ${siUserOsProvided}"
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}]"
# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${siListArg}       = ${siListArg}
# Content

# Display > Info
# printf "  - Action > Provision > Vm : %s > /etc/hosts : OVH \n" "${siVmName}"

# Action
mx-provision vm.linux ${siVmName} etc     set              etchost.add   "51.210.10.195:o1"
mx-provision vm.linux ${siVmName} etc     set              etchost.add   "51.77.213.243:o2"
mx-provision vm.linux ${siVmName} etc     set              etchost.add   "92.222.22.21:o3"
mx-provision vm.linux ${siVmName} etc     set              etchost.add   "141.94.26.17:o4"

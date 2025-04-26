#!/bin/bash

# Section.Description > Bootstrap > 1 VM > with > 1 > User.(Sudo,Ssh) that
## have Alias.Global
## Can ssh > Vm.Ovh:All

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
# printf "  - Action > Provision > Vm : %s > User.(Sudo, Ssh) : %s [Y/N] \n" "${siVmName}" "${siUserOsUsed}" 

# # Pause > if > siNoPause=xxx
# [ -z ${siNoPause} ] || { read -n1 response && [ "$response" != "${response#[YyoO]}" ] || exit; }

# User
mx-provision vm.linux ${siVmName} user      create                           ${siUserOsUsed}
mx-provision vm.linux ${siVmName} etc       file       sudo                  ${siUserOsUsed}
# Folder
mx-provision vm.linux ${siVmName} user      folder     mx/lib                ${siUserOsUsed}
mx-provision vm.linux ${siVmName} user      folder     mx/var                ${siUserOsUsed}
mx-provision vm.linux ${siVmName} user      folder     .ssh                  ${siUserOsUsed}
mx-provision vm.linux ${siVmName} user      folder     .ssh/keysshpriv       ${siUserOsUsed}
# Key
mx-provision vm.linux ${siVmName} user      file       key.pub    vm.ovh     ${siUserOsUsed} # Can > be > Sshed [If > User > Have > Key.Priv]
mx-provision vm.linux ${siVmName} user      file       key.priv   vm.ovh     ${siUserOsUsed} # Can > Ssh > Vm.Ovh:All
mx-provision vm.linux ${siVmName} user      file       conf.ssh              ${siUserOsUsed} # Configure Ssh:Alias
# Bashrc
mx-provision vm.linux ${siVmName} user      file       bashrc                ${siUserOsUsed} # Automate


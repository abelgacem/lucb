#!/bin/bash

# Section.Description > Provision > Kuberntes: Master

# Section.Deppendency
. $(dirname $BASH_SOURCE)/../../_provision/provision.sh

# Parse > Arg
while getopts ":m:n:t:w:a:b:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;
    a) siOtpSType=$OPTARG;;
    b) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
# 
## Map > id > To > Otp
# ## User
sUserOsSsh="$(ssh ${siVmName} id -nu)"
siUserOsUsed="${siUserOsProvided:-${sUserOsSsh}}"
##
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siUserOsProvided}"
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}]"
# Section.Debug
# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${siListArg}        = ${siListArg}
# Content


# Display > Info
printf "  - Action > Provision > %s : %s > Vm : %s > User : %s [Y/N]\n" "${siOtpWord}" "${siOtpSType}" "${siVmName}" "${siUserOsUsed}" 
{ read -n1 response && [ "$response" != "${response#[YyoO]}" ] || exit; }

# Step > Provision > Master
mx-provision vm.linux ${siVmName} bootstrap kubernetes    master             ${siUserOsUsed}
mx-provision vm.linux ${siVmName} user     file           alias.k8s.env      ${siUserOsUsed}

# Step > Create > Cluster > from > Master
sAction="ssh ${siVmName} sudo kubeadm init --ignore-preflight-errors=NumCPU --cri-socket=/var/run/containerd/containerd.sock"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

mx-provision vm.linux ${siVmName} etc      get           k8s.kctl.conf
mx-provision vm.linux ${siVmName} user     folder        .kube              ${siUserOsUsed}
mx-provision vm.linux ${siVmName} user     file          k8s.conf.kctl      ${siUserOsUsed}
mx-provision vm.linux ${siVmName} user     file          alias.k8s.kctl     ${siUserOsUsed}
 
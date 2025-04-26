#!/bin/bash

# Section.Description > Provision > File > in > /etc
# Section.Description > Provision > Session.Conf

# Section.Deppendency > none

# Parse > Arg
while getopts ":m:n:t:w:a:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    a) siOtpId=$OPTARG;;          ## Mandatory > checked > by > caller
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
# Module
sKernelModule="br_netfilter"
## File > to > Provision
siFileName="k8s.conf"
siFileFolder="/etc/modules-load.d"
siFilePath="${siFileFolder}/${siFileName}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpId}]"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpId}"
## Display > Info
printf "    - Do    %-48s > From Scratch\n" "${sDebugPath}"
# cat << Content
  
#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content

# Action
cat <<EOF | ssh ${siVmName} sudo tee ${siFilePath} >/dev/null
# ${siFilePath}
${sKernelModule}
EOF

# Step
sAction="ssh ${siVmName} sudo chmod 440 ${siFilePath}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Step > Load > Module.Kernel > from > File.conf
sAction="ssh ${siVmName} sudo systemctl restart systemd-modules-load"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action > File > exist
sAction="ssh ${siVmName} sudo ls ${siFilePath}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"

# Check > Action > Module.Kernel > Exists
sAction="ssh ${siVmName} \"sudo lsmod | grep ${sKernelModule} | head -1\""
sCheck="$(eval ${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"
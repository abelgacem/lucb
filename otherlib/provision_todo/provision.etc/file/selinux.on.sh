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
## File > to > Provision
siFileName="config"
siFileFolder="/etc/selinux"
siFilePath="${siFileFolder}/${siFileName}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpId}]"
## Display > Info
printf "    - Do    %-48s > Sed\n" "${sDebugPath}"

# Step > Provision.AfterBoot
sAction="ssh ${siVmName} sudo sed -i 's/^SELINUX=.*$/SELINUX=enforcing/' /etc/selinux/config"
#echo -e "      - Check ${sDebugPath} > File Exists > ${sCheck}"
${sAction}

# Step > Provision.Session
sAction="ssh ${siVmName}  sudo setenforce 1"
#echo -e ${sAction}
${sAction}

# Check > Action
sAction="ssh ${siVmName} sudo getenforce"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > File Exists > ${sCheck}"
printf "    - Check %-48s > Status.Session > %s\n" "${sDebugPath}" "${sCheck}"

# Check > Action
sAction="ssh ${siVmName} sudo grep -i SELINUX=enf ${siFilePath}"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > File Exists > ${sCheck}"
printf "    - Check %-48s > Status.Boot > %s\n" "${sDebugPath}" "${sCheck}"
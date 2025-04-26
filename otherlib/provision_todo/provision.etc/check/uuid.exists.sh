#!/bin/bash

# Section.Description > Provision > File > in > Os:User:Home

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
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}]"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpId}"
cat << Content
  
  ## Section.Debug > [${sThisFileName}] ##
  \${sListArg}       = ${sListArg}
Content

# Check > Action > File > exist
sActionMac="ssh ${siVmName} \"sudo ip link | grep ether  | tr -s ' ' | tr ' ' '$'  | cut -d'$' -f3\""
sCheck01="$(eval ${sActionMac})"
sActionProductId="ssh ${siVmName} \"sudo cat /sys/class/dmi/id/product_uuid\""
sCheck02="$(eval ${sActionProductId})"
printf "    - Check %-48s > Exists > %s - %s\n" "${sDebugPath}" "${sCheck01}" "${sCheck02}"

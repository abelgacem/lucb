#!/bin/bash

# Section.Description > Provision > File > in > Os:User:Home

# Section.Deppendency > none

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
    b) siOtpId=$OPTARG;;    ## Mandatory
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Map > id > To > Otp
siHostName="${siOtpId}"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siOtpId}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpSType}]"
# Display > Info
printf "    - Do    %-48s \n" "${sDebugPath}" 
# cat << Content
  
#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content
  
# Check > Arg > Is > Provided
[ -z ${siOtpId} ] && { printf "    - Error %-48s > Missing > %s \n" "${sDebugPath}" "${siOtpSType}" ; exit; }

# Step
sAction="ssh ${siVmName} sudo hostnamectl set-hostname ${siHostName}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action > Hostname
sAction="ssh ${siVmName} sudo hostname"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"


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
    b) siUserOsProvided=$OPTARG;;
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Map > id > To > Otp
siHostName="${siOtpId}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpSType}]"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siUserOsProvided}"
# cat << Content
  
#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content

# Check > Arg > Is > Provided
[ -z ${siUserOsProvided} ] && { printf "    - Error %-48s > Missing > Kubectl:User\n" "${sDebugPath}" ; exit; }

# Check > User.Remote > Exists
sAction="ssh ${siVmName} id ${siUserOsProvided} 2> /dev/null && echo  exist"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warning %-48s > Not Exists > user : %s\n" "${sDebugPath}" "${siUserOsProvided}" ; exit; }

# Step > get > Version.crypted
sAction="ssh ${siVmName} sudo -Eu ${siUserOsProvided} bash -c 'kubectl version | base64 | tr -d \"\n\"'"
sResult="$(${sAction})"  # Empty > if > Notexists

# Step > Install > Cni
sAction="ssh ${siVmName} sudo -Eu ${siUserOsProvided} bash -c 'kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=${sResult}\"' > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Cni > exist
sCheck="TODO"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"

#sAction="ssh ${siVmName} kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=${sResult}\" > /dev/null"

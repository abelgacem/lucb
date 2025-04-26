#!/bin/bash

# Section.Description > Provision > File > in > /etc

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
    a) siOtpSType=$OPTARG;;       ## checked > by > caller
    b) siHostToAdd=$OPTARG;; ## Optional
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Hosts
siHostIp="$(cut -d ":" -f1 <<< ${siHostToAdd})"
## File > to > Provision
siFileName="hosts"
siFileFolder="/etc"
siFilePath="${siFileFolder}/${siFileName}"
##
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpId} -b ${siHostToAdd}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpId}]"
# cat << Content
  
#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content

# Check > Arg > Is > Provided
[ -z ${siHostToAdd} ] && { printf "    - Error %-48s > Missing > %s : Config\n": "${sDebugPath}" "${siOtpSType}" ; exit; }

# Step
sAction="echo ${siHostToAdd/:/ } | ssh ${siVmName} \"sudo tee -a ${siFilePath}\" > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}



# Step
sAction="ssh ${siVmName} \"sort ${siFilePath} | uniq | sudo tee ${siFilePath}\" > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}


# Check > Action > Host:Exist
sAction="ssh ${siVmName} \"grep -h ${siHostIp} ${siFilePath} | tr '\r\n' ' ' \""
sCheck="$(eval ${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"
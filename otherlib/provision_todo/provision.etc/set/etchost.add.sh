#!/bin/bash

# Section.Description > Provision > Host > in > /etc/hosts

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
    b) siHostToAdd=$OPTARG;; ## Mandatory
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Map > id > To > Otp
siIp="$(cut -d ":" -f1 <<< ${siHostToAdd})"
siDataToInsert="${siHostToAdd/:/ }"
siFileName="hosts"
siFileFolderDst="/etc"
siFilePathDst="${siFileFolderDst}/${siFileName}"
##
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siHostToAdd}"
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpSType}]"
# Display > Info
printf "    - Do    %-48s \n" "${sDebugPath}" 
## Section.Debug

# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${siListArg}        = ${siListArg}
# Content


# Check > Arg > Is > Provided
[ -z ${siHostToAdd} ] && { printf "    - Error %-48s > Missing > Host : Info\n": "${sDebugPath}" ; exit; }

# Step
sAction="echo ${siDataToInsert} | ssh ${siVmName} \"sudo tee -a ${siFilePathDst}\" > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}

# Step
sAction="ssh ${siVmName} \"sort ${siFilePathDst} | uniq | sudo tee ${siFilePathDst}\" > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}

# Check > Host:Exist
sAction="ssh ${siVmName} \"grep -h ${siIp} ${siFilePathDst} | tr '\r\n' ' ' \""
sCheck="$(eval ${sAction})"
printf "    - Check %-48s > Exists > [Todo > Check > Syntax > Is > OK] %s\n" "${sDebugPatho}" "${sCheck}"
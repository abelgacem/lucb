#!/bin/bash

# Section.Description > Provision > Host > in > /etc/hosts
## Add > 1 > Hostanem > to > Current > Host:IP

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
siHost01="$(cut -d ":" -f1 <<< ${siHostToAdd})"
siHost02="$(cut -d ":" -f2 <<< ${siHostToAdd})"
siHostAll="${siHostToAdd/:/ }"
siFileName="hosts"
siFileFolderDst="/etc"
siFilePathDst="${siFileFolderDst}/${siFileName}"
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siHostToAdd}"
##
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpSType}]"
## Section.Debug
# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${siListArg}       = ${siListArg}
#   \${siHost01}      = ${siHost01}
#   \${siHost02}      = ${siHost02}
# Content

# Check > Arg > Is > Provided
[ -z ${siHostToAdd} ] && { printf "    - Error %-48s > Missing > Host : Info\n": "${sDebugPath}" ; exit; }

# Step
#sAction="echo ${siDataToInsert} | ssh ${siVmName} \"sudo tee -a ${siFilePathDst}\" > /dev/null"
sAction="echo ${siDataToInsert} | ssh ${siVmName} \"sudo sed -ie 's/${siHost01}/${siHostAll}/' ${siFilePathDst}\"> /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}

# Step
sAction="ssh ${siVmName} \"sort ${siFilePathDst} | uniq | sudo tee ${siFilePathDst}\" > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}

# Check > Host:Exist
sAction="ssh ${siVmName} \"grep -h ${siHost01} ${siFilePathDst} | tr '\r\n' ' ' \""
sCheck="$(eval ${sAction})"
printf "    - Check %-48s > Exists > [Todo [Not Idempotent]> Check > Syntax > Is > OK] %s\n" "${sDebugPath}" "${sCheck}"
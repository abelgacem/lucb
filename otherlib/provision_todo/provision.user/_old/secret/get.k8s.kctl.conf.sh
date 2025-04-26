#!/bin/bash

# Section.Description > Provision > File > from > Remote > in > Local:Os:User:Home

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
## User
siUserOsUsed=$(id -nu)
## Map > id > To > Otp
siFileName="admin.conf"
siFileFolderSrc="/etc/kubernetes"
siFilePathSrc="${siFileFolderSrc}/${siFileName}"
siFileFolderDst="${gUserSecretFolder}/k8s/kubectl"
siFilePathDst="${siFileFolderDst}/config"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpWord}][${siOtpId}]"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpId}"
# cat << Content
  
#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content

# Check > Arg > Is > Provided
[ -z ${siOtpId} ] && { printf "    - Error %-48s > Missing > %s : Id\n": "${sDebugPath}" "${siOtpSType}" ; exit; }

# Check > Folder.Remote > Exists
sAction="ssh ${siVmName} sudo [ -d ${siFileFolderSrc} ] && echo notexists"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warning %-48s > Not Exists > Folder.Remote : %s\n" "${sDebugPath}" "${siFileFolderSrc}" ; exit; }

# Check > File.Remote > exists
sAction="ssh ${siVmName} sudo ls ${siFilePathSrc}"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > File > Exists > ${sResult}"
[ -z ${sCheck} ] && { printf "    - Error  %-48s > Not Exists > File.Remote : %s\n" "${sDebugPath}" "${siFilePathSrc}" ; exit; }

# Check > Folder.Local > Exists
sAction="[ -d ${siFileFolderDst} ] && echo notexists"
sCheck="$(eval ${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warning %-48s > Not Exists > Folder.Local : %s\n" "${sDebugPath}" "${siFileFolderDst}" ; exit; }

sAction="ssh ${siVmName} \"sudo cat ${siFilePathSrc}\" > ${siFilePathDst}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}

# Check > Action > File > exist
sAction="ls ${siFilePathDst}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"
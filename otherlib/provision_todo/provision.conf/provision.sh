#!/bin/bash

# Section.Description > Provision > Os:User:Home:File.Conf

# Parse > Arg
while getopts ":v:o:t:" Opt
do
  case $Opt in
    v) siVmName=$OPTARG;;   # Mandatory. Checked by Caller
    t) siOtpType=$OPTARG;;  # Mandatory. Checked by Caller
  esac
done
# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
# Other
## Map > OtpId, OtpType > To > Cli
lProvisionPrefix="pc"
siFileName="${lProvisionPrefix}.${siOtpType}.sh"
siFileFolder="${sThisFileFolder}"
siFilePath="${siFileFolder}/${siFileName}"

## Section.Debug
#sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}:${siFileType}][${siOtpWord}]"
# sListArg="-v ${siVmName} -t ${siOtpType}"
# [ -z "${siParam01}" ] || siListArg="${siListArg} -b ${siParam01}"
# [ -z "${siParam02}" ] || siListArg="${siListArg} -c ${siParam02}"

# cat << Content
#   ## Section.Debug > [${sThisFileName}] ##
#    \${sListArg}       = ${sListArg}
# Content

# Check > Arg > Is > Provided
#[ -z ${siFileType} ] && { printf "    - Error %-48s > Missing > %s : type\n": "${sDebugPath}" "${siOtpType}" ; exit; }

# Check > File.Local.Code > Exists
[ -f "${siFilePath}" ] || { printf "    - Error %-48s > Not Exists > File : %s\n" "${sDebugPath}"  "${siFilePath}" ; exit; }

# Check > Action > is > Local or Not
[ "local" = ${siVmName} ] && { 
  sAction="${siFilePath}"
  echo -e "Mx > Play > Cli.Local > ${sAction}" 
  ${sAction}
  exit; 
}
# Action
sAction="scp ${siFilePath} ${siVmName}:/tmp"
echo -e "Mx > Play > Cli > ${sAction}" 
#eval ${sAction}
sAction="play.Ssh > File > ${siFilePath}"
echo -e "Mx > Play > Cli > ${sAction}" 



# Step
# - Scp        > file to /tmp
# - Play.SSh   > file via ssh
# - Check      > Action
# - Remove     > File




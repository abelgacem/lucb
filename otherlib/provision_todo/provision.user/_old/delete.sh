#!/bin/bash

# Section.Description > DeProvision > Os:User

# Section.Deppendency > None

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
## Map > id > To > Otp:Name
siOtpName=${siOtpId}
## Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}:${siOtpId}][${siOtpWord}]"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siOtpName}     = ${siOtpName}
# ## Section.Debug ##
# Content

# Check > Arg > Is > Provided
[ -z ${siOtpId} ] && { printf "    - Error %-48s > Missing > %s : Name\n": "${sDebugPath}" "${siOtpType}" ; exit; }

# Check > User.Remote > Exists 
sAction="ssh ${siVmName} id ${siOtpName} 2> /dev/null && echo  exist"
sCheck="$(${sAction})"
[ -z "${sCheck}" ] && { printf "    - Warning %-48s > Not Exists > ${siOtpType} : %s\n" "${sDebugPath}" "${siOtpName}" ; exit; }

# Action
sAction="ssh ${siVmName} sudo userdel -r ${siOtpName}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action
sAction="ssh ${siVmName} id ${siOtpName} &> /dev/null  && echo  ${siOtpName}"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > User > Exists > ${sResult}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"


# # File.This
# sThisFilePath=${BASH_SOURCE}
# sThisFileName=$(basename ${sThisFilePath})
# sThisFileId=${sThisFileName//.sh}
# sThisFileFolder=$(dirname ${sThisFilePath})

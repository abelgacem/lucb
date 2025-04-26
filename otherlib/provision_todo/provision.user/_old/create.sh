#!/bin/bash

# Section.Description > Provision > Os:User

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
## Display > Info
printf "    - Do    %-48s  \n" "${sDebugPath}"
# Content

# Check > Arg > Is > Provided
[ -z ${siOtpId} ] && { printf "    - Error %-48s > Missing > %s : Name\n": "${sDebugPath}" "${siOtpType}" ; exit; }

# Check > User.Remote > Not > Exists 
sAction="ssh ${siVmName} id ${siOtpName} 2> /dev/null && echo  exist"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] || { printf "    - Warn  %-48s > Exists [Already] > ${siOtpType} : %s\n" "${sDebugPatho}" "${siOtpName}" ; exit; }

# Action
sAction="ssh ${siVmName} sudo adduser ${siOtpName}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action
sAction="ssh ${siVmName} id ${siOtpName} &> /dev/null  && echo  ${siOtpName}"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > User > Exists > ${sResult}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}" "${sCheck}"

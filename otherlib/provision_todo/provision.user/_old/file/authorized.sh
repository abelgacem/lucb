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
    a) siOtpSType=$OPTARG;;       ## checked > by > caller
    b) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
## Map > File.this > To > Otp.File
siFileFolder="/home/${siUserOsUsed}/.ssh"
siFilePath="${siFileFolder}/${sThisFileName}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}:${siUserOsUsed}][${siOtpWord}][${siOtpSType}]"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siUserOsProvided}"
cat << Content
  
  ## Section.Debug > [${sThisFileName}] ##
  \${sListArg}       = ${sListArg}
Content

# Check > User.Remote > Exists
sAction="ssh ${siVmName} id ${siUserOsUsed} 2> /dev/null && echo  exist"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warning %-48s > Not Exists > user : %s\n" "${sDebugPath}" "${siUserOsUsed}" ; exit; }

# Check > Folder.Remote > Exists
sAction="ssh ${siVmName} sudo [ -d ${siFileFolder} ] && echo notexists"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warning %-48s > Not Exists > folder : %s\n" "${sDebugPath}" "${siFileFolder}" ; exit; }

sAction="ssh ${siVmName} sudo touch ${siFilePath}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

sAction="ssh ${siVmName} sudo chmod 600 ${siFilePath}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

sAction="ssh ${siVmName} sudo chown -R ${siUserOsUsed}:${siUserOsUsed} /home/${siUserOsUsed}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action > File > exist
sAction="ssh ${siVmName} sudo ls ${siFilePath}"
#echo -e "      - Check ${sDebugPath} > File > Exists > ${sCheck}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"

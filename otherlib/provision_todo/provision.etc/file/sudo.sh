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
    b) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})

## File > to > Provision
siFileName="91-mx-init-users"
siFileFolder="/etc/sudoers.d"
siFilePath="${siFileFolder}/${siFileName}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpSType}]"
## Display > Info
printf "    - Do    %-48s > From Scratch\n" "${sDebugPath}"

# Check > Arg > Is > Provided
[ -z "${siUserOsProvided}" ] && { printf "    - Error %-48s > Missing > User.Sudo\n" "${sDebugPath}" ; exit; }

# Action
cat <<EOF | ssh ${siVmName} sudo tee ${siFilePath} >/dev/null
# ${siFilePath}

# User rules
${siUserOsProvided} ALL=(ALL) NOPASSWD:ALL
EOF

sAction="ssh ${siVmName} sudo chmod 440 ${siFilePath}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action > File > exist
sAction="ssh ${siVmName} sudo ls ${siFilePath}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}" "${sCheck}"

# Check > Todo > 
sAction="ssh ${siVmName} sudo ls ${siFilePath}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Todo > Exist > User.Sudo : %s > in > file??\n" "${sDebugPatho}" "${siUserOsProvided}"

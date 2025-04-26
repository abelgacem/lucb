#!/bin/bash

# Section.Description > Provision > File > in > /etc
# Section.Description > Provision > Session.Conf

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

## File > to > Provision
siFileName="nodejs.list"
siFileFolder="/etc/apt/sources.list.d"
siFilePath="${siFileFolder}/${siFileName}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpId}]"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpId}"
## Display > Info
printf "    - Do    %-48s > From Scratch\n" "${sDebugPath}"
# cat << Content
  
#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content

# Action
# Step > Get > Ubuntu:Version
sAction="ssh ${siVmName} lsb_release -cs"
sUbuntuName="$(${sAction})"
sNodejsVersion="node_12.x"
sKeyFilePath="/usr/share/keyrings/nodesource.gpg"

# Step
cat <<EOF | ssh ${siVmName} sudo tee ${siFilePath} >/dev/null
# ${siFilePath}
deb [signed-by=${sKeyFilePath}] https://deb.nodesource.com/${sNodejsVersion} ${sUbuntuName} main
EOF


# Step > Add > Key.apt
sAction="ssh ${siVmName}  sudo wget -q -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | sudo tee ${sKeyFilePath} >/dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Step > Update > List:Package
sAction="ssh ${siVmName} sudo apt-get update -qq -y > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action > File > exist
sAction="ssh ${siVmName} sudo ls ${siFilePath}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"

#wget -nv
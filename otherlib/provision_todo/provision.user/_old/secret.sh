#!/bin/bash

# Section.Description > Provision > Os:User:Home:File
# Section.Description > Provision > Os:User:Home:File.Key.Priv > in > User:Home

# Section.Deppendency

# Parse > Arg
while getopts ":m:n:t:w:a:b:c:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;
    a) siSecretType=$OPTARG;;          ## Mandatory > checked > by > caller
    b) siParam01=$OPTARG;; ## Optional
    c) siParam02=$OPTARG;; ## Optional
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Map > id > To > Cli
siFileName="${siSecretType}.sh"
siFileFolder="${sThisFileFolder}/secret"
siFilePath="${siFileFolder}/${siFileName}"
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord} -a ${siSecretType}"
[ -z "${siParam01}" ] || siListArg="${siListArg} -b ${siParam01}"
[ -z "${siParam02}" ] || siListArg="${siListArg} -c ${siParam02}"

## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}:${siFileType}][${siOtpWord}]"
# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${siListArg}       = ${siListArg}
# Content

# Check > Arg > Is > Provided
[ -z ${siSecretType} ] && { printf "    - Error %-48s > Missing > %s : type\n": "${sDebugPath}" "${siOtpWord}" ; exit; }

# Check > File.Local.Code > Exists
[ -f "${siFilePath}" ] || { printf "    - Error %-48s > Not Exists > File : %s\n" "${sDebugPath}" "${siFileName}" ; exit; }

# Action
sAction="${siFilePath} ${siListArg}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

#sThisFileName=$(basename ${sThisFilePath})

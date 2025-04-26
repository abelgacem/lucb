#!/bin/bash

# Section.Description > Provision > Os:User:Home:File
# Section.Description > Provision > Os:User:Home:File.Key.Priv > in > User:Home

# Section.Deppendency

# Parse > Arg
while getopts ":m:n:t:w:i:a:b:c:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    a) siFileType=$OPTARG;;          ## Mandatory > checked > by > caller
    b) siParma01=$OPTARG;; ## Optional
    c) siParam02=$OPTARG;; ## Optional
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
# ## User
# sUserOsSsh=$(ssh ${siVmName} id -nu)
# siUserOsUsed=${siParma01:-${sUserOsSsh}}
## Map > id > To > Cli
siFileName="${siFileType}.sh"
siFileFolder="${sThisFileFolder}/${siOtpWord}"
siFilePath="${siFileFolder}/${siFileName}"
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord}"
[ -z "${siFileType}" ] || siListArg="${siListArg} -a ${siFileType}"
[ -z "${siParma01}" ] || siListArg="${siListArg} -b ${siParma01}"

## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}:${siFileType}][${siOtpWord}]"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siFileType}"
[ -z "${siParam01}" ] || siListArg="${siListArg} -b ${siParam01}"
[ -z "${siParam02}" ] || siListArg="${siListArg} -c ${siParam02}"
# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content

# Check > Arg > Is > Provided
[ -z ${siFileType} ] && { printf "    - Error %-48s > Missing > %s : type\n": "${sDebugPath}" "${siOtpType}" ; exit; }

# Check > File.Local.Code > Exists
[ -f "${siFilePath}" ] || { printf "    - Error %-48s > Not Exists > File : %s\n" "${sDebugPath}"  "${siFileName}" ; exit; }

# Action
sAction="${siFilePath} ${siListArg}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

#sThisFileName=$(basename ${sThisFilePath})

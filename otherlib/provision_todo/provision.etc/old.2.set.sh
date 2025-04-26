#!/bin/bash

# Section.Description > Provision > Os:User:Home:File
# Section.Description > Provision > Os:User:Home:File.Key.Priv > in > User:Home

# Section.Deppendency

# Parse > Arg
while getopts ":m:n:t:w:a:b:c:d:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    a) siOtpId=$OPTARG;;          ## Mandatory > checked > by > caller
    b) siParama01=$OPTARG;; ## Optional
    c) siParama02=$OPTARG;; ## Optional
    d) siParama03=$OPTARG;; ## Optional
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileFolder=$(dirname ${sThisFilePath})
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
## Map > id > To > Cli
siFileName="${siOtpId}.sh"
siFileFolder="${sThisFileFolder}/set"
siFilePath="${siFileFolder}/${siFileName}"
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord}"
[ -z "${siParama01}" ] || siListArg="${siListArg} -a ${siParama01}"
[ -z "${siParama02}" ] || siListArg="${siListArg} -b ${siParama02}"
[ -z "${siParama03}" ] || siListArg="${siListArg} -c ${siParama03}"
[ -z "${siParama04}" ] || siListArg="${siListArg} -d ${siParama04}"

## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}]"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siOtpId}           = ${siOtpId}
# \${siOtpName}         = ${siOtpName}
# \${sUserOsSsh}        = ${sUserOsSsh}
# \${siUserOsProvided}  = ${siUserOsProvided}
# \${siUserOsUsed}      = ${siUserOsUsed}
# \${siListArg}         = ${siListArg}
# ## Section.Debug ##
# Content

# Check > File.Local.Code > Exists
[ -f "${siFilePath}" ] || { printf "    - Error %-48s > Not Exists > %s : %s\n" "${sDebugPath}" "${siOtpWord}" "${siFileName}" ; exit; }

# Action
sAction="${siFilePath} ${siListArg}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

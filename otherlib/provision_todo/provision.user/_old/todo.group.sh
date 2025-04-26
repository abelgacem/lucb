#!/bin/bash

# Section.Description > Provision > Os:User:Group

# Section.Deppendency

# Parse > Arg
while getopts ":m:n:t:w:p:u:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    p) siOtpId=$OPTARG;;          ## Mandatory > checked > by > caller
    u) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
## File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}

## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}]"

# Display > Info
siListArg="-v ${siVmName} -u ${siUserOsUsed}"
lInfo=" - Action\n   - Provision > User:${siUserOsUsed}:Group:${siOtpId}"; echo -e "${lInfo}"

# Check > User > Exists 
result=$(ssh o3c "id ${siUserOsUsed} &> /dev/null  || echo  ko")
[ -z ${result} ] || { echo -e " - CliExecutionError\n   - User [Not exists]: ${siUserOsUsed}" ; exit; }

# Check > Group > Exists
result=$(ssh o3c "id ${siOtpId} &> /dev/null  || echo  ko")
[ -z ${result} ] || { echo -e " - CliExecutionError\n   - Group [Not exists]: ${siOtpId}" ; exit; }

# Step 
sAction="ssh ${siVmName} sudo usermod -aG ${siOtpId} ${siUserOsUsed}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
#${sAction}

#!/bin/bash

# Section.Description > Provision > Os:Object > like > hostname

# Section.Deppendency > none

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
sThisFilePath=$0
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
# Map > NameOrId > to > Cli
siFileName="${siOtpId}.sh"
siFileFolder="${sThisFileFolder}/set"
siFilePath="${siFileFolder}/${siFileName}"
## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}]"
## ListArg
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord}  -p ${siOtpId}"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siOtpWord}       = ${siOtpWord}
# \${siVmName}        = ${siVmName}
# \${siOtpId}         = ${siOtpId}
# \${siUserOsUsed}    = ${siUserOsUsed}
# ## Section.Debug ##
# Content

# Step
shift 11
sParam=${1}

# Define > Var
siListArg="${siListArg} -q ${sParam}"

# Check > File.Local > Exists
[ -f "${siFilePath}" ] || { printf "    - Error %-38s > Exists [Not] > %s\n" "${sDebugPath}" "${siFileName}" ; exit; }

# Check > Param > is > Provided [if > Not > Exit]
#[ -z "${sParam}" ] && { echo -e "- CliExecutionError > Missing > Id or Name"; exit; }
#[ -f "${siFilePath}" ] || { printf "    - Error %-38s > Missing > Id or Name > \n" "${sDebugPath}"; exit; }
[ -z "${sParam}" ] && { printf "    - Error %-38s > Missing > Id or Name > \n" "${sDebugPath}"; exit; }


# cat << Content
#   - Action > Play > Cli
#     - File   : ${siFileName}
#     - Folder : ${siFileFolder}
#     - Arg    : ${siListArg}
# Content

# Check > File.Local > Exists
[ -f "${siFilePath}" ] || { printf "    - Error %-48s > Exists [Not] > %s\n" "${sDebugPath}" "${siFileName}" ; exit; }

# Action
sAction="${siFilePath} ${siListArg}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

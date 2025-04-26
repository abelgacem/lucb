#!/bin/bash

# Section.Description > Provision > Os:User:Home:Folder

# Section.Deppendency > None

# Parse > Arg
while getopts ":m:n:t:w:a:b:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    a) siOtpId=$OPTARG;;          ## Mandatory > checked > by > caller
    b) siUserOsProvided=$OPTARG;;          ## Mandatory > checked > by > caller
  esac
done

# Define > Var
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
## Map > id > To > Otp:Name
siOtpName=${siOtpId}
## Otp:Property
siFolderBase="/home/${siUserOsUsed}"
siFolderPath="${siFolderBase}/${siOtpName}"

## Debug
#sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}]"
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}:${siUserOsUsed}][${siOtpWord}]"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siOtpId}           = ${siOtpId}
# \${siOtpName}         = ${siOtpName}
# \${sUserOsSsh}        = ${sUserOsSsh}
# \${siUserOsProvided}  = ${siUserOsProvided}
# \${siUserOsUsed}      = ${siUserOsUsed}
# ## Section.Debug ##
# Content

# Check > Arg > Is > Provided
[ -z ${siOtpId} ] && { printf "    - Error %-48s > Missing > %s : Name\n": "${sDebugPath}" "${siOtpWord}" ; exit; }

# Check > User.Remote > Exists
sAction="ssh ${siVmName} id ${siUserOsUsed} 2> /dev/null && echo  exist"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warning %-48s > Not Exists > user : %s\n" "${sDebugPath}" "${siUserOsUsed}" ; exit; }

# Step 
sAction="ssh ${siVmName} sudo mkdir -p ${siFolderPath}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Step 
sAction="ssh ${siVmName} sudo chmod -R 700 ${siFolderPath}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Step 
sAction="ssh ${siVmName} sudo chown -R ${siUserOsUsed}:${siUserOsUsed} /home/${siUserOsUsed}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action [Folder > exist]
sAction="ssh ${siVmName} sudo tree ${siFolderPath} | head -1"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > Folder > Exists > ${sCheck}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"

# # File.This
# sThisFilePath=${BASH_SOURCE}
# sThisFileName=$(basename ${sThisFilePath})
# sThisFileId=${sThisFileName//.sh}
# sThisFileFolder=$(dirname ${sThisFilePath})

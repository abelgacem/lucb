#!/bin/bash

# Section.Description > Provision > Os:User

# Section.Deppendency > None

# Parse > Arg
while getopts ":m:n:t:w:i:a:b:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    i) siOtpId=$OPTARG;;          ## Mandatory > checked > by > caller
    a) siUserOsProvided=$OPTARG;;          ## Mandatory > checked > by > caller
    b) siUserOsProvided=$OPTARG;;          ## Mandatory > checked > by > caller
  esac
done

# Define > Var
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
## Map > id > To > Otp
siOtpName=${siOtpId}
siFolderBase="/home/${siUserOsUsed}"
siFolderPath="${siFolderBase}/${siOtpName}"


siFileName="key.ssh.priv.${siOtpId}"
siFileFolderSrc="${gUserSecretFolder}/keyssh"
siFilePathSrc="${siFileFolderSrc}/${siFileName}"
siFileFolderDst="/home/${siUserOsUsed}/mx/secret/keyssh"
siFilePathDst="${siFileFolderDst}/${siFileName}"


## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}][${siOtpId}][${siUserOsUsed}]"

# Section.Debug
cat << Content
## Section.Debug ##
\${siOtpId}           = ${siOtpId}
\${siOtpName}         = ${siOtpName}
\${sUserOsSsh}        = ${sUserOsSsh}
\${siUserOsProvided}  = ${siUserOsProvided}
\${siUserOsUsed}      = ${siUserOsUsed}
## Section.Debug ##
Content

exit

# Check > User > Exists
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

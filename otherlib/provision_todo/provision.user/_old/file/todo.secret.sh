#!/bin/bash

# Section.Description > Provision > File.Key.Pub > in > User:Home

# Dependency
. $(dirname $BASH_SOURCE)/../../_provision/provision.sh

# Parse > Arg
while getopts ":m:n:t:w:p:u:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    t) siOtpType=$OPTARG;;
    p) siOtpId=$OPTARG;;          ## Mandatory > checked > by > caller
    u) siUserOsProvided=$OPTARG;; ## Optional
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
## Map > IdOrName > File > to > Provision
siFileName="key.ssh.priv.*"
siFileFolderSrc="${gUserSecretFolder}/keyssh"
siFilePathSrc="${siFileFolderSrc}/${siFileName}"
siFileFolderDst="/home/${siUserOsUsed}/.ssh/keysshpriv"
siFilePathDst="${siFileFolderDst}/${siFileName}"

## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}][${siOtpId}]"


# Section.Debug
cat << Content
## Section.Debug ##
\${siOtpMetaType}     = ${siOtpMetaType}
\${siVmName}          = ${siVmName}
\${siOtpType}         = ${siOtpType}
\${siOtpWord}         = ${siOtpWord}
\${siOtpId}           = ${siOtpId}
\${siUserOsProvided}  = ${siUserOsProvided}
\${siFilePathSrc}     = ${siFilePathSrc}
\${siFilePathDst}     = ${siFilePathDst}
## Section.Debug ##
Content

# Display > Info
echo -e "    - Action ${sDebugPath} > Provision > Secret : ${siFilePathDst}"


# Check > Secret.Src > exists
[ -f ${siFilePathSrc} ] || { echo -e "    - CliExecutionError ${sDebugPath} > Secret.Src [Not exists]: ${siFilePathSrc}" ; exit; }

exit

# Step
#echo "STEP"
mx-provision vm.linux "${siVmName}" user folder ".ssh/keysshpriv" "${siUserOsUsed}"

# Step
#echo "CONTINUE"
sAction="cat ${siFilePathSrc} | ssh ${siVmName} \"sudo tee -a ${siFilePathDst}\" > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}

# Step
sAction="ssh ${siVmName} sudo chmod 600 ${siFilePathDst}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}

# Step
sAction="ssh ${siVmName} sudo chown -R ${siUserOsUsed}:${siUserOsUsed} /home/${siUserOsUsed}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action [File > exist]
sAction="ssh ${siVmName} sudo ls ${siFilePathDst}"
sResult="$(${sAction})"
echo -e "      - Check ${sDebugPath} > File > Exists > ${sResult}"

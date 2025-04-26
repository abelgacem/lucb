#!/bin/bash

# Section.Description > Provision > File.Key.Pub > in > User:Home

# Dependency
. $(dirname $BASH_SOURCE)/../_provision/provision.sh

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
## Var.local > from > Var.Env.(Etc|User)
sgUserGitFolderRootPath=${gUserGitFolderRootPath}
sgGitRepoCodeName=${gGitRepoCodeName}

# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
## Map > IdOrName > File > to > Provision
siFileName="${siOtpId}.lib.sh"
siFileFolderSrc="${sgUserGitFolderRootPath}/${sgGitRepoCodeName}/lib/bash"
siFilePathSrc="${siFileFolderSrc}/${siFileName}"
siFileFolderDst="/home/${siUserOsUsed}/mx/lib"
siFilePathDst="${siFileFolderDst}/${siFileName}"
## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}]"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siVmName}         = ${siVmName}
# \${siUserOsUsed}     = ${siUserOsUsed}
# ## Section.Debug ##
# Content

# Display > Info
printf "  - Action  %-48s > Provision > ${siOtpWord} > %s\n" "${sDebugPath}" "${siFilePathDst}"
#echo -e "    - Action ${sDebugPath} > Provision > File.Lib : ${siFilePathDst}"

# Check > File.local > exists
[ -f ${siFilePathSrc} ] || { printf "    - Error %-48s > File.${siOtpWord} [Not exists]: ${siFilePathSrc}" "${sDebugPath}"; exit; }

# Check > User.Remote > Exists
sCheck=$(ssh ${siVmName} "id ${siUserOsUsed} &> /dev/null  || echo  ko")
[ -z ${sCheck} ] || { printf "    - Error %-48s > User [Not exists]: ${siUserOsUsed}" "${sDebugPath}" ; exit; }

# Step
##echo "STEP"
mx-provision vm.linux "${siVmName}" user folder "mx/lib" "${siUserOsUsed}"

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
# sResult="$(${sAction})"
# echo -e "      - Check ${sDebugPath}    > File   > Exists > ${sResult}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"

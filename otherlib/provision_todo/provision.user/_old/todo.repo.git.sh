#!/bin/bash

# Section.Description > Provision > Repo.Git > in > Os:User:Home

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
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
## Map > IdOrName > File > to > Provision
siRepoName="${siOtpId}"
siFileFolderSrc="${gUserGitFolderRootPath}/${siRepoName}"
siFilePathSrc="${siFileFolderSrc}/${siFileName}"
siFileFolderDst="/home/${siUserOsUsed}/mx/secret/keyssh"
siFilePathDst="${siFileFolderDst}/${siFileName}"
## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}]"

## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}]"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siFilePathSrc}     = ${siFilePathSrc}
# \${siFilePathDst}     = ${siFilePathDst}
# ## Section.Debug ##
# Content

# Display > Info
echo -e "    - Action ${sDebugPath} > Provision > ${siOtpWord} : ${siRepoName}"

# Check > User > Exists
result=$(ssh ${siVmName} "id ${siUserOsUsed} &> /dev/null  || echo  ko")
[ -z ${result} ] || { echo -e "    - CliExecutionError ${sDebugPath} > User [Not exists]: ${siUserOsUsed}" ; exit; }

# STEP 
mx-provision vm.linux "${siVmName}" user folder    "mx/git"     ${siUserOsUsed}
mx-provision vm.linux "${siVmName}" user lib       "git"        ${siUserOsUsed}
mx-provision vm.linux "${siVmName}" user key.priv  "git.perso"  ${siUserOsUsed}
mx-provision vm.linux "${siVmName}" user file      "conf.ssh"   ${siUserOsUsed}
mx-provision vm.linux "${siVmName}" user file      "conf.git"   ${siUserOsUsed}


# STEP
sAction="ssh ${siVmName} sudo su ${siUserOsUsed} mx-git-repo-clone"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}

exit


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

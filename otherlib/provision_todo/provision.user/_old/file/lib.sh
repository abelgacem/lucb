#!/bin/bash

# Section.Description > Provision > File > in > Os:User:Home

# Section.Deppendency > none

# Parse > Arg
while getopts ":m:n:t:w:a:b:c:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;
    a) siOtpSType=$OPTARG;;       ## checked > by > caller
    b) siOtpId=$OPTARG;;          ## Mandatory
    c) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
## Todo > From Env 
### sgUserGitFolderRootPath=gUserGitFolderRootPath
### sgGitRepoCodeName=gGitRepoCodeName
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
## Map > id > To > Otp
siFileName="${siOtpId}.lib.sh"
siFileFolderSrc="${gUserGitFolderRootPath}/${gGitRepoCodeName}/lib/bash"
siFilePathSrc="${siFileFolderSrc}/${siFileName}"
siFileFolderDst="/home/${siUserOsUsed}/mx/lib"
siFilePathDst="${siFileFolderDst}/${siFileName}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}:${siUserOsUsed}][${siOtpWord}][${siOtpSType}]"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siOtpId} -c ${siUserOsProvided}"
## Display > Info
printf "    - Do    %-48s > %s\n" "${sDebugPath}" "${siFilePathSrc}"

# cat << Content
  
#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content

# Check > Arg > Is > Provided
[ -z ${siOtpId} ] && { printf "    - Error %-48s > Missing > %s : Id\n": "${sDebugPath}" "${siOtpSType}" ; exit; }

# Check > File.Local.Src > exists
[ -f ${siFilePathSrc} ] || { printf "    - Error %-48s > Not exists > File.Local.Src : %s\n" "${sDebugPath}" "${siFilePathSrc}"; exit; }

# Check > User.Remote > Exists
sAction="ssh ${siVmName} id ${siUserOsUsed} 2> /dev/null && echo  exist"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warn  %-48s > Not Exists > user : %s\n" "${sDebugPath}" "${siUserOsUsed}" ; exit; }

# Check > Folder.Remote > Exists
sAction="ssh ${siVmName} sudo [ -d ${siFileFolderDst} ] && echo notexists"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warn  %-48s > Not Exists > Folder.Remote.Dst : %s\n" "${sDebugPath}" "${siFileFolderDst}" ; exit; }

# Action
sAction="cat ${siFilePathSrc} | ssh ${siVmName} \"sudo tee ${siFilePathDst}\" > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
eval ${sAction}

# Step
sAction="ssh ${siVmName} sudo chown -R ${siUserOsUsed}:${siUserOsUsed} /home/${siUserOsUsed}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action > File > exist [Count > Item]
sAction="ssh ${siVmName} sudo ls ${siFilePathDst}"
sCheck01="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}" "${sCheck01}"
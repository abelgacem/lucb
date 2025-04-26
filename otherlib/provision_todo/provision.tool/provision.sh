#!/bin/bash

# Section.Description > Provision > Os:User:Home:File
# Section.Description > Provision > Os:User:Home:File.Key.Priv > in > User:Home

# Section.Deppendency

# Parse > Arg
while getopts ":v:o:t:a:b:c:d:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    v) siVmName=$OPTARG;;
    o) siOtp=$OPTARG;;
  esac
done

# Step
# - Scp        > file to /tmp
# - Play.SSh   > file via ssh
# - Check      > Action
# - Remove     > File


cat << Content
  ## Section.Debug > [${sThisFileName}] ##
  Scp      > File > provision.tool.${siOtp} > to > vm > $siVmName
  play.Ssh > File
Content
return

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

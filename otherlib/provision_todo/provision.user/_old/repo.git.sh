#!/bin/bash

# Section.Description > Provision > Os:User

# Section.Deppendency > None

# Parse > Arg
while getopts ":m:n:t:w:a:b:c:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;           ## Mandatory > checked > by > caller
    a) siRepoOrganization=$OPTARG;;  ## Mandatory > checked > by > caller
    b) siRepoName=$OPTARG;;          ## Mandatory
    c) siUserOsProvided=$OPTARG;;    ## Optional
  esac
done


# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Folder > to > provision
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
# ## Map > id > To > Otp
# siOtpName01=${siRepoOrganization}
# siOtpName02=${siRepoName}
##
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}:${siUserOsUsed}][${siOtpWord}:${siOtpName}]"
## Display > Info
printf "    - Do    %-48s > Via > Lib:Method > /home/${siUserOsUsed}/mx/lib/git.lib.sh:mx-git-repo-clone \n" "${sDebugPath}"
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord} -a ${siRepoOrganization} -b ${siRepoName} -c ${siUserOsProvided}"

# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${siListArg}       = ${siListArg}
# Content

# Check > Arg > Is > Provided
[ -z ${siRepoOrganization} ] && { printf "    - Error %-48s > Missing > %s : Organization\n": "${sDebugPath}" "${siOtpWord}" ; exit; }

# Check > Arg > Is > Provided
[ -z ${siRepoName} ] && { printf "    - Error %-48s > Missing > %s : Name\n": "${sDebugPath}" "${siOtpWord}" ; exit; }

# Check > User.Remote > Exists 
sAction="ssh ${siVmName} id ${siUserOsUsed} 2> /dev/null && echo  exist"
sCheck="$(${sAction})"
[ -z "${sCheck}" ] && { printf "    - Warn   %-48s > Not Exists > ${siOtpType} : %s\n" "${sDebugPath}" "${siUserOsUsed}" ; exit; }

# Step
sAction="ssh ${siVmName} sudo -Eu ${siUserOsUsed} bash -c '. /home/${siUserOsUsed}/mx/lib/git.lib.sh && mx-git-repo-clone ${siRepoOrganization} ${siRepoName} /home/${siUserOsUsed}/mx/git'"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action > Folder > exist
sAction="ssh ${siVmName} sudo tree \"/home/${siUserOsUsed}/mx/git/${siRepoName}\" | head -1"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > Folder > Exists > ${sCheck}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}" "${sCheck}"

#!/bin/bash

# Section.Description > Provision > File > in > /etc

# Section.Deppendency > none

# Parse > Arg
while getopts ":m:n:t:w:a:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    a) siOtpId=$OPTARG;;          ## Mandatory > checked > by > caller
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## File > to > Provision
siFileName="alias.env.sh"
siFileFolder="/etc/profile.d"
siFilePath="${siFileFolder}/${siFileName}"
##
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpId}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpId}]"
## Display > Info
printf "    - Do    %-48s > From Scratch\n" "${sDebugPath}"
# cat << Content
  
#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content

# Action
cat <<EOF | ssh ${siVmName} sudo tee ${siFilePath} >/dev/null
# ${siFilePath}

# Alias.Global
alias  h='history'
alias  hc='history -c'
alias  li='ls -ial'
alias  lr='ls -lirt'
alias  ll='ls -ialh'
alias  psa='ps -ef'

alias  mx-dvu='cat \${HOME}/\${gUserFolderMxName}/var/var.env.sh'     # Display > Var.User
alias  mx-dvg='cat /etc/profile.d/var.env.sh'                         # Display > Var.Global

alias  mx-dau='cat \${HOME}/\${gUserFolderMxName}/var/alias.env.sh'   # Display > Alias.User
alias  mx-dag='cat /etc/profile.d/alias.env.sh'                       # Display > Alia.Global

alias   mx-cd-git='cd \${gUserGitFolderRootPath}'                     # Cd > Folder
alias   mx-cd-git-provision='cd \${gUserGitFolderRootPath}/provision' # Cd > Folder

alias    srcb='source \${HOME}/\${gUserShellRcFilename}'

EOF

# Check > Action > File > exist
sAction="ssh ${siVmName} sudo ls ${siFilePath}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}" "${sCheck}"
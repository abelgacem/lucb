#!/bin/bash

# Section.Description > Provision > File > in > Os:User:Home

# Section.Deppendency > none

# Parse > Arg
while getopts ":m:n:t:w:a:b:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;
    a) siOtpSType=$OPTARG;;       ## checked > by > caller
    b) siUserOsProvided=$OPTARG;; ## Optional
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
## Map > File.this > To > Otp.File
siFileName=".bashrc"
siFileFolder="/home/${siUserOsUsed}"
siFilePath="${siFileFolder}/${siFileName}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}:${siUserOsUsed}][${siOtpWord}][${siOtpSType}]"
sListArg="-m ${siOtpMetaType} -n ${siOtpMetaName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siUserOsProvided}"
## Display > Info
printf "    - Do    %-48s > From Scratch\n" "${sDebugPath}"
# cat << Content
  
#   ## Section.Debug > [${sThisFileName}] ##
#   \${sListArg}       = ${sListArg}
# Content

# Check > User.Remote > Exists
sAction="ssh ${siVmName} id ${siUserOsUsed} 2> /dev/null && echo  exist"
sCheck="$(${sAction})"  # Empty > if > Notexists
[ -z "${sCheck}" ] && { printf "    - Warning %-48s > Not Exists > user : %s\n" "${sDebugPath}" "${siUserOsUsed}" ; exit; }

cat <<EOF | ssh ${siVmName} sudo tee ${siFilePath} >/dev/null
#!bin/bash
# ${siFilePath}

source /etc/profile.d/var.env.sh   # Default
source /etc/profile.d/alias.env.sh # Default
[ -f "\${HOME}/var/var.env.sh"   ] && source \${HOME}/var/var.env.sh    # override & Specific
[ -f "\${HOME}/var/alias.env.sh" ] && source \${HOME}/var/alias.env.sh  # override & Specific

# Source (Var, Alias, Method).(Global, Default)
for file in /etc/profile.d/*.sh; do
  [ -f "\${file}" ] && . "\${file}"
done

# Source (Var, Alias, Method).(Global, Default)
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User : Repo : (var, alias, method)
shopt -s nullglob  # No > error > if > Folder > Empty
sFolderPath="\${HOME}/\${gUserFolderMxName}/var"            && [ -d \${sFolderPath} ]  && { for stfile in \${sFolderPath}/*; do source \${stfile} ; done; }
sFolderPath="\${HOME}/\${gUserFolderMxName}/lib"            && [ -d \${sFolderPath} ]  && { for stfile in \${sFolderPath}/*; do source \${stfile} ; done; }

#sUserCurrent=\$(id -nu)
EOF

sAction="ssh ${siVmName} sudo chown -R ${siUserOsUsed}:${siUserOsUsed} /home/${siUserOsUsed}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}
# Check > Action > File > exist

sAction="ssh ${siVmName} sudo ls ${siFilePath}"
#echo -e "      - Check ${sDebugPath} > File > Exists > ${sCheck}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}" "${sCheck}"

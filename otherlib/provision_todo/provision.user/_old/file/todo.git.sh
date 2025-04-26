#!/bin/bash

# Section.Description > Provision > Os:User:Home:File.Key.Priv > in > User:Home

# Section.Deppendency > none

echo yeah

exit 


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
## File > to > Provision
siFileName=".bashrc"
siFileFolder="/home/${siUserOsUsed}"
siFilePath="${siFileFolder}/${siFileName}"

## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}][${siOtpId}]"

# # Section.Debug
# echo -e "\n## Section.Debug:Begin ##"
# echo -e "<siVmName>          = ${siVmName}"
# echo -e "<siFileName>        = ${siFileName}"
# echo -e "<siUserOsUsed>      = ${siUserOsUsed}"
# echo -e "## Section.Debug:End ##\n"

# Display > Info
siListArg="-v ${siVmName} -u ${siUserOsUsed}"
lInfo=" - Action\n   - Provision > User : ${siUserOsUsed} : File : ${siFileName}"; echo -e "${lInfo}"

# Step
cat <<EOF | ssh ${siVmName} sudo tee ${siFilePath} >/dev/null
#!bin/bash
# ${siFilePath}


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific var, aliases, methods
#. /etc/profile.d/var.env.sh

[ -f ~/mx/var/var/env.sh ] &&  . ~/mx/var/var/env.sh

[ -d ~/mx/lib] && {
  for file in ~/mx/lib/*; do . \${file} ; done
}
EOF

sAction="ssh ${siVmName} sudo chown -R ${siUserOsUsed}:${siUserOsUsed} /home/${siUserOsUsed}"
#echo -e "Debug > Cli > ${sAction}" 
${sAction}
#!/bin/bash

# Section.Description > Provision > File > in > Os:User:Home

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

sListPostToOpen="6443/tcp 2379-2380/tcp 10250/tcp 10257/tcp 10259/tcp"
## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}][${siOtpId}]"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siOtpId}           = ${siOtpId}
# \${siOtpName}         = ${siOtpName}
# \${sUserOsSsh}        = ${sUserOsSsh}
# \${siUserOsProvided}  = ${siUserOsProvided}
# \${siUserOsUsed}      = ${siUserOsUsed}
# \${siListArg}         = ${siListArg}
# ## Section.Debug ##
# Content

# Todo > Check > firewalld > exists

# Step
for stItemPort in ${sListPostToOpen}
do
sAction="ssh ${siVmName} sudo firewall-cmd --permanent --add-port=${stItemPort} -q"
#echo -e "      - Degub > Action > Cli > ${sAction}" 
${sAction}
done

# Step
sAction="ssh ${siVmName} sudo firewall-cmd --reload > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action > Port > Open
sAction="ssh ${siVmName} sudo firewall-cmd --permanent --list-ports"
sCheck="$(${sAction})"
printf "    - Check %-48s > Open > %s\n" "${sDebugPath}[ListPort]" "${sCheck}"

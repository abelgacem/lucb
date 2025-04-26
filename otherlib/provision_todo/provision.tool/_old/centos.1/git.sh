#!/bin/bash

# Section.Description > Provision > Os:Centos.1:Package


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
## Package > To > Provision
sGitRpmFileName="endpoint-repo-1.7-1.x86_64.rpm"
sGitRpmUrl="https://packages.endpoint.com/rhel/7/os/x86_64/${sGitRpmFileName}"
## Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpWord}][${siOtpType}:${siOtpId}]"
# Display > Info
printf "    - Do    %-48s \n" "${sDebugPath}" 

# Step
sAction="ssh ${siVmName} sudo yum install ${sGitRpmUrl} -q -y 2> /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Step
sAction="ssh ${siVmName} sudo yum install git -q -y > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action
sAction="ssh ${siVmName} git --version"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}" "${sCheck}"

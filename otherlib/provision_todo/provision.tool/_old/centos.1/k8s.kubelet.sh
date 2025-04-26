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
sPakageName="kubelet"

## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}][${siOtpId}]"

# Action
## --disableexcludes=kubernetes > is > for > security > map > to > parameter:exclude > in yum.repos.d
sAction="ssh ${siVmName} sudo yum install ${sPakageName} --disableexcludes=kubernetes -q -y 1> /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Action
sAction="ssh ${siVmName} sudo systemctl enable --now ${sPakageName}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action
sAction="ssh ${siVmName} \"sudo systemctl is-enabled ${sPakageName}\""
sCheck="$(eval ${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Status > %s\n" "${sDebugPath}[Kubelet]" "${sCheck}"

# Check > Action
sAction="ssh ${siVmName} \"sudo systemctl status kubelet | grep Active\""
sCheck="$(eval ${sAction})"
printf "    - Check %-48s > Status > %s\n" "${sDebugPath}[Kubelet][CrashLoop]" "${sCheck}"

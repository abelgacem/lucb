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
# sListPakage="wget tree firewalld telnet nmap kubeadm"
sListPakage="podman"
# Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpId}]"
# Display > Info
printf "    - Do    %-48s > %s\n" "${sDebugPath}" "${sListPakage}"

# Action
sAction="ssh ${siVmName} sudo yum install ${sListPakage} -q -y 1> /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action
sPackage="podman"
sAction="ssh ${siVmName}  ${sPackage} --version"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}[${sPackage}]" "${sCheck}"

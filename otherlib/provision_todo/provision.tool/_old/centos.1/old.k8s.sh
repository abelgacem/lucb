#!/bin/bash

# Section.Description > Provision > Os:Centos.1:Package.Basic


# Parse > Arg
while getopts ":v:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    v) siVmName=$OPTARG;;         ## Mandatory > checked > by > caller
  esac
done

# Define > Var
## File.This
sThisFilePath=$0
sThisFileName=$(basename ${sThisFilePath})
## Package > To > Provision
sListPakage="firewalld telnet nmap kubeadm"

# Display > Info
siListArg="-v ${siVmName} -u ${siUserOsUsed}"
lInfo=" - Action\n   - Provision > Package : ${sListPakage}"; echo -e "${lInfo}"

# Step01
sAction="ssh ${siVmName} sudo yum install ${sListPakage} -q -y"
#echo -e " - Degub > Play > Cli\n   -> ${sAction}" 
${sAction}

sAction="ssh ${siVmName} firewall-cmd --version"
version="$(${sAction})"
lInfo=" - Info\n   - Installed > ${version}"; echo -e "${lInfo}"

sAction="ssh ${siVmName} kubeadm --version"
version="$(${sAction})"
lInfo=" - Info\n   - Installed > ${version}"; echo -e "${lInfo}"

sAction="ssh ${siVmName} map --version"
version="$(${sAction})"
lInfo=" - Info\n   - Installed > ${version}"; echo -e "${lInfo}"

sAction="ssh ${siVmName} telnet --version"
version="$(${sAction})"
lInfo=" - Info\n   - Installed > ${version}"; echo -e "${lInfo}"



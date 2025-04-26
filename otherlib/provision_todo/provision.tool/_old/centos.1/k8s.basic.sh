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
sListPakage="firewalld telnet nmap runc"

## Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpId}]"

# Action
sAction="ssh ${siVmName} sudo yum install ${sListPakage} -q -y 1> /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Action
sAction="ssh ${siVmName} sudo systemctl enable --now firewalld"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}


# Check > Action
#sAction="ssh ${siVmName}  \"{ echo 'environ list' } | telnet | grep HOST\""
#sCheck="$(${sAction})"
sCheck="TODO"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}[Telnet]" "${sCheck}"

# Check > Action
sPackage="nmap"
sAction="ssh ${siVmName}  ${sPackage} --version | grep version"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}[${sPackage}]" "${sCheck}"

# Check > Action
sPackage="runc"
sAction="ssh ${siVmName}  ${sPackage} --version"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}[${sPackage}]" "${sCheck}"

# Check > Action
sAction="ssh ${siVmName}  sudo firewall-cmd --state"
sCheck01="$(${sAction})"
sAction="ssh ${siVmName}  sudo firewall-cmd --version"
sCheck02="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Status > %s\n" "${sDebugPath}[Fire]" "${sCheck01} (${sCheck02})"


#sAction="ssh ${siVmName}  systemctl status firewalld | head -1"
#sAction="ssh ${siVmName}  systemctl status firewalld | head -3 | tail -1"

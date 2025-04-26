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
sListPakage="tree"

## Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpId}]"

# ## Display > Info
printf "    - Do    %-48s > %s\n" "${sDebugPath}" "${sListPakage}"

# Action
sAction="ssh ${siVmName} sudo bash -c  '. /etc/os-release && echo \${VERSION_ID}'"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

echo toto
exit
# Check > Action
sPackage="wget"
sAction="ssh ${siVmName}  ${sPackage} --version | head -1"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}[${sPackage}]" "${sCheck}"

# Check > Action
sPackage="tree"
sAction="ssh ${siVmName}  ${sPackage} --version | cut -d'-' -f1"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}[${sPackage}]" "${sCheck}"

# Check > Action
sPackage="lsb_core"
#sAction="ssh ${siVmName}  ${sPackage} --version | cut -d'-' -f1"
#sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
#printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}[${sPackage}]" "${sCheck}"

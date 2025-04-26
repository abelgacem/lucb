#!/bin/bash

# Section.Description > Provision > Os:Centos.1:Package.Basic


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
sAppVersion="1.5.6"
sAppUrl="https://github.com/containerd/containerd/releases/download/v${sAppVersion}"
sAppTgz="containerd-${sAppVersion}-linux-amd64.tar.gz"
sApp="${sAppUrl}/${sAppTgz}"
sFilePathSrc="/tmp/${sAppTgz}"
sFileFolderDst="/usr/local/bin"
## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}][${siOtpId}]"

# Step
sAction="ssh ${siVmName} wget -qP /tmp ${sApp}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Step
sAction="ssh ${siVmName} sudo tar xf ${sFilePathSrc} -C ${sFileFolderDst}  --strip-components=1 --owner=root --group=root "
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Step
sAction="ssh ${siVmName} sudo rm -rf ${sFilePathSrc}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action [File > exist]
sAction="ssh ${siVmName} sudo ls ${sFileFolderDst}/containerd"
sCheck01="$(${sAction})"
sAction="ssh ${siVmName} sudo ${sFileFolderDst}/containerd --version"
sCheck02="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck01} (${sCheck02})"

## 
## wget -P /tmp ${sApp}
## tar xvf ${sAppTgz}


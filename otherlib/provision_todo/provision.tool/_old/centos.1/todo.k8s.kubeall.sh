#!/bin/bash

# Section.Description > Provision > Os:Centos.1:Package.Basic


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
## Package > To > Provision
sListPakage="kubelet kubeadm"

## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}][${siOtpId}]"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siOtpWord}        = ${siOtpWord}
# \${siVmName}         = ${siVmName}
# \${siOtpMetaType}    = ${siOtpMetaType}
# ## Section.Debug ##
# Content

# Action
## --disableexcludes=kubernetes > is > for > security > map > to > parameter:exclude > in yum.repos.d
sAction="ssh ${siVmName} sudo yum install ${sListPakage} --disableexcludes=kubernetes -q -y 2&1> /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Action
sAction="ssh ${siVmName} sudo systemctl enable --now kubelet"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action
sAction="ssh ${siVmName} \"sudo systemctl is-enabled kubelet\""
sCheck="$(eval ${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Status > %s\n" "${sDebugPath}[Kubelet]" "${sCheck}"

# Check > Action
sAction="ssh ${siVmName} \"sudo systemctl status kubelet | grep Active\""
sCheck="$(eval ${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Status > %s\n" "${sDebugPath}[Kubelet][CrashLoop]" "${sCheck}"

# Check > Action
sAction="ssh ${siVmName} kubeadm version -o short"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > Package > Exists > ${sCheck}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}[Kubeadm]" "${sCheck}"

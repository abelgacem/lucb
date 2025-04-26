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
sPakageName="kubeadm"

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
sAction="ssh ${siVmName} sudo kubeadm init --ignore-preflight-errors=NumCPU --cri-socket=/var/run/containerd/containerd.sock"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

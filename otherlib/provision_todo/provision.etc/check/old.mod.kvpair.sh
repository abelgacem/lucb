#!/bin/bash

# Section.Description > Provision > Alias.Etc

# Section.Deppendency > none

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
## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}][${siOtpId}]"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siOtpMetaType}    = ${siOtpMetaType}
# \${siOtpWord}        = ${siOtpWord}
# \${siVmName}         = ${siVmName}
# \${siUserOsUsed}     = ${siUserOsUsed}
# ## Section.Debug ##
# Content

# Check > List > Kernel.Kvpair : br_netfilter
sCheck01=$(ssh ${siVmName} "sudo sysctl -a --ignore 2>/dev/null | grep bridge | grep tables | head -1")
sCheck02=$(ssh ${siVmName} "sudo sysctl -a --ignore 2>/dev/null | grep bridge | grep tables | wc -l")
printf "    - Check %-40s > Exists > %s\n" "${sDebugPath}" "(${sCheck02}) ${sCheck01} "

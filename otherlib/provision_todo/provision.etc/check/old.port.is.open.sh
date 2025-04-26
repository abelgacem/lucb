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
    q) siPortOpen=$OPTARG;;       ## Mandatory > Port > to > Check
    u) siUserOsProvided=$OPTARG;; 
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

# Check > Port.Open
sCheck=$(ssh ${siVmName} sudo nmap -sT -O localhost | grep open | cut -d'/' -f1)
#echo $sCheck
sCheck01=$(echo ${sCheck})
printf "    - Check %-40s > Open > %s\n" "${sDebugPath}" "${sCheck01}"

# Check > Port.Open
#sCheck=$(ssh ${siVmName} sudo firewall-cmd --zone=public --list-all | grep ports | head -1)
sCheck=$(ssh ${siVmName} sudo firewall-cmd --permanent --list-ports)
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}[ListPort]" "${sCheck}"

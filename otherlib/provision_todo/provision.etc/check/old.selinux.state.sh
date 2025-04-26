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

# Check > Status
sAction="ssh ${siVmName} sudo getenforce"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > File Exists > ${sCheck}"
printf "    - Check %-40s > Status > %s\n" "${sDebugPath}" "${sCheck}"

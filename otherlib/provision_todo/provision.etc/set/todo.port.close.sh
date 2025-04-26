#!/bin/bash

# Section.Description > Provision > File > in > Os:User:Home

# Section.Deppendency > none

# Parse > Arg
while getopts ":m:n:t:w:i:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    i) siOtpId=$OPTARG;;          ## Mandatory > checked > by > caller
    a) siPortToOpen=$OPTARG;;          ## Mandatory > checked > by > caller
  esac
done

# Define > Var
## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}][${siOtpId}]"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siOtpId}           = ${siOtpId}
# \${siOtpName}         = ${siOtpName}
# \${sUserOsSsh}        = ${sUserOsSsh}
# \${siUserOsProvided}  = ${siUserOsProvided}
# \${siUserOsUsed}      = ${siUserOsUsed}
# \${siListArg}         = ${siListArg}
# ## Section.Debug ##
# Content

# Todo > Check > firewalld > exists

# Check > Arg > Is > Provided
[ -z ${siPortToOpen} ] && { printf "    - Error %-48s > Missing > Port\n": "${sDebugPath}" ; exit; }

# Step
sAction="ssh ${siVmName} sudo firewall-cmd --permanent --remove-port=${siPortToOpen} -q"
#echo -e "      - Degub > Action > Cli > ${sAction}" 
${sAction}

# Step
sAction="ssh ${siVmName} sudo firewall-cmd --reload > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action > Port > Open
sAction="ssh ${siVmName} sudo firewall-cmd --permanent --list-ports"
sCheck="$(${sAction})"
printf "    - Check %-48s > Open > %s\n" "${sDebugPath}[ListPort]" "${sCheck}"

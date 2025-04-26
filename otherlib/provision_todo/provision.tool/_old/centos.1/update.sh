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
## Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpId}]"

## Display > Info
printf "    - Do    %-48s > Take time first > time\n" "${sDebugPath}"

# Action
sAction="ssh ${siVmName} sudo yum update -q -y > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Action
sAction="ssh ${siVmName} sudo yum upgrade -q -y > /dev/null"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

# Check > Action
sCheck="MxDone"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}" "${sCheck}"

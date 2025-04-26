#!/bin/bash

# Section.Description
## Provision > All

# Define > Var
siVmName=${1}
sFolderThisFile=$(dirname $BASH_SOURCE)
stSequencetScriptLocalName01="package git"

# Check > Arg
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

for stScriptLocalName01 in ${stSequencetScriptLocalName01}
do
  sFileName="provision.${stScriptLocalName01}.remote.sh"
  sFilePath="${sFolderThisFile}/${sFileName}"
  
  #sAction="Mx > Copy : ${sFilePath} > to > Vm : ${siVmName}:/tmp"; echo -e "${sAction}"
  rsync ${sFilePath} ${siVmName}:/tmp 
  
  sAction="Mx > Play > Script : ${siVmName}:/tmp/${sFileName}"; echo -e "${sAction}"
  ssh ${siVmName} "/tmp/${sFileName}"
done

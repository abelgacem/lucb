#!/bin/bash

# Section.Description
## Provision > File.Code > to > Vm
## Play      > File.Code > from > Vm

# Define > Var
siVmName=${1}
sFolderThisFile=$(dirname $BASH_SOURCE)
stSequencetScriptLocalName="package git"                                                 # Concern > Vm.Current

# Check > input > is > provided
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

# Loop > on > File.Remote
for stScriptLocalName in ${stSequencetScriptLocalName}
do
  sFileName="provision.${stScriptLocalName}.remote.sh"
  sFilePath="${sFolderThisFile}/${sFileName}"
  
  sAction="Mx > Copy (To > Dst > Vm : ${siVmName}:/tmp ): Code : ${sFileName}"; echo -e "${sAction}"
  rsync ${sFilePath} ${siVmName}:/tmp

  
  sAction="Mx > Play > Script : ${siVmName}:/tmp/${sFileName}"; echo -e "${sAction}"
  ssh ${siVmName} "/tmp/${sFileName}"
done


# Semantic
## 1 > File      > Denote > Action:Provision
## 1 > File.Name > Denote > Action:Provision.Type

# This > Script > do > not > use > Folder > xxx.local.sh

#!/bin/bash

# Section.Description
## Provision > File.Code > to > Vm
## Play      > File.Code > from > Vm

# Define > Var
## Input.Mandatory
siVmName=${1}
## Input.Optional
siUserName=${1}
## Other
sFolderThisFile=$(dirname $BASH_SOURCE)
sSequencetScriptLocalName="alias.etc var.etc"                                          # Concern > Vm.Current
sSequencetScriptLocalName+=" conf.sshd conf.sudo"                                      # Concern > User.Current
sSequencetScriptLocalName+=" user.folder user.var conf.ssh lib.user lib.git conf.git"  # Concern > User.Current
sSequencetScriptLocalName+=" key.git.perso"                                            # Concern > User.Current
sSequencetScriptLocalName+=" user.bashrc"

# Check > input > is > provided
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

# Loop > on > File.Remote
for stScriptLocalName in ${sSequencetScriptLocalName}
do
  sFileName="provision.${stScriptLocalName}.remote.sh"
  sFilePath="${sFolderThisFile}/${sFileName}"
  
  sAction="Mx > Copy (To > Dst > Vm : ${siVmName}:/tmp ): Code : ${sFileName}"; echo -e "${sAction}"
  rsync ${sFilePath} ${siVmName}:/tmp

  # Manage > Lib
  ## Grep > on > Var > to > find > Obj
  grep lib <<< "${stScriptLocalName}" > /dev/null && \
  {
    sLibName="$(echo ${stScriptLocalName} | cut -d'.' -f2)"
    sLibFileName="${sLibName}.lib.sh"
    sLibFolderPath="/usr/local/etc/git/code/lib/bash"
    sLibFilePath="${sLibFolderPath}/${sLibFileName}"

    sAction="Mx > Copy (To > Dst > Vm : ${siVmName}:/tmp ): Lib  : ${sFileName}"; echo -e "${sAction}"
    rsync ${sLibFilePath} ${siVmName}:/tmp    
  }

  # Manage > Key.Priv
  ## Grep > on > Var > to > find > Obj
  grep key <<< "${stScriptLocalName}" > /dev/null && \
  {
    sKeyName="$(echo ${stScriptLocalName} | cut -d'.' -f2,3)"
    sKeyFileName="key.ssh.priv.${sKeyName}"
    sKeyFolderPath="/Users/max/Documents/NotInCloud/RepoDevops/sshkey"
    sKeyFilePath="${sKeyFolderPath}/${sKeyFileName}"

    sAction="Mx > Copy (To > Dst > Vm : ${siVmName}:/tmp ): ${sFileName}"; echo -e "${sAction}"
    rsync ${sKeyFilePath} ${siVmName}:/tmp    
  }
  
  #sAction="Mx > Play > Script : ${siVmName}:/tmp/${sFileName}"; echo -e "${sAction}"
  ssh ${siVmName} "/tmp/${sFileName}"
done


# Semantic
## 1 > File      > Denote > Action:Provision
## 1 > File.Name > Denote > Action:Provision.Type

# This > Script > do > not > use > Folder > xxx.local.sh

#!/bin/bash

# Section.Description > Provision > User:Folder

# Dependency (File in User.Sudo:Home)
. ~/mx/lib/user.lib.sh

# Define > Var
## File.This
sThisFilePath=$0
sThisFileName=$(basename ${sThisFilePath})
## User.Current
sUserSsh=$(id -nu)
## Input > Optional
siUserName=${1:-$sUserSsh}
## Folder > to > Provision
sSequenceFolderName01=".ssh mx"
sSequenceFolderName02="mx/lib mx/git mx/var mx/sshkey .ssh/sshkeypriv"

# Step01 > Loop > on > ListFolder01
for tItemFolderName in ${sSequenceFolderName01}
do
  mx-user-folder-create ${siUserName} ${tItemFolderName}
done

# Step02 > Loop > on > ListFolder02
for tItemFolderName in ${sSequenceFolderName02}
do
  mx-user-folder-create ${siUserName} ${tItemFolderName}
done

## Step02
sAction="Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/${sThisFileName}

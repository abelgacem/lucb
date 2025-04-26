#!/bin/bash

# Section.Description > Provision > Var.User

# Define > Var
## File.This
sThisFilePath=$0
sThisFileName=$(basename ${sThisFilePath})
## File > to > Provision
sFileName="sudoers"
sFileFolder="/etc"
sFilePath="${sFileFolder}/${sFileName}"

## Step01 > Provision > File
sInfo="Provision > File : ${sFilePath} > with > Sed"; echo -e ${sInfo}
#sudo sed -ie 's/# %wheel/%wheel/g'  ${sFilePath}

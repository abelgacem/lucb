#!/bin/bash

# Section.Description > Provision > Conf:Sudo

# Define > Var
sThisFilePath=$0
sFileName="sudoers"
sFolderPath="/etc"
sFilePath="${sFolderPath}/${sFileName}"

sAction="Mx > Provision > Conf : File : ${sFilePath}"; echo -e "${sAction}"
sudo sed -ie 's/# %wheel/%wheel/g'  ${sFilePath}

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
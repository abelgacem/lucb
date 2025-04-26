#!/bin/bash

# Section.Description
## Provision > Git > Version.Last > on > Os:Centos:7


# Define > Var
## File.This
sThisFilePath=$0
sThisFileName=$(basename ${sThisFilePath})
## Package > To > Provision
sListPakage="wget tree firewalld"

sInfo="Mx > Provision > ListPackage.Yum: ${sListPakage}"

exit

# Step01
sAction="Mx > Provision > Package.Yum: ${sListPakage}"; echo -e "${sAction}"
sudo yum install ${sListPakage} -q -y

sAction="Mx > Display > App:Wget:Version"; echo -e "${sAction}"
wget --version | head -1

sAction="Mx > Display > App:Tree:Version"; echo -e "${sAction}"
tree --version

sAction="Mx > Display > App:firewalld: [not] running"; echo -e "${sAction}"
firewall-cmd --version

## Step02
sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/${sThisFileName}



#!/bin/bash

# Section.Description
## Provision > Git > Version.Last > on > Os:Centos:7


# Define > Var
sThisFilePathName=$0
sPakageList="wget tree firewalld"

sAction="Mx > Provision > Package.Yum: ${sPakageList}"; echo -e "${sAction}"
sudo yum install ${sPakageList} -q -y

sAction="Mx > Display > App:Wget:Version"; echo -e "${sAction}"
wget --version | head -1

sAction="Mx > Display > App:Tree:Version"; echo -e "${sAction}"
tree --version

sAction="Mx > Display > App:firewalld: [not] running"; echo -e "${sAction}"
firewall-cmd --version

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePathName})




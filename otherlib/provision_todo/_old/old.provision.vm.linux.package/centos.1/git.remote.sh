#!/bin/bash

# Section.Description
## Provision > Git > Version.Last > on > Os:Centos:7


# Define > Var
sThisFilePathName=$0
sGitRpmFileName="endpoint-repo-1.7-1.x86_64.rpm"
sGitRpmUrl="https://packages.endpoint.com/rhel/7/os/x86_64/${sGitRpmFileName}"

sAction="Mx > Provision > Repo.Yum : Git"; echo -e "${sAction}"
sudo yum install ${sGitRpmUrl} -q -y

sAction="Mx > Provision > Package.Yum:Git"; echo -e "${sAction}"
sudo yum install git -q -y

sAction="Mx > Display > App:Git:Version"; echo -e "${sAction}"
git --version

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePathName})
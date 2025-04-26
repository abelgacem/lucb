# [&larr;][Back_Readme] Provision > Tool

# Intro
Provision > Tool | Package > For > Os:Linux 

# Os
|Name|Tag|Desc|
|-|-|-|
|Ubuntu.1|-|Version 20.04|
|Ubuntu.2|-|Version 20.10|
|Centos.1|-|Version Centos7|
|Centos.2|-|Version Centos8|


# Todo
# Howto > Provision > Package.Git

## Toknow
o3c
  - Denote > 1 > entry > in > ~/.ssh/config > That
    - Denote > 1 > Ip
    - Denote > 1 > vm.Remote:User > whith > sudo
  - Have
    - Key.Priv > on > Local (in ~/.ssh/)  
    - Key.Pub > on > remote

## Prerequisite
o3c > exists

## Step

```bash
# Define > Var.Local
MxCodeFilename="provision.tool.git.sh"
MxFolder="/usr/local/etc/git/provision/shell/provision.vm.centos.7"

# Copy > File:This > to > Vm.remote.Centos.7:/tmp
rsync ${MxFolder}/${MxCodeFilename} o3c:/tmp

# Ssh > to > Vm
ssh o3c

# Define > Var.Remote
MxCodeFilename="provision.tool.git.sh"
MxFolder="/tmp"

# Play > File:This > from > Vm:/tmp
${MxFolder}/${MxCodeFilename}
```



[//]: #(Reference.Readme)
[Back_Readme]:         ../readme.md (List > Folder)

[File_env]:            ./provision.env.sh
[File_script]:            ./provision.sh
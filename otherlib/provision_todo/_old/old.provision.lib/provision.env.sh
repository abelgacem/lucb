#!/bin/bash

# Section.Description
## Define          > Var.(Bash, Global)
## Repo       > of > Var.(Bash, Global)
## Repo:Var.(Bash, Global)

## Vm.Remote:Name (as define in SshConfigFile) to connect the first time

# Provision > File.Code
export gCodeFileName="provision.remote.sh"
export gCodeEnvFileName="provision.env.sh"

# Provision > User:Home:Folder 
export gOsUser="mxadmin"
export gOsUserLibFolderName=".mxlib"
export gOsUserLibFolderPath="/home/${gOsUser}/.mxlib"
export gOsUserBashrcFilePath="/home/${gOsUser}/.bashrc"


# Provision > Lib.bash:
export gVmOsType="centos"
export gVmvarFileName="vmvar.sh"
export gLibFileFileName="file.lib.sh"
export gLibUserFileName="user.lib.sh"
export gLibAliasFileName="alias.${gVmOsType}.lib.sh"
export gLibGitFileName="git.lib.sh"

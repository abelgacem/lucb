#!/bin/bash

# Section.Description
## Define          > Var.(Bash, Global)
## Repo       > of > Var.(Bash, Global)
## Repo:Var.(Bash, Global)

## Vm.Remote:Name (as define in SshConfigFile) to connect the first time

# Provision > File.Code
export gCodeFileName="provision.remote.sh"
export gCodeEnvFileName="provision.env.sh"

# Data > OsUser
export gOsUser="mxadmin"

# Dependency > for > Script.Local > Lib.bash:
# Provision  > Lib.bash:
export gLibFileFileName="file.lib.sh"

# Provision > Config.Git
gGitConfigFileName=".gitconfig"
gGitConfigFilePath="/home/${gOsUser}/${gGitConfigFileName}"

# Provision > User:Home:Config.Git:Kvpair
export gGitUserName="abelgacem"
export gGitUserMail="abelgacem"

# Todo
## Configure Git:User
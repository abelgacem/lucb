#!/bin/bash

# Section.Description
## Define          > Var.(Bash, Global)
## Repo       > of > Var.(Bash, Global)
## Repo:Var.(Bash, Global)

## Vm.Remote:Name (as define in SshConfigFile) to connect the first time

# Provision > File.Code
export gCodeFileName="provision.remote.sh"
export gCodeEnvFileName="provision.env.sh"
# Provision > User 
export gOsUser="mxadmin"
export gSshKeyPubOvhFileName="sshkeyovh.pub"
# Provision > File.Lib.bash:
export gLibUserFileName="user.lib.sh"
export gLibFileFileName="file.lib.sh"


# export gOsUserLibFolderName=".mxlib"
# export gOsUserGitFolderName=".mxgit"
# Provision > User:Key.Pub

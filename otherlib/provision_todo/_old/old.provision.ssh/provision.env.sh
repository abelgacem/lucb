#!/bin/bash

# Section.Description
## Define          > Var.(Bash, Global)
## Repo       > of > Var.(Bash, Global)
## Repo:Var.(Bash, Global)

# Provision > File.Code
export gCodeFileName="provision.remote.sh"
export gCodeEnvFileName="provision.env.sh"
# Provision > Lib.bash:
export gLibFileFileName="file.lib.sh"
export gLibUserFileName="user.lib.sh"
# Provision > File > SshConfig
export gOsUser="mxadmin"
export gOsUserSshConfigFolderName="config.d"
export gOsUserSshConfigPath="/home/${gOsUser}/.ssh/config"
export gOsUserSshConfigFolderPath="/home/${gOsUser}/.ssh/${gOsUserSshConfigFolderName}"
export gOsUserSshKeyprivFolderName="sshkeypriv"
export gOsUserSshKeyprivFolderPath="/home/${gOsUser}/.ssh/${gOsUserSshKeyprivFolderName}"
export gSshConfigOvhFileName="ssh_config_ovh"

# Provision > File > User:Key.(Priv, Ssh):(Ovh,Github.Personal)
export gSshKeyPrivFolderName="/Users/max/Documents/NotInCloud/RepoDevops/sshkey"
export gSshKeyPrivOvhFileName="sshkeyovh"
export gSshKeyPrivGithubPersonalFileName="sshkeygithubpersonal"

# Provision > Lib.bash:
export gVmOsType="centos"
export gLibUserFileName="user.lib.sh"
export gLibAliasFileName="alias.lib.${gVmOsType}.sh"
export gLibGitFileName="git.lib.sh"
export gLibGitEnvFileName="git.env.sh"

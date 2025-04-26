#!/bin/bash

# Section.Description
## Define          > Var.(Bash, Global)
## Repo       > of > Var.(Bash, Global)
## Repo:Var.(Bash, Global)

## Vm.Remote:Name (as define in SshConfigFile) to connect the first time

# Define > Var
export gListGitFile="file.git.list"
export gListLocalFile="file.local.list"

# Provision > User 
export gOsUser="mxadmin"

# Provision > List > Package.Basic
export gListPakageBasic="wget tree"









## Provision > File > User:Key.Priv:Github.Perso
## Allow > User > git:Verb > to > Github > from > Vm
#export gSshKeyPrivGithubFileName="sshkeygithubpersonal"
#export gSshKeyPrivGithubFolderLocal="/Users/max/Documents/NotInCloud/Dev/ssh"

## Todo: Provision > File > User:Key.Priv:Vps.Ovh
## Allow > User > to > ssh > to > remote > from > VM
#export gSshKeyPrivOvhFileName="sshkeyovh"
#export gSshKeyPrivOvhFolderLocal="/Users/max/Documents/NotInCloud/Dev/ssh"


## Provision > File >  User:Key.Pub:Ovh
## Allow > User > to > ssh > to > Vm > from > remote
#export gSshKeyPubOvhFileName="sshkeyovh.pub"
#export gSshKeyPubOvhFolderLocal="/usr/local/etc/git/abtit/conf/ssh"


## Provision > File 
#export gSshConfigFileName="ssh_config"
#export gSshConfigFolderLocal="/usr/local/etc/git/conf/ssh"

## Provision > File 
#export gLibGitFileName="lib.git.01.sh"
#export gLibGitEnvFileName="env.git.01.sh"
#export gLibGitFolderLocal="/usr/local/etc/git/git/tool"

## Provision > File 
#export gOsType="centos"
#export gAliasGlobalFileName01="alias.lib.${gOsType}.sh"
#export gAliasGlobalFileName02="alias.lib.sh"
#export gAliasGlobalFolderLocal="/usr/local/etc/git/code/lib/bash"

## Provision > File 
#export gLibLinuxFileName="linux.01.lib.sh"
#export gLibLinuxFolderLocal="/usr/local/etc/git/code/lib/bash"

## Provision > File > Code
#export gCodeFileName="provision.remote.sh"
#export gCodeEnvFileName="provision.env.sh"

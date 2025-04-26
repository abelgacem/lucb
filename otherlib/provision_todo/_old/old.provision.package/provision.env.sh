#!/bin/bash

# Section.Description
## Define          > Var.(Bash, Global)
## Repo       > of > Var.(Bash, Global)
## Repo:Var.(Bash, Global)

## Vm.Remote:Name (as define in SshConfigFile) to connect the first time

# Provision > File.Code
export gCodeFileName="provision.remote.sh"
export gCodeEnvFileName="provision.env.sh"

# Provision > Lib.bash:
export gLibFileFileName="file.lib.sh"

# Provision > List > Package.Basic
export gListPakageBasic="wget tree firewalld"

# Provision > Package:Git
export gGitRpmFileName="endpoint-repo-1.7-1.x86_64.rpm"
export gGitRpmUrl="https://packages.endpoint.com/rhel/7/os/x86_64/${gGitRpmFileName}"

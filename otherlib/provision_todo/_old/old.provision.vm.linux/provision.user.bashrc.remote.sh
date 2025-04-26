#!/bin/bash

# Section.Description > Provision > User:Bashrc

# Define > Var
sThisFilePath=$0
sUserSsh=$(id -nu)
siUserName=${1:-$sUserSsh}
sFileName=".bashrc"
sFolderPath="/home/${siUserName}"
sFilePath="${sFolderPath}/${sFileName}"

# Provision > File > ${gK8sRepoYumPathname} (Repo.Yum)
sAction="Mx > Provision > File > ${sFilePath}"; echo "${sAction}"
cat <<EOF | sudo tee ${sFilePath} >/dev/null
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
#. /etc/profile.d/vm.var.sh
#. ./mxlib/git.lib.sh
. ./mxvar/user.var.sh
. ./mxlib/user.lib.sh
EOF



sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
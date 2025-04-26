#!/bin/bash

# Section.Description > Provision > Conf:Git

# Define > Var
sThisFilePath=$0
sUserSsh=$(id -nu)
siUserName=${1:-$sUserSsh}
sFileName=".gitconfig"
sFolderPath="/home/${siUserName}"
sFilePath="${sFolderPath}/${sFileName}"

sAction="Mx > Provision > File > ${sFilePath}"; echo "${sAction}"
cat <<EOF >> ${sFilePath}
# .gitconfig

[alias]
	# display status
	mxdst = status --short
	# display stagged file
	mxdsf = diff --name-only --cached
	# display last commit
	mxdlc = log -2  --pretty=format:'%h - %an, %ar : %s'
	# commit with no commit msg
	mxcnm = commit -m 'SC'
	# Open External tool with git
	mxcode =  !code

[color]
	ui = true
	status = auto
	branch = auto

[user]
	email = abelgacem
	name = abelgacem
EOF

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
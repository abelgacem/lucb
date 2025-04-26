#!/bin/bash

# Section.Description > Provision > User:Home:Var

# Define > Var
## File.This
sThisFilePath=$0
sThisFileName=$(basename ${sThisFilePath})
## User.Current
sUserSsh=$(id -nu)
## Input > Optional
siUserName=${1:-$sUserSsh}
## File > to > Provision
sFileName="var.env.sh"
sFileFolderRoot="/home/${siUserName}"
sFileFolder="${sFileFolderRoot}/mx/var"
sFilePath="${sFileFolder}/${sFileName}"



# Check > User > Exists
id -u ${siUserName}  &> /dev/null || { echo "MxError > User:${siUserName} > Not Exists"; exit; }

## Step01 > Provision > File
sInfo="Provision > File : ${sFileName} > to > ${sFileFolder}"; echo -e ${sInfo}

cat <<EOF | sudo tee ${sFilePath} >/dev/null
# Var.Local
export gOsUser=$(id -un)

export gGitRepoCodeName="code"
export gGitRepoCodePath="${gGitFolder}/${gGitRepoCodeName}"
export gGitRepoProvisionName="code"
export gGitRepoProvisionPath="${gGitFolder}/${gGitRepoProvisionName}"

#export gKeySshFolder="/Users/max/Documents/NotInCloud/RepoDevops/sshkey"
export gKeySshFolder="/home/${gOsUser}/mx/sshkey"


#!/bin/bash
# /home/${siUserName}/mx/var/user.var.sh
# ${sFilePath}

# Naming
## Naming > Folder:Location

export gGitFolder="/user/local/etc/git"
#export gGitFolder="/home/${siUserName}/mx/git"

export gSecretFolder="/user/local/etc/git"
#export gSecretFolder="/home/${siUserName}/mx/secret"

export gGitRepoProvisionFolder="${gGitFolder}/${gGitRepoProvisionName}"
export gGitRepoProvisionPath="${gGitFolder}/${gGitRepoProvisionName}"
export gGitRepoCodeFolder="${gGitFolder}/${gGitRepoCodeName}"
export gGitRepoCodePath="${gGitFolder}/${gGitRepoCodeName}"

EOF

sAction="sudo chown -R ${siUserName}:${siUserName} /home/${siUserName}"
#echo -e "${sAction}" 
${sAction}

## Step02
sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/${sThisFileName}

#!/bin/bash

# Define > Var.Script
sThisFilePathName=$0
sFilePathname="/tmp/mxvar"


sFolderThisFile=$(dirname $BASH_SOURCE)
stSequencetScriptLocalName01="alias.etc var.etc"
stSequencetScriptLocalName01+=" conf.sshd conf.sudo"
stSequencetScriptLocalName01+=" folder.home var.user conf.ssh lib.user lib.git conf.git"
stSequencetScriptLocalName01+=" key.git"
stSequencetScriptLocalName01+=" bashrc"

echo -e "mx > ${stSequencetScriptLocalName01}"

exit

# Provision > File
#cat <<EOF | sudo tee ${sFilePathname} >/dev/null
#cat <<EOF >> ${sFilePathname} >/dev/null
cat <<EOF >> ${sFilePathname}
#!/bin/bash

## My:Os:UserName
export gOsUser="mxadmin"

## My:Git:Conf
export gGitUserName="abelgacem"
export gGitUserMail="abelgacem"
export gGitRootFolderName=".mxgit"
export gGitRootFolderPath="/home/\${gOsUser}/\${gGitRootFolderName}"
titi
EOF

echo yo -  sThisFilePathName = $sThisFilePathName
echo yo -  FileName = $(basename $sThisFilePathName)
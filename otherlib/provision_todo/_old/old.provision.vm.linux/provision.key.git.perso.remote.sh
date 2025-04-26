#!/bin/bash

# Section.Description > Provision > Key.Pub

# Define > Var
sThisFilePath=$0
sUserSsh=$(id -nu)
siUserName=${1:-$sUserSsh}
sFolderPath="/home/${siUserName}"
sFolderThisFile=$(dirname $BASH_SOURCE)
sFileName="key.ssh.priv.git.perso"
sFilePathSrc="${sFolderThisFile}/${sFileName}"
sSssKeyPrivFolderName=".ssh/sshkeypriv"
sFilePathDst="${sFolderPath}/${sSssKeyPrivFolderName}/${sFileName}"

sAction="Mx > Copy : ${sFilePathSrc} > to > ${sFilePathDst}"; echo -e "${sAction}"
cp ${sFilePathSrc} ${sFilePathDst}
#sAction="Mx > Chmod : ${sFilePathDst} > to > 600"; echo -e "${sAction}"
chmod 600 ${sFilePathDst}

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
rm -rf /tmp/$(basename ${sFilePathSrc})

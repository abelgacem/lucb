#!/bin/bash

# Section.Description > Provision > User:Home:MxLib:User

# Define > Var
sThisFilePath=$0
sUserSsh=$(id -nu)
siUserName=${1:-$sUserSsh}
sFolderPath="/home/${siUserName}"
sFolderThisFile=$(dirname $BASH_SOURCE)
sFileName="user.lib.sh"
sFilePathSrc="${sFolderThisFile}/${sFileName}"
sLibFolderName="mxlib"
sFilePathDst="${sFolderPath}/${sLibFolderName}/${sFileName}"

sAction="Mx > Copy : ${sFilePathSrc} > to > ${sFilePathDst}"; echo "${sAction}"
cp ${sFilePathSrc} ${sFilePathDst}

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
rm -rf /tmp/$(basename ${sFilePathSrc})

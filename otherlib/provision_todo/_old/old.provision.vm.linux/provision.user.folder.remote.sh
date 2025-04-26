#!/bin/bash

# Section.Description > Provision > User:Folder

# Define > Var
sThisFilePath=$0
sUserSsh=$(id -nu)
siUserName=${1:-$sUserSsh}
sFolderPath="/home/${siUserName}"
sSequenceFolderName=".ssh mxlib mxgit mxvar .ssh/sshkeypriv"

# Loop > on > Folder
for stFolderName in ${sSequenceFolderName}
do
  sFolderPath="${sFolderPath}/${stFolderName}"  
  sAction="Mx > Create (if > NotExists) > folder : ${sFolderPath} "; echo -e "${sAction}"
  sudo mkdir -p ${stFolderPath}
  sudo chmod 700 ${stFolderPath}
  sudo chown -R ${siUserName}:${siUserName} ${stFolderPath}
done

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})

exit 



# stFolderPath="${sFolderPath}/${sSshFolderName}"
# sAction="Mx > Create (if > NotExists) > folder : ${stFolderPath} "; echo -e "${sAction}"
# sudo mkdir -p ${stFolderPath}
# sudo chmod 700 ${stFolderPath}
# sudo chown -R ${siUserName}:${siUserName} ${stFolderPath}

# stFolderPath="${sFolderPath}/${sLibFolderName}"
# sAction="Mx > Create (if > NotExists) > folder : ${stFolderPath} "; echo -e "${sAction}"
# sudo mkdir -p ${stFolderPath}
# sudo chown -R ${siUserName}:${siUserName} ${stFolderPath}

# stFolderPath="${sFolderPath}/${sGitFolderName}"
# sAction="Mx > Create (if > NotExists) > folder : ${stFolderPath} "; echo -e "${sAction}"
# sudo mkdir -p ${stFolderPath}
# sudo chown -R ${siUserName}:${siUserName} ${stFolderPath}

# stFolderPath="${sFolderPath}/${sVarFolderName}"
# sAction="Mx > Create (if > NotExists) > folder : ${stFolderPath} "; echo -e "${sAction}"
# sudo mkdir -p ${stFolderPath}
# sudo chown -R ${siUserName}:${siUserName} ${stFolderPath}


# stFolderPath="${sFolderPath}/${sSssKeyPrivFolderName}"
# sAction="Mx > Create (if > NotExists) > folder : ${stFolderPath} "; echo -e "${sAction}"
# sudo mkdir -p ${stFolderPath}
# sudo chmod 700 ${stFolderPath}
# sudo chown -R ${siUserName}:${siUserName} ${stFolderPath}

# sLibFolderName="mxlib"
# sSshFolderName=".ssh"
# sGitFolderName="mxgit"
# sVarFolderName="mxvar"
# sSssKeyPrivFolderName=".ssh/sshkeypriv"



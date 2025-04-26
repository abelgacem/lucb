#!/bin/bash

# Define > Var.Script
sFolderThisFile=$(dirname $BASH_SOURCE)

# Depnedency 01
. $(dirname $BASH_SOURCE)/provision.env.sh
. $(dirname $BASH_SOURCE)/${gLibFileFileName}
. $(dirname $BASH_SOURCE)/${gLibUserFileName}

# Define > Var.Script
siVmName="${1}"

# Check > Arg
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

# Define > Var.Script
sAction="Mx > Playing > script > ${siVmName} : ${BASH_SOURCE}"
echo "${sAction}"

# Provision > Folder:/etc/profile.d
sAction="Mx > Provision > File:/etc/profile.d/${gLibAliasFileName}"; echo "${sAction}"
sudo \cp    /tmp/${gLibAliasFileName}  /etc/profile.d

# Create > Folder > User:Home:Folder
mx-user-folder-create ${gOsUser} ${gOsUserLibFolderName}

# Provision > User:Home:Folder:Lib
sAction="Mx > Provision > ${gOsUserLibFolderPath}"; echo "${sAction}"
sudo \cp -p /tmp/${gLibGitFileName}    ${gOsUserLibFolderPath}

# Provision > User:Home:Folder:LibVmVar
sAction="Mx > Provision > ${gOsUserLibFolderPath}/Vmvar"; echo "${sAction}"
[ ! -z ${gOsUserLibFolderPath} ] && [ ! -f ${gOsUserLibFolderPath}/vmvar.sh ] && {
  sudo touch ${gOsUserLibFolderPath}/${gVmvarFileName}
  sudo chown ${gOsUser}:${gOsUser} ${gOsUserLibFolderPath}/${gVmvarFileName}
  echo -e "#!/bin/bash\n"              >> ${gOsUserLibFolderPath}/${gVmvarFileName}
  echo -e "export gOsUser=\"mxadmin\"" >> ${gOsUserLibFolderPath}/${gVmvarFileName}
  echo -e "export gOsUserGitFolderName=\".mxgit\"" >> ${gOsUserLibFolderPath}/${gVmvarFileName}
  echo -e "export gOsUserGitFolderPath=\"/home/${gOsUser}/\${gOsUserGitFolderName}\"" >> ${gOsUserLibFolderPath}/${gVmvarFileName}
}


# Provision > Upade > User:.bashrc
sAction="Mx > Uodate > User:Home:.bashrc"; echo "${sAction}"
sStingToGrep=${gVmvarFileName}      && grep "${gOsUserLibFolderName}/${sStingToGrep}" ${gOsUserBashrcFilePath} > /dev/null || (echo -e ". ${gOsUserLibFolderName}/${sStingToGrep}" >> ${gOsUserBashrcFilePath})
sStingToGrep=${gLibAliasFileName}   && grep "/etc/profile.d/${sStingToGrep}" ${gOsUserBashrcFilePath}          > /dev/null || (echo -e ". /etc/profile.d/${sStingToGrep}"          >> ${gOsUserBashrcFilePath})
sStingToGrep=${gLibGitFileName}     && grep "${gOsUserLibFolderName}/${sStingToGrep}" ${gOsUserBashrcFilePath} > /dev/null || (echo -e ". ${gOsUserLibFolderName}/${sStingToGrep}" >> ${gOsUserBashrcFilePath})

## Clean > /Tmp
mx-file-tmp-delete "${gCodeFileName}"
mx-file-tmp-delete "${gCodeEnvFileName}"
mx-file-tmp-delete "${gLibFileFileName}"
mx-file-tmp-delete "${gLibUserFileName}"
mx-file-tmp-delete "${gLibAliasFileName}"
mx-file-tmp-delete "${gLibGitFileName}"


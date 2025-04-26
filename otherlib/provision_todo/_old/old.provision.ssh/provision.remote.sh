#!/bin/bash

# Define > Var.Script
sFolderThisFile=$(dirname $BASH_SOURCE)
siVmName="${1}"

# Depnedency 01
. $(dirname $BASH_SOURCE)/provision.env.sh
. $(dirname $BASH_SOURCE)/${gLibFileFileName}
. $(dirname $BASH_SOURCE)/${gLibUserFileName}


# Check > Arg
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}

# Define > Var
sAction="Mx > Play      > script > ${siVmName} : ${BASH_SOURCE}"; echo "${sAction}"


# Create > User:Home:Folder
mx-user-folder-create ${gOsUser} .ssh/${gOsUserSshConfigFolderName}
mx-user-folder-create ${gOsUser} .ssh/${gOsUserSshKeyprivFolderName}

# Chmod > User:Home:Folder
sudo chmod 700 /home/${gOsUser}/.ssh/${gOsUserSshConfigFolderName}
sudo chmod 700 /home/${gOsUser}/.ssh/${gOsUserSshKeyprivFolderName}

# Provision > Folder/File > User:SshConfig:Ovh
sAction="Mx > Provision > Folder/File > ${gOsUserSshConfigFolderPath}/${gSshConfigOvhFileName}"; echo "${sAction}"
sudo \cp -p /tmp/${gSshConfigOvhFileName}   ${gOsUserSshConfigFolderPath}
sudo chmod 600 "${gOsUserSshConfigFolderPath}/${gSshConfigOvhFileName}"

# Provision > Folder/File > User:Home:Folder
sAction="Mx > Provision > File > ${gOsUserSshConfigPath}"; echo "${sAction}"
[ ! -f ${gOsUserSshConfigPath} ] && {
  touch ${gOsUserSshConfigPath}
  echo "include ${gOsUserSshConfigFolderName}/*" > ${gOsUserSshConfigPath}
  sudo chown ${gOsUser}:${gOsUser} ${gOsUserSshConfigPath}
  sudo chmod 600 ${gOsUserSshConfigPath}
}

# Provision > Folder/File > User:Key.Priv:Ovh
sAction="Mx > Provision > Folder/File > ${gOsUserSshKeyprivFolderPath}/${gSshKeyPrivOvhFileName}"; echo "${sAction}"
sudo \cp -p "/tmp/${gSshKeyPrivOvhFileName}"  "${gOsUserSshKeyprivFolderPath}"
sudo chmod 600 "${gOsUserSshKeyprivFolderPath}/${gSshKeyPrivOvhFileName}"

# Provision > File > User:Key.Priv:Github
sAction="Mx > Provision > Folder/File > ${gOsUserSshKeyprivFolderPath}/${gSshKeyPrivGithubPersonalFileName}"; echo "${sAction}"
sudo \cp -p "/tmp/${gSshKeyPrivGithubPersonalFileName}"  "${gOsUserSshKeyprivFolderPath}"
sudo chmod 600 "${gOsUserSshKeyprivFolderPath}/${gSshKeyPrivGithubPersonalFileName}"



## Clean > /Tmp
mx-file-tmp-delete "${gCodeFileName}"
mx-file-tmp-delete "${gCodeEnvFileName}"
mx-file-tmp-delete "${gLibFileFileName}"
mx-file-tmp-delete "${gLibUserFileName}"
mx-file-tmp-delete "${gSshKeyPrivOvhFileName}"
mx-file-tmp-delete "${gSshKeyPrivGithubPersonalFileName}"
mx-file-tmp-delete "${gSshConfigOvhFileName}"

exit

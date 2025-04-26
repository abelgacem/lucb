#!/bin/bash

# Depnedency
. $(dirname $BASH_SOURCE)/provision.env.sh      # Env  > for > Code
#. $(dirname $BASH_SOURCE)/git.lib.sh       # Repo > of > Code

## Method > from > linux.lib.sh
### mx-copy-sudo
### mx-copy-remote
### mx-user-delete
### mx-user-create
### user-keypub-add
### user-group-add




# Process > File
## Copy > File > from > git > to > Destination
while IFS= read -r line
do
  #echo "Process > ${line}"
  IFS=':' read -r lBranch lRepo lFileSrc lDst < <(echo "${line}")
  # Check > ${lFileSrc} > is > Defined
  [ ! -z ${lFileSrc} ] && {
      #echo "Ok"
      # mx-git-file-get  "${lRepo//[[:space:]]/}" "${lBranch//[[:space:]]/}" "${lFileSrc//[[:space:]]/}" "${lDst//[[:space:]]/}"
  }
  IFS=  
done < "${sFolderThisFile}/${gListGitFile}"

exit




# Define > Var.Script
sAction="Mx > Provision > remote"

echo "${sAction}"




## Provision > File
svFileSrc="${gSshConfigFileName}"
svDst="/etc/ssh"
mx-copy-sudo ${svFileSrc} ${svDst}

## Provision > File
svFileSrc="${gLibGitFileName}"
svDst="/etc/profile.d"
mx-copy-sudo ${svFileSrc} ${svDst}

svFileSrc="${gLibGitEnvFileName}"
svDst="/etc/profile.d"
mx-copy-sudo ${svFileSrc} ${svDst}

## Provision > File
svFileSrc="${gAliasGlobalFileName01}"
svFileDst="/etc/profile.d/${gAliasGlobalFileName02}"
mx-copy-sudo ${svFileSrc} ${svFileDst}

# Provision > User > If NotExists
id -u ${gOsUser}  &> /dev/null || {
  mx-user-create ${gOsUser}
  mx-user-keypub-add ${gOsUser} /tmp/${gSshKeyPubOvhFileName}
  mx-user-group-add ${gOsUser} "wheel"
}

## Provision > File
svFileSrc="${gSshKeyPrivGithubFileName}"
svDst="/home/${gOsUser}/.ssh/"
mx-copy-sudo ${svFileSrc} ${svDst}
sudo chmod 600 /home/${gOsUser}/.ssh/${gSshKeyPrivGithubFileName}
sudo chown -R ${gOsUser}:${gOsUser} /home/${gOsUser}/

## Clean > Folder : /tmp
sudo rm -rf /tmp/*.sh /tmp/sshk* /tmp/ssh_config
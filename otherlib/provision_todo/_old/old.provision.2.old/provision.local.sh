#!/bin/bash

# Define > Var.Script
sFolderThisFile=$(dirname $BASH_SOURCE)
siVmName=${1}

# Dependency 01
. $(dirname $BASH_SOURCE)/provision.env.sh
# Dependency 02
lLibFileName="copy.lib.sh"
mx-git-file-get code main lib/bash/${lLibFileName} /tmp
. /tmp/${lLibFileName}

# Dependency.USed
## ${lLibFileName} > mx-copy-remote

# Check > Arg
[ -z ${siVmName} ]  && {
    echo -e  "Mx > Missing > Script:Input > Vm:Name"
    exit
}




# Process > File
## Provision > File > from > local > to > Destination
while IFS= read -r line
do
  #echo "Process > ${line}"
  IFS='@' read -r lFileSrc lRemoteFolderTmpDst lRemoteFolderDst < <(echo "${line}")
  # Check > ${  # Check > ${lFileSrc} > is > Defined} > is > Defined
  [ ! -z ${lRemoteFolderDst} ] && {
      # echo -e "Copy.Local > file > ${lFileSrc} > to > ${siVmName} : ${lRemoteFolderTmpDst} then to ${siVmName} : ${lRemoteFolderDst}"
      mx-copy-remote ${lFileSrc//[[:space:]]/} ${siVmName}
      # mx-git-file-get  "${lRepo//[[:space:]]/}" "${lBranch//[[:space:]]/}" "${lFileSrc//[[:space:]]/}" "${lDst//[[:space:]]/}"
  }
  IFS=  
done < "${sFolderThisFile}/${gListLocalFile}"

exit


# Play Script on Remote
#ssh ${siVmName} "/tmp/${gCodeFileName}"










## Proviion > File > Code
#svFile="${sFolderThisFile}/${gCodeFileName}" && mx-copy-remote ${svFile} ${siVmName}

## Proviion > File > Code: Env
#svFile="${sFolderThisFile}/${gCodeEnvFileName}" && mx-copy-remote ${svFile} ${siVmName}

## Proviion > File > Key.Pub:ovh
#svFile="${gSshKeyPubOvhFolderLocal}/${gSshKeyPubOvhFileName}" && mx-copy-remote ${svFile} ${siVmName}

## Provision > File > Key.Pub: github.perso
#svFile="${gSshKeyPrivGithubFolderLocal}/${gSshKeyPrivGithubFileName}" && mx-copy-remote ${svFile} ${siVmName}

## Provision > File > Ssh:ssh_config
#svFile="${gSshConfigFolderLocal}/${gSshConfigFileName}" && mx-copy-remote ${svFile} ${siVmName}

## Provision > File > Alias.Global
#svFile="${gAliasGlobalFolderLocal}/${gAliasGlobalFileName01}" && mx-copy-remote ${svFile} ${siVmName}

## Provision > File > Lib.Git
#svFile="${gLibGitFolderLocal}/${gLibGitFileName}"    && mx-copy-remote ${svFile} ${siVmName}
#svFile="${gLibGitFolderLocal}/${gLibGitEnvFileName}" && mx-copy-remote ${svFile} ${siVmName}

## Provision > File > Lib.Linux
#svFile="${gLibLinuxFolderLocal}/${gLibLinuxFileName}"    && mx-copy-remote ${svFile} ${siVmName}



#sAction="Mx > Provision > Var > for > Local"; echo "${sAction}"
## Download > dependency > from > Github in /tmp and source it
## Source   > dependency
#mx-git-file-get code main lib/bash/linux.lib.sh /tmp
#. /tmp/linux.lib.sh
## Method > mx-copy-remote > From > linux.lib.sh



# # Method.Local > Copy.Remote > File.Local > to > Vm:/tmp/
# mx-copy-remote() {
#   # File.Src
#   lvFileSrcPath=${1}   
#   # Folder.Dst
#   lvFolderDst=${siVmName}:/tmp/

#   svAction="Mx > Copy.Remote > File : ${lvFileSrcPath} to ${lvFolderDst}"; echo "${svAction}"
#   [ -f ${lvFileSrcPath}  ] && {
#     # q = quiet / --delete
#     rsync -aqv --delete ${lvFileSrcPath}  ${lvFolderDst} 
#   } || { echo "> File : ${lvFileSrcPath} > Missing"; return; }
# }

# Check > File > exists
[ -f ${sgiLibFilePathSrc} ] || { echo -e  "MxError > [Not > Exists] > File.Lib: ${sgiLibFilePathSrc}"; exit; }
# Check > Which > User (Current or Another)
[ -z ${2} ] && { echo -e  "MxWarning > [Missing] > Method:Input > User:Name (implies default user: ${sUserSsh})"; }

sInfo="Provision > ListFolder > [if > NotExists]     > ${siVmName}:${sFolderLocation}/{${sSequenceFolderName01}}"; echo -e "${sInfo}"





# Step01
for tItemFolderName in ${sSequenceFolderName01}
do
  # Step01
  sInfo="Provision > Folder > [if > NotExists]     > ${siVmName}:${sLibFolderDst}"; echo -e "${sInfo}"
  sAction="ssh ${siVmName} mkdir -p ${sLibFolderDst}"
  #echo -e "Cli > ${sAction}" 
  ${sAction}

sAction="ssh ${siVmName} sudo chmod -R 700 ${sLibFolderDst}/.."
echo -e "Cli > ${sAction}" 
${sAction}

  sAction="ssh ${siVmName} mx-user-folder-create ${siOsUserName} ${tItemFolderName}"
  sAction="ssh ${siVmName} mx-user-folder-create ${siOsUserName} ${tItemFolderName}"
  #echo -e "Cli > ${sAction}"  
  ${sAction}
done

# sAction="ssh ${siVmName} mx-user-folder-create -p ${sLibFolderDst}"
# echo -e "Cli > ${sAction}" 
# #eval ${sAction}


exit

sInfo="Provision > ListFolder > [if > NotExists]     > ${siVmName}:${sFolderLocation}/{${sSequenceFolderName02}}"; echo -e "${sInfo}"
## Step02
## Step01
# for tItemFolderName in ${sSequenceFolderName01}
# do
#   mx-user-folder-create ${siUserName} ${tItemFolderName}
# done

sAction="ssh ${siVmName} sudo chown -R ${siOsUserName}:${siOsUserName} /home/${siOsUserName}"
echo -e "Cli > ${sAction}" 
#eval ${sAction}



exit

## Folder > to > Provision
sSequenceFolderName01=".ssh mx"
sSequenceFolderName02="mx/lib mx/git mx/var mx/sshkey .ssh/sshkeypriv"

# Step01 > Loop > on > ListFolder01
for tItemFolderName in ${sSequenceFolderName01}
do
  mx-user-folder-create ${siUserName} ${tItemFolderName}
done

# Step02 > Loop > on > ListFolder02
for tItemFolderName in ${sSequenceFolderName02}
do
  mx-user-folder-create ${siUserName} ${tItemFolderName}
done







# sSequenceFolderName01=".ssh mx"
# sSequenceFolderName02="mx/lib mx/git mx/var mx/sshkey .ssh/sshkeypriv"
# sFolderLocation="/home/${siOsUserName}"



# # Section.Debug
# echo -e "\n## Section.Debug:Begin ##"
# echo -e "<siVmName>        = ${1}"
# echo -e "<siOsUserName>    = ${siOsUserName}"
# echo -e "<sFolderLocation> = ${sFolderLocation}"
# echo -e "## Section.Debug:End ##\n"









#!/bin/bash

# Section.Description > Provision > User:Home:Lib

# Define > Var
## File.This
sThisFilePath=$0
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## User.Current
sUserSsh=$(id -nu)
## Input > Mandatory
siLibName=${1}
## Input > Optional
siUserName=${2:-$sUserSsh}
## File > To > Provision
siLibFileName=${siLibName}.lib.sh
siLibFileFolderRoot="/home/${siUserName}"
siLibFileFolder="${siLibFileFolderRoot}/mx/lib"
siLibFilePath=${siLibFileFolder}/${siLibFileName}
## Other
sFolderPath="/home/${siUserName}"

lInfo="Provision > User:Folder:${siLibFileFolder} > with > File: ${siLibFileName}"; echo "${lInfo}"

# Check
## Input > is > provided
[ -z ${siLibName} ] && { echo -e  "Mx > Missing > Script:Input > Lib:Name"; exit; }
## User > Exists
id -u ${siUserName}  &> /dev/null || { echo "MxError > User:${siUserName} > Not Exists"; exit; }
## File > Exists
[ -f /tmp/${siLibFileName} ] || { echo -e  "MxError > [Not > Exists] > File: ${siLibFilePath}"; exit; }


## Step01
sInfo="Copy > File : ${siLibFileName} > to > ${siLibFileFolder}"; echo -e ${sInfo}

sAction="sudo cp ${sThisFileFolder}/${siLibFileName} ${siLibFileFolder}"
#echo -e "${sAction}" 
${sAction}

sAction="sudo chown -R ${siUserName}:${siUserName} ${siLibFileFolderRoot}"
#echo -e "${sAction}" 
${sAction}


## Step02
sAction="Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/${sThisFileName}
rm -rf /tmp/${siLibFileName}


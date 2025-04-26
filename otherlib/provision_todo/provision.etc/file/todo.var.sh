#!/bin/bash

# Section.Description > Provision > Filename.Etc

# Section.Deppendency > none

# Section.Rule        > none

# Parse > Arg
while getopts ":v:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    v) siVmName=$OPTARG;;      ## Mandatory > Not > checked [Must > be > Checked > by > caller]
  esac
done

# Define > Var
## File > to > Provision
siFileName="var.env.sh"
siFileFolder="/etc/profile.d"
siFilePath="${siFileFolder}/${siFileName}"

# # Section.Debug
# echo -e "\n## Section.Debug:Begin ##"
# echo -e "<siVmName>          = ${siVmName}"
# echo -e "<siFileName>        = ${siFileName}"
# echo -e "<siUserOsUsed>      = ${siUserOsUsed}"
# echo -e "## Section.Debug:End ##\n"

# Display > Info
lInfo=" - Action\n   - Provision > Var.Env\n     - File   : ${siFileName}\n     - Folder : ${siFileFolder}"; echo -e "${lInfo}"

cat <<EOF | ssh ${siVmName} sudo tee ${siFilePath} >/dev/null
#!/bin/bash
# ${siFilePath}

# Naming > Folder:Name
export gUserFolderName="mx"

# Naming > Repo.Git:Name
export gGitRepoProvisionName="provision"
export gGitRepoCodeName="code"


# 
# Todo > Naming > Folder:Name
# export gUserSshFolderName=".ssh"
# export gUserVarFolderName="var"
# export gUserLibFolderName="lib"
# export gUserGitFolderName="git"
# export gUserSecretFolderName="secret"
# export gUserKeySshPrivFolderName="sshkeypriv"

# Todo > Naming > Folder:Location
# export gUserVarFolder="~/\${gUserMxFolderName}/\${gUserVarFolderName}"
# export gUserLibFolder="~/\${gUserMxFolderName}/\${gUserLibFolderName}"
# export gUserGitFolder="~/\${gUserMxFolderName}/\${gUserGitFolderName}"
# export gUserSecretFolder="~/${gUserSshFolderName}/\${gUserSecretFolderName}"
# export gUserKeySshPrivFolder="~/\${gUserSshFolderName}/\${gUserKeySshPrivFolderName}"

# Todo > Naming > File:Name
# export gUserShellRcFileName=".bashrc"
# export gUserGitConfFileName=".gitconfig"
# export gUserListKeyPubFileName="authorized_keys"
EOF

#!/bin/bash

# Section.Description > Provision > File > in > /etc

# Section.Deppendency > none

# Parse > Arg
while getopts ":m:n:t:w:a:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    a) siOtpId=$OPTARG;;          ## Mandatory > checked > by > caller
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## File > to > Provision
siFileName="var.env.sh"
siFileFolder="/etc/profile.d"
siFilePath="${siFileFolder}/${siFileName}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}][${siOtpId}]"

## Display > Info
printf "    - Do    %-48s > From Scratch\n" "${sDebugPath}"

# Action
cat <<EOF | ssh ${siVmName} sudo tee ${siFilePath} >/dev/null
#!/bin/bash
# ${siFilePath}

# Naming > File:Name
export gUserShellRcFilename=".bashrc"

# Naming > Folder:Name
export gUserFolderMxName="mx"
export gUserGitFolderName="git"
export gUserVarFolderName="var"
export gUserLibFolderName="lib"
export gUserSecretFolderName="secret"

# Naming > Repo.Git:Name
export gGitRepoProvisionName="provision"
export gGitRepoCodeName="code"
export gGitRepoDockerfileName="dockerfile"

# Folder:Location
export    gUserGitFolderRootPath="\${HOME}/\${gUserFolderMxName}/\${gUserGitFolderName}"
export        gUserVarFolderPath="\${HOME}/\${gUserFolderMxName}/\${gUserVarFolderName}"
export        gUserLibFolderPath="\${HOME}/\${gUserFolderMxName}/\${gUserLibFolderName}"
export         gUserSecretFolder="\${HOME}/\${gUserFolderMxName}/\${gUserSecretFolderName}"
export   gProvisionRepoCodeShell="\${gUserGitFolderRootPath}/\${gGitRepoProvisionName}/code/bash"
export gProvisionRepoCodeAnsible="\${gUserGitFolderRootPath}/\${gGitRepoProvisionName}/code/ansible"
export           gDockerfileRepo="\${gUserGitFolderRootPath}/\${gGitRepoDockerfileName}"
EOF

# Check > Action > File > exist
sAction="ssh ${siVmName} sudo ls ${siFilePath}"
sCheck="$(${sAction})"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPatho}" "${sCheck}"
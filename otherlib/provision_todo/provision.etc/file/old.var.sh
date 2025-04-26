#!/bin/bash

# Section.Description > Provision > Var.Env.Etc

# Section.Deppendency > none

# Parse > Arg
while getopts ":m:n:t:w:p:u:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;        ## Mandatory > checked > by > caller
    p) siOtpId=$OPTARG;;          ## Mandatory > checked > by > caller
    u) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
## File > to > Provision
siFileName="var.env.sh"
siFileFolder="/etc/profile.d"
siFilePath="${siFileFolder}/${siFileName}"

## Debug
sDebugPath="[${siOtpMetaType}][${siOtpType}][${siOtpWord}][${siOtpId}]"

# # Section.Debug
# cat << Content
# ## Section.Debug ##
# \${siVmName}         = ${siVmName}
# ## Section.Debug ##
# Content

# Display > Info
#echo -e "    - Action ${sDebugPath} > Provision > File : ${siFilePath}"

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

# Folder:Location
export gUserGitFolderRootPath="\${HOME}/\${gUserFolderMxName}/\${gUserGitFolderName}"
export gUserSecretFolder="\${HOME}/\${gUserFolderMxName}/\${gUserSecretFolderName}"
export gProvisionRepoCodeShell="\${gUserGitFolderRootPath}/\${gGitRepoProvisionName}/code/bash"
export gProvisionRepoCodeAnsible="\${gUserGitFolderRootPath}/\${gGitRepoProvisionName}/code/ansible"
EOF

# Check > Action [File > exist]
sAction="ssh ${siVmName} ls ${siFilePath}"
sCheck="$(${sAction})"
#echo -e "      - Check ${sDebugPath} > File Exists > ${sCheck}"
printf "    - Check %-48s > Exists > %s\n" "${sDebugPath}" "${sCheck}"

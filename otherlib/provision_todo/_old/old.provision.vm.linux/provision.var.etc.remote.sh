#!/bin/bash

# Section.Description > Provision > Var.Etc

# Define > Var
sThisFilePath=$0
sUserName="$(id -un)"
sFolderPath="/etc/profile.d"
sFileName="vm.var.sh"
sFilePath="${sFolderPath}/${sFileName}"

# Provision > File > ${gK8sRepoYumPathname} (Repo.Yum)
sAction="Mx > Provision > File > ${sFilePath}"; echo "${sAction}"
cat <<EOF | sudo tee ${sFilePath} >/dev/null
#!/bin/bash
#/etc/profile.d/vm.var.sh

# Naming > Var.Global
## FileName
gUserShellRcFileName=".bashrc"
gGitConfFileName=".gitconfig"
gUserListKeyPubFileName="authorized_keys"

## Naming > Folder:Name
gVarMxFolderName="mxvar"
gLibMxFolderName="mxlib"
gGitMxFolderName="mxgit"
gKeySshPrivFolderName="sshkeypriv"
EOF

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
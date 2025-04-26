#!/bin/bash

# Section.Description > Provision > Var.User

# Define > Var
sThisFilePath=$0
sUserSsh=$(id -nu)
siUserName=${1:-$sUserSsh}
sFolderPath="/home/${siUserName}"
sFileName="user.var.sh"
sVarFolderName="mxvar"
sFilePath="${sFolderPath}/${sVarFolderName}/${sFileName}"

# Provision > File > ${gK8sRepoYumPathname} (Repo.Yum)
sAction="Mx > Provision > File > ${sFilePath}"; echo "${sAction}"
cat <<EOF >> ${sFilePath} >/dev/null
#!/bin/bash
#/home/<User>/user.var.sh

# Var.Local
uUserName="$(id -un)"
s
EOF

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
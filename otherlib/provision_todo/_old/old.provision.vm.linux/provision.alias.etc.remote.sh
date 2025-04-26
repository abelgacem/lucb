#!/bin/bash

# Section.Description > Provision > Alias.Etc

# Define > Var
sThisFilePath=$0
sFileName="alias.lib.sh"
sFolderPath="/etc/profile.d"
sFilePath="${sFolderPath}/${sFileName}"

# Provision > File > ${gK8sRepoYumPathname} (Repo.Yum)
sAction="Mx > Provision > File > ${sFilePath}"; echo "${sAction}"
cat <<EOF | sudo tee ${sFilePath} >/dev/null
#!/bin/bash
#/etc/profile.d/alias.lib.sh

# Alias.Global
alias  h='history'
alias  li='ls -ial'
alias  lr='ls -lirt'
alias  ll='ls -ialh'
alias  psa='ps -ef'
EOF

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
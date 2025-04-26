#!/bin/bash

# Section.Description > Provision > User:Bashrc

# Define > Var
sThisFilePath=$0
sUserSsh=$(id -nu)
siUserName=${1:-$sUserSsh}
sFileName="authorized_keys"
sFolderPath="/home/${siUserName}"
sFilePath="${sFolderPath}/.ssh/${sFileName}"

# Provision > File > ${gK8sRepoYumPathname} (Repo.Yum)
sAction="Mx > Provision > File > ${sFilePath}"; echo "${sAction}"
cat <<EOF | sudo tee ${sFilePath} >/dev/null
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD4AuLaflhh0avoa3f319pcCq9QwWWhuxk/vu0YHb2tpkCOWwPm26HR/s7n7V9mN30EWhM2gfu/yqFvqKU6s4miTRablQelxcvU+JGKdSA7EJ7HhokvSWuf87PS5JgsPnkplf0K54jx4jRGLBKfCJeq+vsD/P0gTo9xZxH440QcTkPEZo9mVRtUVHAIWvk9hNddk5Pxw9q6LgkuU+m7s3xIxaVswA/jrJ4ixT120zvLQPmRblB6MQI9qwceDOOz3R9tedCfC3TMuxX8WHHIDE5DDswFbLZ/MSR47nIBFhLuFTJM6U7O78Rz2hu/nwFhrRpDaeWMpMoN3Rkawg7XuQtu4Q7KX+IFdtVK3/XIIpuIKqoRthBjxbNpQTl6jYJoiPnIPKL0RKZjt+Cerco3412Ff8kzZeDfQiIFzboFbncW8hNg+eX0GOJPd4nDIdjdKQKkBbs1zmdMqSaQjp19C4Gt8peuIKKSBZCXoA/uXJx3y72b3Hz/mY1dEPCKy8l/Ca7nY8en+XrDGv8FPVGXGIUPDgbN6YlLEA908WXUSgbp/a0o4CppMcaobxWD/KlJrKZQXKnkj/cfFXsNrHU6lmVs9ESl/lp04NinLCHjrXr5a5bQi7Lb4VEIfv2LBmJHFHu10a4YNlghuFomzSzOtS5VYGUa4hKQC+4ngWtlvhY4mQ== Max@MacAMax.local
EOF

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
#!/bin/bash

# Section.Description
## Provision > Prerequisite > for > User.Sudo > To > manage > Provisioning

# Dependency
. /usr/local/etc/git/provision/shell/_provision/provision.sh

# Define > Var
## Input > Mandatory
siVmName=${1}

# Check > input > is > provided
[ -z ${siVmName} ] && { echo -e  "Mx > Missing > Script:Input > Vm:Name"; exit; }

# Provision > File > ${gK8sConf01Pathname}
echo -e "Mx > Provision > File > ${gK8sConf01Pathname}"
cat <<EOF | sudo tee ${gK8sConf01Pathname} >/dev/null
${gKernelModule}
EOF

# Provision > File > ${gK8sConf02Pathname}
echo -e "Mx > Provision > File > ${gK8sConf02Pathname}"
cat <<EOF | sudo tee ${gK8sConf02Pathname} >/dev/null
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# Provision > File > ${gK8sRepoYumPathname} (Repo.Yum)
sAction="Mx > Provision > File > ${gK8sRepoYumPathname}"; echo "${sAction}"
cat <<EOF | sudo tee ${gK8sRepoYumPathname} >/dev/null
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF


# Provision & Configure > Module.Kernel > ${gK8sConf02Pathname}
echo -e "Mx > Provision > Module.Kernel, Kvpair.Kernel"
sudo systemctl restart systemd-modules-load  ## Load > Module.Kernel > from > File.conf
sudo sysctl --system                         ## Configure > Module.Kernel > from > File.conf

# CHECK > List > Module.Kernel : br_netfilter
echo -e "Mx > List > Module.Kernel : ${gKernelModule}"
sudo lsmod | grep ${gKernelModule}

# CHECK > List > Kernel.Kvpair : br_netfilter
echo -e "Mx > List > Kernel.Kvpair : ${gKernelModule}"
sudo sysctl -a --ignore 2>/dev/null | grep bridge | grep tables

# Provision > Package
sAction="Mx > Provision > Package.Basic"; echo "${sAction}"
sudo yum install ${gListPakageBasic} -q -y

# Provision > Package
sAction="Mx > Provision > Package.K8s"; echo "${sAction}"
#sudo yum install ${gListPakageK8s} -q -y --disableexcludes=kubernetes
sudo yum install ${gListPakageK8s} -q -y

# Provision > Same > "cgroup driver" > for > CR and Kubelet
Todo

# Disable > SELinux
echo -e "Mx > Disable > SELinux"
sudo setenforce 0   ## For the Session
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config ## Even After rebbol


# Enable & Start > Service
sudo systemctl enable --now kubelet

## Clean > /Tmp
mx-file-tmp-delete "${gCodeFileName}"
mx-file-tmp-delete "${gCodeEnvFileName}"
mx-file-tmp-delete "${gLibFileFileName}"





exit

# List > Module.Kernel : br_netfilter
echo -e "Mx > List > Module.Kernel : ${gKernelModule}"
sudo lsmod | grep ${gKernelModule}

# List > Kernel.Kvpair : br_netfilter
echo -e "Mx > List > Kernel.Kvpair : ${gKernelModule}"
sudo sysctl -a --ignore 2>/dev/null | grep bridge | grep tables

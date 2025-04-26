#!/bin/bash

# Section.Description > Provision > Kuberntes: Master

# Section.Deppendency
. $(dirname $BASH_SOURCE)/../../_provision/provision.sh

# Parse > Arg
while getopts ":m:n:t:w:a:b:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    m) siOtpMetaType=$OPTARG;;
    n) siVmName=$OPTARG;;
    t) siOtpType=$OPTARG;;
    w) siOtpWord=$OPTARG;;
    a) siOtpSType=$OPTARG;;
    b) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
# File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
# 
sHostName="ovh0${siVmName:1:1}-k8s-master"
## Map > id > To > Otp
## User
sUserOsSsh="$(ssh ${siVmName} id -nu)"
siUserOsUsed="${siUserOsProvided:-${sUserOsSsh}}"
##
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siUserOsProvided}"
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}]"
# Section.Debug
# cat << Content

#   ## Section.Debug > [${sThisFileName}] ##
#   \${siListArg}        = ${siListArg}
# Content


# Display > Info
printf "  - Action > Provision > %s : %s > Vm : %s > User : %s [Y/N]\n" "${siOtpWord}" "${siOtpSType}" "${siVmName}" "${siUserOsUsed}" 

{ read -n1 response && [ "$response" != "${response#[YyoO]}" ] || exit; }
# Common
#mx-provision vm.linux ${siVmName} package    centos.1         update
mx-provision vm.linux ${siVmName} package    centos.1         basic
mx-provision vm.linux ${siVmName} bootstrap  etchost.ovh
mx-provision vm.linux ${siVmName} bootstrap  user                              ${siUserOsUsed}
# Specific
mx-provision vm.linux ${siVmName} package    centos.1         k8s.basic
mx-provision vm.linux ${siVmName} package    centos.1         containerd
mx-provision vm.linux ${siVmName} etc        file             unit.service.containerd
mx-provision vm.linux ${siVmName} etc        file             selinux.off
mx-provision vm.linux ${siVmName} etc        file             k8s.mod.kernel
mx-provision vm.linux ${siVmName} etc        file             k8s.mod.kernel.kvp
mx-provision vm.linux ${siVmName} etc        check            swap
mx-provision vm.linux ${siVmName} etc        set              k8s.master.port.open
mx-provision vm.linux ${siVmName} etc        file             k8s.yum.kubeadm
mx-provision vm.linux ${siVmName} package    centos.1         k8s.kubelet
mx-provision vm.linux ${siVmName} package    centos.1         k8s.kubeadm
mx-provision vm.linux ${siVmName} etc        set              hostname           "${sHostName}"
mx-provision vm.linux ${siVmName} etc        set              etchost.update     "${siVmName::2}:${sHostName}"


# Todo
## Provision > kubectl > on > 1 > Vm


# Containerd => failed to load plugin io.containerd.snapshotter.v1.devmapper  error="devmapper not configured"
# Containerd => failed to load cni during init, please check CRI plugin status before setting up network for pods  error="cni config load failed: no network config found in /etc/cni/net.d: cni plugin not initialized: failed to load cni config"
# - /var/lib/containerd/io.containerd.snapshotter.v1.overlayfs
# - /var/run/containerd/containerd.sock
# Default > CNI = Calico
# -- kubeadm will add the [node-role.kubernetes.io/master:NoSchedule] taint to the master node. 
# -- This means your master node will never be scheduled to work
# -- Your worker nodes will do all the work
# -- Remove this param > kubectl taint nodes master key:NoSchedule-


# Allowing > Ip:Alias.String > for > Tool.Network > is Named > DNS Resolution
# DNS Resolution > can > be > made > with > /etc/hosts > if > no > Server.Dns > Exists
# Tool.Network > List > telnet
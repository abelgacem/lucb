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
    b) siVmMaster=$OPTARG;;       ## Mandatory
    c) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
## File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
sHostName="ovh0${siVmName:1:1}-k8s-worker"
## User
sUserOsSsh="$(ssh ${siVmName} id -nu)"
siUserOsUsed="${siUserOsProvided:-${sUserOsSsh}}"
##
siListArg="-m ${siOtpMetaType} -n ${siVmName} -t ${siOtpType} -w ${siOtpWord} -a ${siOtpSType} -b ${siUserOsProvided}"
## Section.Debug
sDebugPath="[${siOtpMetaType}:${siVmName}][${siOtpType}][${siOtpWord}]"

# Check > Arg > Is > Provided
[ -z ${siVmMaster} ] && { printf "    - Error %-48s > Missing > Master : Hostname.Ssh\n": "${sDebugPath}" ; exit; }

## Define > Var > Kubeadm init
siVmMasterUsed="${siVmMaster::2}m"
siVmWorkerUsed="${siVmName::2}m"
sMasterIp="$(ssh ${siVmMasterUsed} hostname -i)"
sInitToken="$(ssh ${siVmMasterUsed} kubeadm token list  | tail -1 | cut -d' ' -f1)"
sInitTokenDiscovery="$(ssh ${siVmMasterUsed} openssl x509 -in /etc/kubernetes/pki/ca.crt -pubkey -noout | openssl pkey -pubin -outform DER | openssl dgst -sha256 | cut -d' ' -f2)"
sAction="ssh ${siVmWorkerUsed} kubeadm join ${sMasterIp}:6443 --token ${sInitToken} --discovery-token-ca-cert-hash sha256:${sInitTokenDiscovery}"

# Section.Debug
cat << Content

  ## Section.Debug > [${sThisFileName}] ##
  \${siListArg}      = ${siListArg}
  \${sAction}        = ${sAction}
Content

# Display > Info
printf "  - Action > Provision > %s : %s > Vm : %s > User : %s > from > master > %s [Y/N]\n" "${siOtpWord}" "${siOtpSType}" "${siVmName}" "${siUserOsUsed}" "${siVmMaster}" 

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
#mx-provision vm.linux ${siVmName} etc        check            swap
mx-provision vm.linux ${siVmName} etc        set              k8s.worker.port.open
mx-provision vm.linux ${siVmName} etc        file             k8s.yum.kubeadm
mx-provision vm.linux ${siVmName} package    centos.1         k8s.kubelet
mx-provision vm.linux ${siVmName} package    centos.1         k8s.kubeadm
mx-provision vm.linux ${siVmName} etc        set              hostname          "${sHostName}"
mx-provision vm.linux ${siVmName} etc        set              etchost.update    "${siVmName::2}:${sHostName}"
mx-provision vm.linux ${siVmName} etc        set              etchost.update    "51.210.10.195:ovh01-k8s-master"

# Step > Add > Vm > To > Cluster
sAction="ssh ${sMaster} kubeadm join ${sMasterIp}:6443 --token ${sToken} --discovery-token-ca-cert-hash sha256:${sTokenDiscovery}"
#echo -e "      - Degub > Play > Cli > ${sAction}" 
${sAction}

### kubeadm-config” ConfigMap in the cluster’s “kube-system” namespace. 
### kubectl -n kube-system get cm kubeadm-config -o yaml [controlPlaneEndpoint]

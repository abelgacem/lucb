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
printf "  - Action > Provision > %s : %s > Vm : %s > User : %s [Y/N] \n" "${siOtpWord}" "${siOtpSType}" "${siVmName}" "${siUserOsUsed}" 
{ read -n1 response && [ "$response" != "${response#[YyoO]}" ] || exit; }


# Common
#mx-provision vm.linux ${siVmName} package    centos.1         update
mx-provision vm.linux ${siVmName} package    centos.1         basic
mx-provision vm.linux ${siVmName} bootstrap  user                               ${siUserOsUsed}
mx-provision vm.linux ${siVmName} bootstrap  etchost.ovh
# Specific
mx-provision vm.linux ${siVmName} etc        file             k8s.yum.kubeadm
mx-provision vm.linux ${siVmName} package    centos.1         k8s.kubectl
mx-provision vm.linux ${siVmName} user       folder           .kube              ${siUserOsUsed}
mx-provision vm.linux ${siVmName} user       file             k8s.conf.kctl      ${siUserOsUsed}
mx-provision vm.linux ${siVmName} user       file             alias.k8s.kctl     ${siUserOsUsed}
mx-provision vm.linux ${siVmName} user       file             bashrc             ${siUserOsUsed} # Source > Env = Make available > Var, alias, Method


# Then you can join any number of worker nodes by running the following on each as root:

# kubeadm join 51.77.213.243:6443 
#    --token vic6tz.t4gilse7v39y87v8
# 	 --discovery-token-ca-cert-hash sha256:0b87e53206f05a97d7cfb63d1a10a423d2182401fafc14561ee1d7dc82d10731




# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
### sudo chown $(id -u):$(id -g) $HOME/.kube/config
# export KUBECONFIG=/etc/kubernetes/admin.conf

# You should now deploy a pod network to the cluster.
# Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
#   https://kubernetes.io/docs/concepts/cluster-administration/addons/


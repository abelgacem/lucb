#!/bin/bash

# Section.Description  > Define > Var.Env

# List > Otp.Meta:Type > to > Provision
export gListOtpMeta="vm.linux vm.windows vm.mac"
# List > Otp.Type to > Provision
export gListOtpLinux="bootstrap package user etc other service"
export gListOtpWindows="dns network"
export gListOtpMac="user xxx"
# List > Otp.Meta:Name:Otp.Type to > Provision
export gListLinuxPackage="centos.1 centos.2 ubuntu.1"
#export gListLinuxUser="group delete create folder file key.pub key.priv lib alias var"
#export gListLinuxEtc="file sudo"
export gListLinuxOther="create.user"
export gListLinuxBootstrap="base plus kubeadm"

# List > Vm
export gListVmLinuxName="o1c o2c o3c"
#export gListVmMacName="local"
#export gListVmWindowsName="win01 win02 win03"

# Terminology
## Otp
### Acronym > Object To Provision
## MetaOtp
### Type00 > Vm, Container
### Type01 > Linux, Windows
### Type02 > VmwWare, Aws
## Otp
### Type   > Docker, 
### Ok:   Vm.Vmware, Container.Docker
### Todo: Vm.Vmware, Container.Docker

## OtpVm  > denote > 1 > vm
## OtpCo  > denote > 1 > Container
## OtpOxc > denote > 1 > vm/user.sdef > like o1c o2c o3c o1u o2u when just created with Ovh
## OtpOxm > denote > 1 > vm/user.udef > like o1m o2m o3m provisioned with user.o*c

## liOtpWord
## Denote The type of Otp to provision
## can be 
### 1 > Name > liOtpName   (e.g alias, var)
### 1 > Verb > liOtpAction (e.g create, update)


# List > Object.Meta.Name > to > Provision
#export gListOtpOxc="vm.linux vm.package"
#export gListOtpOxm="package lib ssh docker pdftk conf container update all test k8skubeadm"
#export gListOtpMeta="vm.linux vm.windows vm.mac container.alpine container.centos container.ubuntu container.Windows"

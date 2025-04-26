#!/bin/bash

# Section.Description
## Define          > Var.(Bash, Global)
## Repo       > of > Var.(Bash, Global)
## Repo:Var.(Bash, Global)


# Code.Script > to > call
export sCodeFileName="provision.local.sh"
export gCodeFolderPath="/usr/local/etc/git/provision/shell"

# ListOject to Provision according to Vm/User
export gListOtpOxc="user nop"
export gListOtpOxm="package lib ssh docker pdftk conf container update all test k8skubeadm"

# List > Vm
export gListVmName="o1c o1m o2c o3c o3m"


# Terminology
## Otp = Object to provision
## Oxc denote the vm/user o1c o2c o3c when just created
## Oxm denote the vm/user o1m o2m o3m when provisioned with user mxadmin/sudo

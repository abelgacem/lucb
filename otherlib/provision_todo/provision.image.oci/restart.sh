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

mx-vm-provision vm.linux ${siVmName} user folder mx
mx-vm-provision vm.linux ${siVmName} user folder mx/lib
mx-vm-provision vm.linux ${siVmName} user folder mx/var
mx-vm-provision vm.linux ${siVmName} user folder mx/git
mx-vm-provision vm.linux ${siVmName} user folder mx/secret
mx-vm-provision vm.linux ${siVmName} user folder mx/secret/keyssh
mx-vm-provision vm.linux ${siVmName} user folder .ssh/keysshpriv
mx-vm-provision vm.linux ${siVmName} user lib user
mx-vm-provision vm.linux ${siVmName} user lib git


# Prerequisit
# - User > is     > User.Sudo > on > Vm.Remote
# - User > is Not > user.Root > on > Vm.Remote


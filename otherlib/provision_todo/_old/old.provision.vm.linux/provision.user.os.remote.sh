#!/bin/bash

# Section.Description > Provision > User.Os

# Dependency
. ~/mxlib/user.lib.sh

# Define > Var
sThisFilePath=$0
siUserName=${1}

# Check > input.mandatory > is > Provided
[ -z ${siUserName} ]  && {
    echo -e  "Mx > Missing > Script:Input > User:Name"
    exit
}

mx-user-create        ${siUserName}

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
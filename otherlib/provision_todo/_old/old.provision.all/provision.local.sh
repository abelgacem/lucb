#!/bin/bash


# Define > Var.Script
sFolderThisFile=$(dirname $BASH_SOURCE)
siVmName=${1}

# Dependency 01
. $(dirname $BASH_SOURCE)/provision.env.sh


for tOpt in ${gListOtpOxm} 
do
  echo "Mx > Provision > Otp:${tOpt} > On Vm:${siVmName}"
  ${sFolderThisFile}/../provision.${tOpt}/${gScriptToCallFilename} ${siVmName}
done
#!/bin/bash

# Section.Description > Provision > Os:User:Home:File.Key.Priv > in > User:Home

# Section.Deppendency
. ~/mx/var/var.env.sh

# Parse > Arg
while getopts ":v:f:u:" Opt
do
  #echo "Mx > Find > Opt > $Opt"
  case $Opt in
    v) siVmName=$OPTARG;;         ## Mandatory > Not > checked [Must > be > Checked > by > caller]
    f) siFileName=$OPTARG;;    ## Mandatory > Not > checked [Must > be > Checked > by > caller]
    u) siUserOsProvided=$OPTARG;; ## Optional
  esac
done

# Define > Var
## User
sUserOsSsh=$(ssh ${siVmName} id -nu)
#sUserOsSsh="simulated-centos"
siUserOsUsed=${siUserOsProvided:-${sUserOsSsh}}
## File > to > Provision
#siFileName="bashrc"
siFileFolder="/home/${siUserOsUsed}"
siFilePath="${siFileFolder}/${siFileName}"

# # Section.Debug
# echo -e "\n## Section.Debug:Begin ##"
# echo -e "<siVmName>          = ${siVmName}"
# echo -e "<siFileName>        = ${siKeyPrivFileName}"
# echo -e "<sUserOsSsh>        = ${sUserOsSsh}"
# echo -e "<siUserOsProvided>  = ${siUserOsProvided}"
# echo -e "<siUserOsUsed>      = ${siUserOsUsed}"
# echo -e "## Section.Debug:End ##\n"

# # Check > File > exists
# [ -f ${siKeyPrivPathSrc} ] || { echo -e  "MxError > [Not > Exists] > File.Key.Priv: ${siKeyPrivPathSrc}"; exit; }

## Todo > Check > siUserOsUsed > exist > in > Vm > if > not > scUserOsDefault
## Todo > Check > siKeyPrivFolderSrc > exists

sInfo="Provision > File   > [Even > if > exists] > ${siVmName}:${siFilePath}"; echo -e "${sInfo}"
cat <<EOF | ssh ${siVmName} sudo tee ${siFilePath} >/dev/null
#!bin/
# /home/${siUserOsUsed}/${siFileName}

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific var, aliases, methods
#. /etc/profile.d/var.env.sh
#. ./${gUserVarFolder}/var.env.sh
#for file in ~/${gUserLibFolder}; do echo $file ; done
EOF



sAction="ssh ${siVmName} sudo chown -R ${siUserOsUsed}:${siUserOsUsed} /home/${siUserOsUsed}"
#echo -e "Debug > Cli > ${sAction}" 
${sAction}

#### Todo > Allow > to > provision > file > in
# - Folder.Default    : mx/lib
# - Folder.Provided   : Cli:Arg

#### Todo > Find > another > way > to > define
# - siKeyPrivPathSrc


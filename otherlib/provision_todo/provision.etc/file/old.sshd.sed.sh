#!/bin/bash

# Section.Description > Provision > Var.User

# Define > Var
## File.This
sThisFilePath=$0
sThisFileName=$(basename ${sThisFilePath})
## File > to > Provision
sFileName="sshd_config"
sFileFolder="/etc/ssh"
sFilePath="${sFileFolder}/${sFileName}"


## Step01 > Provision > File
sInfo="Provision > File : ${sFilePath} > with > Sed"; echo -e ${sInfo}
echo "Todo > Sed > Via > Ssh"
exit
sudo sed -ie 's/#ClientAliveInterval 0/ClientAliveInterval 30/'  ${sFilePath}
sudo sed -ie 's/#TCPKeepAlive yes/TCPKeepAlive yes/'             ${sFilePath}



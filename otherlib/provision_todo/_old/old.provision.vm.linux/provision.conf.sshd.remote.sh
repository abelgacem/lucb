#!/bin/bash

# Section.Description > Provision > Conf:Demon:Sshd

# Define > Var
sThisFilePath=$0
sFileName="sshd_config"
sFolderPath="/etc/ssh"
sFilePath="${sFolderPath}/${sFileName}"

sAction="Mx > Provision > Conf : File : ${sFilePath}"; echo -e "${sAction}"
sudo sed -ie 's/#ClientAliveInterval 0/ClientAliveInterval 30/'  ${sFilePath}
sudo sed -ie 's/#TCPKeepAlive yes/TCPKeepAlive yes/'             ${sFilePath}

sAction="Mx > Clean > Folder : /tmp\n"; echo -e "${sAction}"
rm -rf /tmp/$(basename ${sThisFilePath})
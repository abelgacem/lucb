#!/bin/bash

# Section.Description > Script.Bash > Configure > Tool : Docker

# Define > Var
## this
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})

##########################################
# Method                                ##
##########################################
alias mxt-provision-ssh-conf="mxt-ssh-conf-provision"
function mxt-ssh-conf-provision() {
  # Dependency
  # Define > Var
  lFileName="config.json"
  lFileFolder="${HOME}/.docker"
  lFilePath="${lFileFolder}/${lFileName}"
  ## For > Debug
  lDebugPath="${BASH_SOURCE} : ${FUNCNAME[0]}"
  # Info
  echo "Mx > Play   > Script : Method > ${lDebugPath}"
  echo "Mx > Action > Configure > Docker"
  # Check > user.current > is > User.NotRoot
  result="${EUID}"
  [ 0 -eq "${result}" ] && { echo "Error > User.Current > is > Root => Exit"; return; }
  # Check > user.current > is > User.Sudo
  result=$(sudo -n id &> /dev/null && echo "Yes" || echo "No")
  [ "No" == "${result}" ] && { echo "Error > User.Current > is > NotSudo => Exit"; return; } #|| { echo "Info > User > is > Sudo"; } 
  # Action
  mkdir -p ${lFileFolder}
  cat <<EOM > "${lFilePath}"
{
	"auths": {
		"https://index.docker.io/v1/": {
			"auth": "YWJlbGdhY2VtOm1heGxhZmFpdA=="
		}
  }
}  
EOM
chmod 600 ${lFilePath}
# Check.Post > File > Exists
lAction="ls ${lFilePath}"
lResult="$(${lAction})"
printf "Mx > Check.Post > File > Exists > ${lResult}\n"

}

##########################################
# Action                                ##
##########################################
mxt-ssh-conf-provision


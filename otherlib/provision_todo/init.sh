#!/bin/bash

# Section.Description > Define
# - 1 > Method.Bash.Completion
# - 1 > Method.Bash > [That uses completion] > to > Provision > Vm.Linux

# Dependency.Parent > NONE
# Dependency.Child
## - Folder   > Var > mx-provision:liCodeFolder
## - Filename > Var > mx-provision:liCodeFileName

# Define > Var
## File.This
sThisFilePath=${BASH_SOURCE}
sThisFileName=$(basename ${sThisFilePath})
sThisFileFolder=$(dirname ${sThisFilePath})
## Other
declare -A sOtp 

# Level 01
sListVm="o1c o2u local"

# Level 02
#sOtp['List']="tool conf os key var user service"
sListOtp="tool conf os key var user service"

# Level 03
## choice > conf
sCodeFolder="${sThisFileFolder}/provision.conf"
sListFile=$(ls ${sCodeFolder} | grep  "^pc." | sed -e 's/pc.//' -e 's/.sh$//')
sOtp['Type','conf']="${sListFile}"
## choice > key
sOtp['Type','key']="public private"
## choice > var
sCodeFolder="${sThisFileFolder}/provision.var"
sListFile=$(ls ${sCodeFolder} | grep  "^pv." | sed -e 's/pv.//' -e 's/.sh$//')
sOtp['Type','var']="${sListFile}"
## choice > os
sOtp['Type','os']="update"
## choice > service
## choice > tool
sOtp['Type','tool']="docker podman git basic"
## choice > user
sOtp['Type','user']="create delete folder"

# Level 04
## choice > key,private
sCodeFolder="${sThisFileFolder}/provision.key"
sListFile=$(ls ${sCodeFolder} | grep  "^pk.private" | sed -e 's/pk.private.//' -e 's/.sh$//')
sOtp['Type','key','private']="${sListFile}"
## choice > key,public
sCodeFolder="${sThisFileFolder}/provision.key"
sListFile=$(ls ${sCodeFolder} | grep  "^pk.public" | sed -e 's/pk.public.//' -e 's/.sh$//')
sOtp['Type','key','public']="${sListFile}"


############################################
######## Method.Completion > for > Method ##
############################################
function  _mx_provision_completion() {
  # Define > Var
  n="6"
  # Stop Completion when 5 (+2) Arg are provided
  [ "${#COMP_WORDS[@]}" = "${n}" ] && return
  
  # Level01
  lList=${sListVm}
  COMPREPLY=($(compgen -W "${lList}" "${COMP_WORDS[1]}"))
  
  # Level02
  [ "${#COMP_WORDS[@]}" = "$((n-3))" ]  && {
    lList=${sListOtp}
    COMPREPLY=($(compgen -W "${lList}" "${COMP_WORDS[2]}"))
  }

  # Level03
  [ "${#COMP_WORDS[@]}" = "$((n-2))" ]  && {
    choice=${COMP_WORDS[2]}
    lList=${sOtp['Type',${choice}]}
    COMPREPLY=($(compgen -W "${lList}" "${COMP_WORDS[3]}"))
  }
  
  # Level04
  [ "${#COMP_WORDS[@]}" = "$((n-1))" ]  && {
    choice1=${COMP_WORDS[2]}
    choice2=${COMP_WORDS[3]}
    lList=${sOtp['Type',${choice1},${choice2}]}
    COMPREPLY=($(compgen -W "${lList}" "${COMP_WORDS[4]}"))
  }
}
complete -F _mx_provision_completion mx-provision mxp

##########################################
######## Method > to > provision #########
##########################################
alias mxp='mx-provision'
mx-provision() {
  # Define > var
  ## File.This
  lThisFilePath=${BASH_SOURCE}
  lThisFileName=$(basename ${lThisFilePath})
  lThisFileFolder=$(dirname ${lThisFilePath})
  ## Other
  declare -A liArg
  liArg['Vm']=${1}       # Mandatory [Checked] - Vm to Provision
  liArg['Otp']=${2}      # Mandatory [Checked] - Objet to Provision
  liArg['Type']=${3}     # Mandatory [Checked] - Object:Type to Provision
  liArg['Param01']=${4}  # Optional  [Checked] by callee not caller
  liArg['Param02']=${5}  # Optional  [Checked] by callee not caller
  liArg['Param03']=${6}  # Optional  [Checked] by callee not caller
  liArg['Param04']=${7}  # Optional  [Checked] by callee not caller
  liArg['Param05']=${8}  # Optional  [Checked] by callee not caller
  liArg['Param06']=${9}  # Optional  [Checked] by callee not caller

  ## Debug
  lDebugPath="[${lThisFileName}]"
  
  # Check > First > 3 > Method:Arg > are > provided [If > not > display > help > and > Exit]
  Help="" && [ $# -le 2 ] && Help="-h"
  # Display > Help
  case $Help in
   -h|--help)     
     cat << Content
     Cli > Syntax  > ${FUNCNAME[0]} <SshName> <OtpName> <OtpType> [OtpSType] .. [OtpParam01] [OtpParam02] .. [OtpParamN]
     Cli > Example > ${FUNCNAME[0]} o1c tool ...
     Cli > Example > ${FUNCNAME[0]} o2u conf ...
     Cli > Info    > Completion > exists
     Cli > Alias   > mxp
     Cli > Action  > Provision > Vm.Linux > with > ObjecToProvision (e.g tool, conf, user, service, folder, ...)
Content
     return
    ;;
  esac

  # Define > Var
  ## Map > liArg[Otp] > to > Filepath > to > play
  liCodeFolder="${lThisFileFolder}/provision.${liArg['Otp']}"
  liCodeFileName="provision.sh"
  liCodeFilePath=${liCodeFolder}/${liCodeFileName}
  
  ## Provide > liArg[Vm, Other] > to > Script (define above)
  lListArg="-v ${liArg['Vm']} -o ${liArg['Otp']} -t ${liArg['Type']}"
  [ -z "${liArg['Param01']}" ] || lListArg="${lListArg} -a ${liArg['Param01']}"
  [ -z "${liArg['Param02']}" ] || lListArg="${lListArg} -b ${liArg['Param02']}"
  [ -z "${liArg['Param03']}" ] || lListArg="${lListArg} -c ${liArg['Param03']}"
  [ -z "${liArg['Param04']}" ] || lListArg="${lListArg} -d ${liArg['Param04']}"
  [ -z "${liArg['Param05']}" ] || lListArg="${lListArg} -e ${liArg['Param05']}"
  [ -z "${liArg['Param06']}" ] || lListArg="${lListArg} -f ${liArg['Param06']}"
  
# #Section.Debug
#   cat << Content
#   ## Section.Debug > [${lThisFileName}] ##
#   \${lListArg}       = ${lListArg}
# Content


  # Check > Folder.Local > Exists [if > Not > Exit]
  [ -d  "${liCodeFolder}" ] || { printf "    - Error %-48s > Not Exists > Folder : %s \n" "${lDebugPath}" "[${liCodeFolder}]" ; return; }
    
  # Check > File.Local.Code > Exists [if > Not > Exit]
  #[ -f "${liCodeFilePath}" ] || { printf "    - Error %-48s > Not Exists >  %s \n" "${lDebugPath}" "[${liVtp}][${liOtpType}][${liCodeFileName/.sh/}]" ; return; }
  
  # Action
  lAction="${liCodeFilePath} ${lListArg}"
  echo -e "Mx > Play > Cli > ${lAction}" 
  ${lAction}  
}










  # # Arg04:Otp:Name
  # case ${COMP_WORDS[3]} in
  #   # bootstrap)
  #   #   lgFolder="$(ls ${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]} | egrep -iv 'readme|old|_')"
  #   #   COMPREPLY=($(compgen -W "${lgFolder//.sh}" "${COMP_WORDS[4]}"))
  #   #   ;;
  #   package)
  #     COMPREPLY=($(compgen -W "${gListLinuxPackage}" "${COMP_WORDS[4]}"))
  #     ;;
  #   etc)
  #     lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}"
  #     lListFile=$(ls ${lgFolder} | grep -v "\.old" | grep -v "old\." | grep -v readme)
  #     COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[4]}"))
  #     ;;
  #   bootstrap)
  #     lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}"
  #     lListFile=$(ls ${lgFolder} | grep -v "\.old" | grep -v readme)
  #     COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[4]}"))
  #     ;;
  #   user)
  #     lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}"
  #     lListFile=$(ls ${lgFolder} | grep -v "\.old" | grep -v "old\." | grep -v todo | grep -v readme)
  #     COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[4]}"))
  #     ;;
  #   other)
  #     COMPREPLY=($(compgen -W "${gListLinuxOther}" "${COMP_WORDS[4]}"))
  #     ;;
  # esac       

  # # Arg05:Param01 [When exists]
  # case ${COMP_WORDS[4]} in
  #   centos.1)
  #     lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/centos.1"
  #     lListFile=$(ls ${lgFolder})
  #     #/usr/local/etc/git/provision/shell/provision.vm.linux.package/centos.1
  #     COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
  #     return
  #   ;;
  #   ubuntu.1)
  #     lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/ubuntu.1"
  #     lListFile=$(ls ${lgFolder})
  #     #/usr/local/etc/git/provision/shell/provision.vm.linux.package/ubuntu.1
  #     COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
  #     return
  #   ;;
  #   set)
  #     lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/set"
  #     lListFile=$(ls ${lgFolder} | grep -v todo | grep -v "\.old" | grep -v "old\."  )
  #     COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
  #     return
  #   ;;
  #   secret)
  #     lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/secret"
  #     lListFile=$(ls ${lgFolder})
  #     COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
  #     return
  #   ;;
  #   kubernetes)
  #     lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/kubernetes"
  #     lListFile=$(ls ${lgFolder} | grep -v todo | grep -v "\.old" | grep -v "old\."  )
  #     COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
  #     return
  #   ;;
  #   file)
  #     lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/file"
  #     lListFile=$(ls ${lgFolder} | grep -v todo | grep -v "\.old" | grep -v "old\." )
  #     COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
  #     return
  #   ;;
  #   repo.git)
  #     #lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/file"
  #     lListRepoOrg="personal sncf"
  #     COMPREPLY=($(compgen -W "${lListRepoOrg}" "${COMP_WORDS[5]}"))
  #     return
  #   ;;
  #   check)
  #     lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/check"
  #     lListFile=$(ls ${lgFolder} | grep -v "old\." )
  #     COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
  #     return
  #   ;;
  #   key.priv)
  #     lgFolder="${sgUserSecretFolder}/keyssh"
  #     lListFile=$(ls ${lgFolder} | grep key.ssh.priv)
  #     COMPREPLY=($(compgen -W "${lListFile//key.ssh.priv.}" "${COMP_WORDS[5]}"))
  #     return
  #   ;;
  #   key.pub)
  #     lgFolder="${sgUserSecretFolder}/keyssh"
  #     lListFile=$(ls ${lgFolder} | grep key.ssh.*pub)
  #     lListFile="${lListFile//key.ssh.}"
  #     lListFile="${lListFile//.pub}"
  #     COMPREPLY=($(compgen -W "${lListFile}" "${COMP_WORDS[5]}"))
  #     return
  #   ;;
  # esac    

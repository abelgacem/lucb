#!/bin/bash

# Section.Description > Define
# - 1 > Method.Bash.Completion
# - 1 > Method.Bash > [That uses completion] > to > Provision > Vm|Container 
#   - Mac
#   - Windows
#   - Linux

# Dependency
# . /etc/profile.d/var.env.sh > Dependency.Sdef
. $(dirname $BASH_SOURCE)/var.env.sh

##########################################################
######## Define > Var.local > from > Var.Env.(Etc|User) ##
##########################################################
sgUserGitFolderRootPath=${gUserGitFolderRootPath}
sgGitRepoProvisionName=${gGitRepoProvisionName}
sgUserSecretFolder=${gUserSecretFolder}
sgProvisionRepoCodeShell=${gProvisionRepoCodeShell}

############################################
######## Method.Completion > for > Method ##
############################################
_mx_provision_completion() {  
  # Stop Completion when 5 (+2) Arg are provided
  if [ "${#COMP_WORDS[@]}" = "7" ]; then
    return
  fi
  # Arg01:Otp.Meta:Type
  COMPREPLY=($(compgen -W "${gListOtpMeta}" "${COMP_WORDS[1]}"))
    
  # Arg02:Otp.Meta:Name
  case ${COMP_WORDS[1]} in
    *windows)
      COMPREPLY=($(compgen -W "${gListVmWindowsName}" "${COMP_WORDS[2]}"))
      ;;
    *linux)
      COMPREPLY=($(compgen -W "${gListVmLinuxName}" "${COMP_WORDS[2]}"))
      ;;
    *mac)
      COMPREPLY=($(compgen -W "${gListVmMacName}" "${COMP_WORDS[2]}"))
      ;;
  esac       

  # Arg03:Otp:Type
  [ "${#COMP_WORDS[@]}" = "4" ] &&  [ "${COMP_WORDS[1]}" = "vm.linux" ] && {
    COMPREPLY=($(compgen -W "${gListOtpLinux}" "${COMP_WORDS[3]}"))
  }

  [ "${#COMP_WORDS[@]}" = "4" ] &&  [ "${COMP_WORDS[1]}" = "vm.windows" ] && {
    COMPREPLY=($(compgen -W "${gListOtpWindows}" "${COMP_WORDS[3]}"))
  }

  [ "${#COMP_WORDS[@]}" = "4" ] &&  [ "${COMP_WORDS[1]}" = "vm.mac" ] && {
    COMPREPLY=($(compgen -W "${gListOtpMac}" "${COMP_WORDS[3]}"))
  }

  # Arg04:Otp:Name
  case ${COMP_WORDS[3]} in
    # bootstrap)
    #   lgFolder="$(ls ${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]} | egrep -iv 'readme|old|_')"
    #   COMPREPLY=($(compgen -W "${lgFolder//.sh}" "${COMP_WORDS[4]}"))
    #   ;;
    package)
      COMPREPLY=($(compgen -W "${gListLinuxPackage}" "${COMP_WORDS[4]}"))
      ;;
    etc)
      lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}"
      lListFile=$(ls ${lgFolder} | grep -v "\.old" | grep -v "old\." | grep -v readme)
      COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[4]}"))
      ;;
    bootstrap)
      lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}"
      lListFile=$(ls ${lgFolder} | grep -v "\.old" | grep -v readme)
      COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[4]}"))
      ;;
    user)
      lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}"
      lListFile=$(ls ${lgFolder} | grep -v "\.old" | grep -v "old\." | grep -v todo | grep -v readme)
      COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[4]}"))
      ;;
    other)
      COMPREPLY=($(compgen -W "${gListLinuxOther}" "${COMP_WORDS[4]}"))
      ;;
  esac       

  # Arg05:Param01 [When exists]
  case ${COMP_WORDS[4]} in
    centos.1)
      lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/centos.1"
      lListFile=$(ls ${lgFolder})
      #/usr/local/etc/git/provision/shell/provision.vm.linux.package/centos.1
      COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
      return
    ;;
    ubuntu.1)
      lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/ubuntu.1"
      lListFile=$(ls ${lgFolder})
      #/usr/local/etc/git/provision/shell/provision.vm.linux.package/ubuntu.1
      COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
      return
    ;;
    set)
      lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/set"
      lListFile=$(ls ${lgFolder} | grep -v todo | grep -v "\.old" | grep -v "old\."  )
      COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
      return
    ;;
    secret)
      lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/secret"
      lListFile=$(ls ${lgFolder})
      COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
      return
    ;;
    kubernetes)
      lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/kubernetes"
      lListFile=$(ls ${lgFolder} | grep -v todo | grep -v "\.old" | grep -v "old\."  )
      COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
      return
    ;;
    file)
      lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/file"
      lListFile=$(ls ${lgFolder} | grep -v todo | grep -v "\.old" | grep -v "old\." )
      COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
      return
    ;;
    repo.git)
      #lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/file"
      lListRepoOrg="personal sncf"
      COMPREPLY=($(compgen -W "${lListRepoOrg}" "${COMP_WORDS[5]}"))
      return
    ;;
    check)
      lgFolder="${sgProvisionRepoCodeShell}/provision.${COMP_WORDS[1]}.${COMP_WORDS[3]}/check"
      lListFile=$(ls ${lgFolder} | grep -v "old\." )
      COMPREPLY=($(compgen -W "${lListFile//.sh}" "${COMP_WORDS[5]}"))
      return
    ;;
    key.priv)
      lgFolder="${sgUserSecretFolder}/keyssh"
      lListFile=$(ls ${lgFolder} | grep key.ssh.priv)
      COMPREPLY=($(compgen -W "${lListFile//key.ssh.priv.}" "${COMP_WORDS[5]}"))
      return
    ;;
    key.pub)
      lgFolder="${sgUserSecretFolder}/keyssh"
      lListFile=$(ls ${lgFolder} | grep key.ssh.*pub)
      lListFile="${lListFile//key.ssh.}"
      lListFile="${lListFile//.pub}"
      COMPREPLY=($(compgen -W "${lListFile}" "${COMP_WORDS[5]}"))
      return
    ;;
  esac    
}
complete -F _mx_provision_completion mx-provision mxp

# #########################################################
# ######## Method.Completion > for > Method:Alias #########
# #########################################################

# _mpl() {
#   # Stop Completion when 2 (+2) Arg are provided
#   if [ "${#COMP_WORDS[@]}" = "4" ]; then
#     return
#   fi
#   # Arg01:Completion > Choice > for > Otp:Type
#   COMPREPLY=($(compgen -W "${gListOtpLinux}" "${COMP_WORDS[1]}"))

#   # Arg02:Completion > Otp.Name
#   case ${COMP_WORDS[1]} in
#     bootstrap)
#       COMPREPLY=($(compgen -W "${gListLinuxBootstrap}" "${COMP_WORDS[2]}"))
#       ;;
#     package)
#       COMPREPLY=($(compgen -W "${gListLinuxPackage}" "${COMP_WORDS[2]}"))
#       ;;
#     etc)
#       COMPREPLY=($(compgen -W "${gListLinuxEtc}" "${COMP_WORDS[2]}"))
#       ;;
#     user)
#       COMPREPLY=($(compgen -W "${gListLinuxUser}" "${COMP_WORDS[2]}"))
#       ;;
#     other)
#       COMPREPLY=($(compgen -W "${gListLinuxOther}" "${COMP_WORDS[2]}"))
#       ;;
#   esac       
# }
# #complete -F _mx_mvpl mpo

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
  liOtpMetaType=${1}  # Mandatory [Checked]
  liOtpMetaName=${2}  # Mandatory [Checked]
  liOtpType=${3}      # Mandatory [Checked]
  liOtpWord=${4}      # Mandatory [Checked]   > Can > be > Name|Verb > that is why the var is named liOtpWord and not liOtpName like liOtpMetaName
  liParam01=${5}        # Mandatory [Checked]
  liParam02=${6}      # Optional  [NotChecked > Here]
  liParam03=${7}      # Optional  [NotChecked > Here]
  liParam04=${8}      # Optional  [NotChecked > Here]
  liParam05=${9}      # Optional  [NotChecked > Here]

  ## Debug
  lDebugPath="[${lThisFileName}]"

  # Check > First > 4 > Method:Arg > are > provided [If > not > display > help > and > Exit]
  Help="" && [ $# -le 3 ] && Help="-h"
  # Display > Help
  case $Help in
   -h|--help)     
     cat << Content
     Cli > Syntax  > ${FUNCNAME[0]} <OtpMetaType> <OtpMetaName> <OtpType> <OtpActionOrName>
     Cli > Example > ${FUNCNAME[0]} vm.linux   o1c ...
     Cli > Example > ${FUNCNAME[0]} vm.windows win01 ...
     Cli > Info    > Completion > exists
     Cli > Alias   > mp
     Cli > Action  > Provision > MetaObject (e.g Vm, container, Linux, Windows, Mac) > with > Object
Content
     return
    ;;
  esac

  # Define > Var
  ## Map > OtpXXX > to > Filepath > to > play
  liCodeFolder="${sgProvisionRepoCodeShell}/provision.${liOtpMetaType}.${liOtpType}"
  liCodeFileName="${liOtpWord}.sh"
  liCodeFilePath=${liCodeFolder}/${liCodeFileName}
  lListArg="-m ${liOtpMetaType} -n ${liOtpMetaName} -t ${liOtpType} -w ${liOtpWord}"
  [ -z "${liParam01}" ] || lListArg="${lListArg} -a ${liParam01}"
  [ -z "${liParam02}" ] || lListArg="${lListArg} -b ${liParam02}"
  [ -z "${liParam03}" ] || lListArg="${lListArg} -c ${liParam03}"
  [ -z "${liParam04}" ] || lListArg="${lListArg} -d ${liParam04}"
  [ -z "${liParam05}" ] || lListArg="${lListArg} -e ${liParam05}"

# #Section.Debug
#   cat << Content
  
#   ## Section.Debug > [${lThisFileName}] ##
#   \${lListArg}       = ${lListArg}
# Content

  # Check > Folder.Local > Exists [if > Not > Exit]
  [ -d  "${liCodeFolder}" ] || { printf "    - Error %-48s > Noto Exists > Folder/OtpType : %s \n" "${lDebugPath}" "[${liCodeFolder}]" ; return; }
    
  # Check > File.Local.Code > Exists [if > Not > Exit]
  [ -f "${liCodeFilePath}" ] || { printf "    - Error %-48s > Not Exists >  %s \n" "${lDebugPath}" "[${liOtpMetaType}][${liOtpType}][${liCodeFileName/.sh/}]" ; return; }
  
  # Action
  lAction="${liCodeFilePath} ${lListArg}"
  #echo -e "      - Degub > Play > Cli > ${lAction}" 
  ${lAction}  
}

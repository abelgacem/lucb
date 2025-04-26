#!/bin/bash

# Section.Description
## Define > 1 > Method.Bash > that
### Extend, wrap, call     > Script.Bash
### Allow > to > Provision > Vm
### Uses                   > Completion

# Dependency
 . $(dirname $BASH_SOURCE)/provision.env.sh

############################################
######## Completion > for > Method #########
############################################
_mx_vm_provision_completion() {
  # Define Var.local from Var.Global
  lgListOtpOxc=${gListOtpOxc}
  lgListOtpOxm=${gListOtpOxm}
  lgListVmName=${gListVmName}
  
  # Stop Completion when 2 (+2) Arg are provided
  if [ "${#COMP_WORDS[@]}" = "4" ]; then
    return
  fi
  COMPREPLY=($(compgen -W "${lgListVmName}" "${COMP_WORDS[1]}"))
  
  # Completion for Arg02
  case ${COMP_WORDS[1]} in
    o*c)
      COMPREPLY=($(compgen -W "${lgListOtpOxc}" "${COMP_WORDS[2]}"))
      ;;
    o*m)
      COMPREPLY=($(compgen -W "${lgListOtpOxm}" "${COMP_WORDS[2]}"))
      ;;
  esac
}
complete -F _mx_vm_provision_completion mx-vm-provision


############################################
######## Definition > of > Method ##########
############################################
mx-vm-provision() {
  # Define Var
  sCodeFolderRoot=${gCodeFolderPath}

  # Check Arg:Nbr - $# Denote > Arg:Number
  case $# in
   0|1 )     
       echo -e "\n"
       echo -e "Mx > Syntax  > ${FUNCNAME[0]} <VmName> <Object>"
       echo -e "Mx > Syntax  > Example > ${FUNCNAME[0]} o1c user"
       echo -e "Mx > Syntax  > Example > ${FUNCNAME[0]} o1m docker"
    echo -e "Mx > Action  > Provision > Vm"
    echo -e "\n"
    return
    ;;
   2 ) 
     liVmName=${1}
     liOtp=${2}
      ;;
  esac
  # echo -e "<liVmName> = ${liVmName}"
  # echo -e "<liOtp> = ${liOtp}"
  echo -e "Mx > Provision > Vm : ${liVmName} > with > Object : ${liOtp}"
  # Check > Folder > exist
  [ -f ${sCodeFolderRoot}/provision.${liOtp}/${sCodeFileName} ] || {
    echo "Mx > Otp:${liOtp} > Is > Unknow ... Folder : ${sCodeFolderRoot}/provision.${liOtp}/${sCodeFileName} > not > exists"
    return
  }
  # Do Action
  lvAction="${sCodeFolderRoot}/provision.${liOtp}/${sCodeFileName} ${liVmName}"
  echo -e "Mx > Play      > Script.Bash :  ${lvAction}"
  #${lvAction}

}

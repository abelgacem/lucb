# shortcut
luc_install_ruby() { luc_ruby_install "$@"; }

# purpose install tool
# args: NONE
luc_ruby_install() {
  # define var
  local lPACKAGE_OS_TO_INSTALL=''
  local lOS_DETECTED="$(luc_core_os_name_get)"
  local lKEY="luc_EV_RUBY_PACKAGE_$(echo ${lOS_DETECTED} | tr '[:lower:]' '[:upper:]')"

  [ ! "alpine" == "${lOS_DETECTED}" ] && lPACKAGE_OS_TO_INSTALL=${!lKEY} || eval lPACKAGE_OS_TO_INSTALL=\$$lKEY

  # info
  luc_core_echo "purp" "$(luc_core_method_name_get) > install ruby"
  luc_core_echo "debu" "lOS_DETECTED=$lOS_DETECTED"
  luc_core_echo "debu" "lPACKAGE_OS_TO_INSTALL=$lPACKAGE_OS_TO_INSTALL"

  # installorexit OS PACKAGES
  luc_core_echo "step" "provision os packages"
  lECHOVAL=$(luc_core_os_package_provision ${lPACKAGE_OS_TO_INSTALL}); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 
  luc_core_echo "info" "done"
    
  # do
  return 0
}

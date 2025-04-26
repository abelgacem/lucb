# purpose: get info on os:alpine package
# note: helper method - not to be used directly
# args:    <PACKAGE>
luc_core_os_alpine_pm_package_info() {
  luc_core_echo "deb" "get OS Package info on $@"
}
# purpose: get info on os:rocky package
# note: helper method - not to be used directly
# args:    <PACKAGE01> <PACKAGE02> ...
luc_core_os_rocky_pm_package_info() {
  local lPACKAGE_LIST="$@"
  luc_core_echo "purp" "get OS Package info on ${lPACKAGE_LIST}"

  luc_core_echo "info" "info"
  dnf list ${lPACKAGE_LIST} --showduplicates
  luc_core_echo "info" "history"
  dnf history


}
# purpose: get info on os:ubuntu package
# note: helper method - not to be used directly
# args:    <PACKAGE01> <PACKAGE02> ...
luc_core_os_ubuntu_pm_package_info() {
  local lPACKAGE_LIST="$@"
  luc_core_echo "purp" "get OS Package info on ${lPACKAGE_LIST}"
  
  luc_core_echo "info" "show"
  APT_PAGER=cat apt  show "${lPACKAGE_LIST}"
  luc_core_echo "info" "policy"
  apt-cache policy  "${lPACKAGE_LIST}"
  luc_core_echo "info" "madison"
  apt-cache madison "${lPACKAGE_LIST}"
}
# purpose: get info on os package
# args:    <PACKAGE01> <PACKAGE02> ...
luc_core_os_pm_package_info() {
  local lPACKAGE_LIST="$@"
  local lDISTRO=$(luc_core_os_name_get)
  local lUSAGE_MSG="$(luc_core_method_name_get) <PACKAGE01> <PACKAGE02> ..."
  # luc_core_echo "purp" "get OS Package info"

  # checkorexit args are provided
  [ -z "$lPACKAGE_LIST" ] ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) jekyll" 
    return 1
  }

  # upgrade package
  case "$lDISTRO" in
    "alpine")          luc_core_os_alpine_pm_package_info "${lPACKAGE_LIST}" ;;
    "rocky"|"alma")    luc_core_os_rocky_pm_package_info "${lPACKAGE_LIST}" ;;
    "ubuntu"|"debian") luc_core_os_ubuntu_pm_package_info "${lPACKAGE_LIST}" ;;
    "mac")             luc_core_echo "caut" "Done nothing" && retun 0 ;;
    *) luc_core_echo "warn" "$(luc_core_method_name_get) : unknow distro: $lDISTRO."; return 1 ;;
  esac
}
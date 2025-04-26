# purpose generic info on tool
# args: NONE
luc_jekyll_info() {
  # define var
  local lCLI="jekyll"

  # checkorexit cli exists
  lECHOVAL=$(luc_core_check_cli_is_installed "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 
  
  # info
  luc_core_echo "info" "jekyll version   > $(jekyll -v)"
  luc_core_echo "info" "jekyll workspace    > luc_EV_JEKYLL_FOLDER_WKSPC=${luc_EV_JEKYLL_FOLDER_WKSPC}"
  luc_core_echo "info" "list of jekyll site"
  ls -l ${luc_EV_JEKYLL_FOLDER_WKSPC}
  # return
  return 0
}

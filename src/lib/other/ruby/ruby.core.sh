# purpose: display info on CLI ruby, gem and on gems installed 
# args: NONE
luc_ruby_info() {
  # define var
  local lCLI="ruby"

  # checkorexit cli exists
  lECHOVAL=$(luc_core_check_cli_is_installed "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 
  
  # info
  luc_core_echo "info" "$lCLI version" && ruby -v
  # info
  luc_core_echo "info" "gem version"     &&  gem -v
  # info
  luc_core_echo "info" "gem info"        &&  gem environment
  # done
  luc_core_echo "info" "list of installed gems" &&  gem list
  # done
  return 0
}

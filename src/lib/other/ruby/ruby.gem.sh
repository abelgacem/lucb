# purpose: display info on a ruby gem
# args: <GEMNAME>
luc_ruby_gem_info() {
  GEMNAME="$1"
  local lUSAGE_MSG="$(luc_core_method_name_get) <GEMNAME>"
  luc_core_echo "purp" "list infos on a installed gem"

  # checkorexit args are provided
  [ -z "$GEMNAME" ]       ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) jekyll bundler" 
    return 1
  }

  luc_core_echo "info" "location of gem: $GEMNAME"
  gem which "$GEMNAME"
  luc_core_echo "info" "other info"
  bundle info "$GEMNAME"
  luc_core_echo "info" "other info"
  gem info "$GEMNAME"
  luc_core_echo "info" "files installed"
  gem contents "$GEMNAME"
  luc_core_echo "info" "available versions"
  gem search $GEMNAME --remote --all | grep "^$GEMNAME "
  return 0
}

# purpose: install a ruby gem
# args:  <GEMNAME> [OPTIONS]
luc_ruby_gem_install() {
  GEMNAME="$1"
  local lCLI="gem"
  local lUSAGE_MSG="$(luc_core_method_name_get) <GEMNAME> [OPTIONS]"
  luc_core_echo "purp" "install a ruby gem"

  # checkorexit cli exists
  lECHOVAL=$(luc_core_check_cli_is_installed "$lCLI"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lCLI is not installed" && return 1 

  # checkorexit args are provided
  [ -z "$GEMNAME" ]       ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) jekyll (install in $(gem environment home))" 
    return 1
  }
  # get options
  shift 1; lOPTIONS="$@"
  # do
  luc_core_echo "info" "install gem : $GEMNAME"
  
  # install in $GEM_HOME (--no-user-install)
  gem install --no-user-install $lOPTIONS $GEMNAME 1> /dev/null 
  return 0   
}
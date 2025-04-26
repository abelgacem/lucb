# define var sLIB if folder name differs
lLIB="bats"
# define this var
lDESC="manage BATS by wraping BATS CLI"

# Checkorexit cli exists
CLI='git'; luc_core_check_cli_is_installed ${CLI} || { 
  luc_core_echo "caut" "library : $lLIB > ${CLI} is not installed." 
  return 1 
}   

# Checkorwarn cli exists
CLI='bats'; luc_core_check_cli_is_installed ${CLI} || { 
  luc_core_echo "caut" "library : $lLIB > ${CLI} is not installed BUT can be installed via LUC." 
}   

export luc_EV_BATS_GIT_URL_CORE="https://github.com/bats-core/bats-core.git"
export luc_EV_BATS_GIT_URL_SUPPORT="https://github.com/bats-core/bats-support.git"
export luc_EV_BATS_GIT_URL_ASSERT="https://github.com/bats-core/bats-assert.git"
export luc_EV_BATS_ROOT_INSTALL_FOLDER="/usr/local"

luc_core_echo "caut" "library : $lLIB  > some commands clone git repo."
luc_core_echo "caut" "library : $lLIB  > some commands need sudo."
return 0
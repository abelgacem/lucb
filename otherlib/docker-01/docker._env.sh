# purpose : define the pre-requisits
# - set environment variables for this project/lib
# - check prerequisit to use libraries

lLIB="docker";
# Check
CLI='docker';luc_core_check_cli_is_installed ${CLI} || { 
  luc_core_echo "warn" "library : $lLIB > not loaded > ${CLI} is not installed." 
  return 1 
}   

return 0
# define var sLIB if folder name differs
lLIB="nft"
# define this var
lDESC="manage ingoing and outgoing traffic"




# Check
CLI='nft';luc_core_check_cli_is_installed ${CLI} || { 
  luc_core_echo "warn" "library : $lLIB > not loaded > ${CLI} is not installed." 
  return 1 
}   

luc_core_echo "caut" "library : $lLIB > some commands need sudo." 

##### RETURN
return 0
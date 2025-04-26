# purpose : define the pre-requisits

# Check
lLIB="vm"

luc_core_echo "warn" "library : $lLIB > not loaded." && return 1 
luc_core_echo "info" "library : $lLIB > loaded."     && return 0

# purpose : manage nft object

# shortcuts
#
mmx_nft_object_list () { 
  luc_core_echo "info" "list all tables, chain, rules"
  luc_core_echo "info" "list tables"
  sudo nft list tables
  luc_core_echo "info" "list chains"
  sudo nft list chains
  luc_core_echo "info" "list rules"
  sudo nft list ruleset

}

# purpose: get all handle of a table
# required: $table-name
# optional: $table-type
# args: "$host" "$port" or "$port" ($host default to localhost)

mmx_nft_handle_list () {
  # check arg
  [ "$#" -eq 2 ] && {
    local TABLE_NAME=$1
    local TABLE_TYPE=$2
  }

  # check arg
  [ "$#" -eq 1 ] && {
    local TABLE_TYPE="inet"
    local TABLE_NAME=$1
  }

  # check arg
  [ "$#" -eq 0 ] || [ "$#" -gt 2 ] && {
    luc_core_echo "warn" "nft:bad number of arg"
    return 1
  }  

  local lTABLE_NAME="$1"
  local lTABLE_TYPE="$2" # default to inet if not provided
  [ -z $1 ] && luc_core_echo "warn" "nft: need a table name" && return 1
  luc_core_echo "info" "list handles of a table"
  sudo nft list table inet mxFirewall -a
}

mmx_nft_table_create () { 
  luc_core_echo "info" "create a nft table"
}
mmx_nft_table_delete () { 
  luc_core_echo "info" "delete a nft table"
}
mmx_nft_table_flush () { 
  luc_core_echo "info" "flush a nft table"
}
mmx_nft_table_delete_all () { 
  luc_core_echo "info" "delete all nft tables"
}
mmx_nft_chain_flush () { 
  luc_core_echo "info" "flush a nft chain in a table"
}
mmx_nft_file_play () { 
  luc_core_echo "info" "paly a nft file"
}

mmx_nft_object_flush () { 
  luc_core_echo "info" "flush all tables, chain, rules"
}


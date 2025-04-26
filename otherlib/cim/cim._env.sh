# define var
lLIB="cim"

# checkorexit cli exists
luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
[ ! -n "$lCIM_TOOL" ] && luc_core_echo "caut" "library : $lLIB > none of docker|buildah is installed" && return 1

# define envar
export luc_EV_CIM_LABEL_KEY_SHELL="mx.os.shell"
export luc_EV_CIM_LABEL_KEY_OSNAME="mx.os.name"


# deny or allow library loading
return 0
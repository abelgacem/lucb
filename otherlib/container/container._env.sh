# define var
lLIB="container"

# checkorexit cli exists
luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
[ ! -n "$lCIM_TOOL" ] && luc_core_echo "caut" "library : $lLIB > none of docker|buildah is installed" && return 1

# checkorexit var exists
[ -z "$luc_EV_CIMAGE_OS_USER_SUDO"  ] && luc_core_echo "caut" "library : $lLIB > luc_EV_CIMAGE_OS_USER_SUDO is not defined" && return 1

# define envar
##
export luc_EV_CONTAINER_LUC_SRC_RELPATH="${luc_EV_LUC_CORE_SETUP_RELPATH}"
export luc_EV_CONTAINER_BOOT_RELPATH="${luc_EV_LUC_CORE_BOOT_RELPATH}"
export luc_EV_CONTAINER_LUC_HOME="${luc_EV_LUC_CORE_HOME}"
export luc_EV_CONTAINER_OS_USER_SUDO="${luc_EV_CIMAGE_OS_USER_SUDO}"
export luc_EV_CONTAINER_PREFIX="mxc"



# deny or allow library loading
return 0
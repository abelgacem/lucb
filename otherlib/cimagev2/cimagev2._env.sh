# define var
lLIB="cimagev2"

# checkorexit cli exists
luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
[ ! -n "$lCIM_TOOL" ] && luc_core_echo "caut" "library : $lLIB > none of docker|buildah is installed" && return 1

# checkorexit var exists
[ -z "$luc_EV_CIM_LABEL_KEY_SHELL"  ] && luc_core_echo "caut" "library : $lLIB > luc_EV_CIMAGE_OS_USER_SUDO is not defined" && return 1
[ -z "$luc_EV_CIM_LABEL_KEY_OSNAME" ] && luc_core_echo "caut" "library : $lLIB > luc_EV_CIMAGE_OS_USER_SUDO is not defined" && return 1

# define envar
##
export luc_EV_CIMAGEV2_LUC_CORE_HOME=${luc_EV_LUC_CORE_HOME}
export luc_EV_CIMAGEV2_LUC_SRC_RELPATH=${luc_EV_LUC_CORE_BOOT_RELPATH}
export luc_EV_CIMAGE_OS_LIST=${luc_EV_LUC_CORE_OS_MANAGED}
##
export luc_EV_CIMAGEV2_OS_USER_SUDO='lisa' # linux sudo administrator
##
export luc_EV_CIMAGEV2_LABEL_KEY_SHELL=${luc_EV_CIM_LABEL_KEY_SHELL}
export luc_EV_CIMAGEV2_LABEL_KEY_OSNAME=${luc_EV_CIM_LABEL_KEY_OSNAME}
export luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_CURRENT="mx.image.current"
export luc_EV_CIMAGEV2_LABEL_KEY_SERVER_PORT="mx.port.jekyll"
export luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_00="mx.image.src.00"
export luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_01="mx.image.src.01"
export luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_02="mx.image.src.02"
export luc_EV_CIMAGEV2_LABEL_KEY_IMAGE_03="mx.image.src.03"
export luc_EV_CIMAGEV2_LABEL_VALUE_SERVER_PORT="4000"
##

# deny or allow library loading
return 0



# export luc_EV_CIMAGE_OS_USER_STD='lise'  # linux std user
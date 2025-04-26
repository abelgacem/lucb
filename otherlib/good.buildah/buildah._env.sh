# define var sLIB if folder name differs
lLIB="buildah"
# define this var
lDESC="manage container image by wraping buildah and podman CLI"


# CLI='buildah'; luc_core_check_cli_is_installed ${CLI} || { 
#   luc_core_echo "caut" "library : $lLIB > ${CLI} is not installed BUT can be installed via LUC." 
# }   

# checkorexit cli exists
lECHOVAL=$(luc_core_check_cli_is_installed buildah); lRETVAL=$?
[ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

# # define var
# export luc_EV_BUILDAH_LABEL_KEY_SHELL="mx.os.shell"
# export luc_EV_BUILDAH_LABEL_KEY_OSNAME="mx.os.name"
# export luc_EV_BUILDAH_LABEL_KEY_SERVER_PORT="mx.port.jekyll"
# export luc_EV_BUILDAH_LABEL_KEY_IMAGE_CURRENT="mx.image.current"
# export luc_EV_BUILDAH_LABEL_KEY_SERVER_PORT="mx.port.jekyll"
# export luc_EV_BUILDAH_LABEL_KEY_IMAGE_00="mx.image.src.00"
# export luc_EV_BUILDAH_LABEL_KEY_IMAGE_01="mx.image.src.01"
# export luc_EV_BUILDAH_LABEL_KEY_IMAGE_02="mx.image.src.02"
# export luc_EV_BUILDAH_LABEL_KEY_IMAGE_03="mx.image.src.03"
# export luc_EV_BUILDAH_LUC_SRC_RELPATH="$luc_EV_LUC_CORE_BOOT_RELPATH"
# export luc_EV_BUILDAH_LUC_CORE_HOME="$luc_EV_LUC_CORE_HOME"
# export luc_EV_BUILDAH_OS_USER_SUDO='lisa' # linux sudo administrator


return 0
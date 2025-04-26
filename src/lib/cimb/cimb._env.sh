# define var sLIB if folder name differs
lLIB="cimb"
# define this var
lDESC="manage container image by wraping buildah and podman CLI"

# checkorexit cli exists
lCLI='buildah';
lECHOVAL=$(luc_core_check_cli_is_installed $lCLI); lRETVAL=$?
[ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

# checkorexit cli exists
lCLI='podman';
lECHOVAL=$(luc_core_check_cli_is_installed $lCLI); lRETVAL=$?
[ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1


# define envar
export luc_EV_CIMB_LABEL_KEY_SHELL="mx.os.shell"
export luc_EV_CIMB_LABEL_KEY_OSNAME="mx.os.name"
export luc_EV_CIMB_LABEL_KEY_IMAGE_CURRENT="mx.image.current"
export luc_EV_CIMB_LABEL_KEY_IMAGE_00="mx.image.src.00"
export luc_EV_CIMB_LABEL_KEY_IMAGE_01="mx.image.src.01"
export luc_EV_CIMB_LABEL_KEY_IMAGE_02="mx.image.src.02"
export luc_EV_CIMB_LABEL_KEY_IMAGE_03="mx.image.src.03"
export luc_EV_CIMB_OS_USER_SUDO='lisa' # linux sudo administrator
export luc_EV_CIMB_LUC_CORE_HOME="$luc_EV_LUC_CORE_HOME"
export luc_EV_CIMB_LUC_SETUP_RELPATH="$luc_EV_LUC_CORE_BOOT_RELPATH"
export luc_EV_CIMB_CORE_OS_MANAGED="$luc_EV_LUC_CORE_OS_MANAGED"


export luc_EV_CIMB_IMAGE_ROOT_LIST="
    ubuntu:25.04
    rockylinux:9.3
    almalinux:9.5
    alpine:3.21
    gcr.io/kaniko-project/executor:v1.23.2
    registry:2.8.3      
"

# Other images
# - gcr.io/kaniko-project/executor      


return 0
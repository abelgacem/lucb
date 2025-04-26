# define var sLIB if folder name differs
lLIB="podman"
# define this var
lDESC="Manage container by wraping podman CLI"

# checkorexit cli exists
lECHOVAL=$(luc_core_check_cli_is_installed podman); lRETVAL=$?
[ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

export luc_EV_PODMAN_CLILOOP='tail -f /dev/null'
export luc_EV_PODMAN_LUC_SRC_RELPATH="$luc_EV_LUC_CORE_BOOT_RELPATH"
export luc_EV_PODMAN_LUC_CORE_HOME="$luc_EV_LUC_CORE_HOME"
export luc_EV_PODMAN_JEKYLL_WKSPC="/home/$luc_EV_BUILDAH_OS_USER_SUDO/wkspc/jekyll"

return 0
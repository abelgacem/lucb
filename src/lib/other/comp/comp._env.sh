# define var sLIB if folder name differs
lLIB="comp"
# define this var
lDESC="manage container by wraping podman and buildah CLI"

# checkorexit cli exists
lCLI='buildah';
lECHOVAL=$(luc_core_check_cli_is_installed $lCLI); lRETVAL=$?
[ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

# checkorexit cli exists
lCLI='podman';
lECHOVAL=$(luc_core_check_cli_is_installed $lCLI); lRETVAL=$?
[ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1

return 0
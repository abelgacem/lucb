# define var sLIB if folder name differs
# define this var
lDESC="Manage all needed CLIs options by wraping them"

# purpose : 
# - define the prerequisites to source the other Bash files
# - define environment variables

export luc_EV_LUC_CORE_HOME="$HOME/wkspc/git/luc-bash"
export luc_EV_LUC_CORE_FILE_RC="/etc/profile.d/luc.rc.sh"
export luc_EV_LUC_CORE_BOOT_RELPATH="src/setup/srclib"
export luc_EV_LUC_CORE_OS_MANAGED="alma|alpine|debian|rocky|ubuntu"
export luc_EV_LUC_CORE_GIT_URL="https://github.com/abelgacem/luc-bash.git"
export luc_EV_LUC_CORE_FOLDER_NAME="$(echo ${luc_EV_LUC_CORE_GIT_URL##*/}| tr -d '.git')"

return 0
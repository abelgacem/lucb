# getorexit this file path
lLIB_RELPATH='../lib'
luc_EV_LUC_CORE_OS_LINUX_LIST="alma|alpine|debian|rocky|ubuntu"
[  -f "/etc/os-release" ] && lDISTRO="$(grep -oiE "${luc_EV_LUC_CORE_OS_LINUX_LIST}" /etc/os-release | head -n 1 | tr '[:upper:]' '[:lower:]')" || lDISTRO="mac" 
case "$lDISTRO" in
  "alma"|"rocky"|"ubuntu"|"mac") lFOLDER_CUR="${BASH_SOURCE[0]}";;
  "alpine") [ -z "$1" ] && echo "need to duplicate the path as \$1 for alpine" &&  return 1 || lFOLDER_CUR="$1" ;;
  *) echo "unregistred distro: $lDISTRO"; return 1 ;;
esac

# do
lFOLDER_LIB="$(cd "$(dirname "$lFOLDER_CUR")/$lLIB_RELPATH" && pwd)"
lTHIS_FILE_FOLDER="$(dirname $lFOLDER_CUR)"

# load needed dependencies
. $lFOLDER_LIB/luc/luc.core.sh
. $lFOLDER_LIB/luc/luc._env.sh

# define var
lLUC_BOOTSRAP_FILE="${lTHIS_FILE_FOLDER}/srclib"
lFOLDER_LUC_HOME="${luc_EV_LUC_CORE_HOME}"
lFOLDER_LUC_LIB="${luc_EV_LUC_CORE_HOME}/lib"
lFOLDER_LUC_BIN="${luc_EV_LUC_CORE_HOME}/bin"
lFILE_PATH_RC_SDEF="$HOME/.bash_profile"
lFILE_PATH_RC_UDEF="$HOME/.profile.custom"

luc_core_echo "purp" "install luc in folder > ${lFOLDER_LUC_HOME}"

luc_core_echo "step" "create file if not exits ${lFILE_PATH_RC_UDEF}"
[ ! -f ${lFILE_PATH_RC_UDEF} ] && {
  touch ${lFILE_PATH_RC_UDEF}
  luc_core_echo "done"
} || {
  luc_core_echo "done" "already" 
}

luc_core_echo "step" "create file if not exits ${lFILE_PATH_RC_SDEF}"
[ ! -f ${lFILE_PATH_RC_UDEF} ] && {
  touch ${lFILE_PATH_RC_SDEF}
  luc_core_echo "done"
} || {
  luc_core_echo "done" "already" 
}

luc_core_echo "step" "create folder if not exits ${lFOLDER_LUC_BIN} and ${lFOLDER_LUC_LIB}"
[ ! -d ${lFOLDER_LUC_HOME} ] && {
  mkdir -p ${lFOLDER_LUC_BIN}
  mkdir -p ${lFOLDER_LUC_LIB}
  luc_core_echo "done"
} || {
  luc_core_echo "done" "already" 
}

# update sdef rc file, if not already done
luc_core_echo "step" "insert line into ${lFILE_PATH_RC_SDEF}"
[ -z "$(grep '^# mx: define a udef rcfile' ${lFILE_PATH_RC_SDEF})" ] && {
  echo "# mx: define a udef rcfile"   >> ${lFILE_PATH_RC_SDEF}
  echo "source ${lFILE_PATH_RC_UDEF}" >> ${lFILE_PATH_RC_SDEF}
  luc_core_echo "done"
} || {
  luc_core_echo "done" "already"
}

# define udef rc file content, if not already done
luc_core_echo "step" "insert line into ${lFILE_PATH_RC_UDEF}"
[ -z "$(grep '^# luc: luc is installed in' ${lFILE_PATH_RC_UDEF})" ] && {
  echo "# luc: luc is installed in folder ${lFOLDER_LUC_HOME}"                               >> ${lFILE_PATH_RC_UDEF}
  [ ":$PATH:" != *":${lFOLDER_LUC_BIN}:"* ] && echo "export PATH=${lFOLDER_LUC_BIN}:$PATH" >> ${lFILE_PATH_RC_UDEF}
  echo "alias setluc=\". srclib\""                                >> ${lFILE_PATH_RC_UDEF}
  echo setluc                                                     >> ${lFILE_PATH_RC_UDEF}
  luc_core_echo "done"
} || {
  luc_core_echo "done" "already"
}

exit 1

# install luc:bootstrap to destination 
luc_core_echo "step" "copy file to destination ${lFOLDER_LUC_BIN}"
cp ${lLUC_BOOTSRAP_FILE} ${lFOLDER_LUC_BIN}/
chmod +x ${lFOLDER_LUC_HOME}/bin/srclib
luc_core_echo "done"


# install luc:lib
## copy all files in source/ to dest/
## delete from dest files that are not in source
luc_core_echo "step" "copy files to destination ${lFOLDER_LUC_LIB}"
luc_core_check_cli_is_installed "rsync" && rsync -aq --delete ${lTHIS_FILE_FOLDER}/../lib/ ${lFOLDER_LUC_LIB}/ || {
  cp ${lTHIS_FILE_FOLDER}/../lib/luc.* ${lFOLDER_LUC_LIB}/
}
luc_core_echo "done"


# if ! grep -qo ":${lFOLDER_LUC_BIN}:" <<< ":$PATH:" ] || echo "export PATH=${lFOLDER_LUC_BIN}:$PATH" >> ${lFILE_PATH_RC_UDEF}
# rsync -av --delete ${lFILE_LUC_SRC_FOLDER}/ ${lFOLDER_LUC_LIB}/
  # "Alma"|"Rocky"|"Ubuntu"|"Mac"|"debian")             lTHIS_FILE_FOLDER="$(dirname ${BASH_SOURCE[0]})";;
  # "Alpine") [ -z "$1" ] || echo "not provided \$1" && lTHIS_FILE_FOLDER="$(dirname $1)" ;;

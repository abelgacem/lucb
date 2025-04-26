# purpose install tool
# args: NONE
luc_bats_core_install() {
  # define var
  local lTOOL_NAME="bats"
  local lBATS_ROOT_INSTALL_FOLDER="${luc_EV_BATS_ROOT_INSTALL_FOLDER}"
  local lBATS_GIT_URL="${luc_EV_BATS_GIT_URL_CORE}"
  # local lFOLDER_GIT_REPO_ROOT="/tmp"
  local lFOLDER_GIT_REPO_ROOT=" /Users/max/wkspc/git"
  local lFOLDER_BATS_NAME=$(basename "${lBATS_GIT_URL}" ".git")
  # info
  luc_core_echo "purp" "install $lTOOL_NAMEfrom git:${lBATS_GIT_URL} into folder ${lBATS_ROOT_INSTALL_FOLDER}/bin/${lFOLDER_BATS_NAME}"
  # do
  git -C /tmp/ clone ${lBATS_GIT_URL}
  sudo ${lFOLDER_GIT_REPO_ROOT}/${lFOLDER_BATS_NAME}/install.sh ${lBATS_ROOT_INSTALL_FOLDER}
  # info
  luc_core_echo "done"
}

# purpose uninstall tool
# args: NONE
luc_bats_core_uninstall() {
  # define var
  local lTOOL_NAME="bats"
  local lBATS_ROOT_INSTALL_FOLDER="${luc_EV_BATS_ROOT_INSTALL_FOLDER}"
  local lBATS_GIT_URL="${luc_EV_BATS_GIT_URL_CORE}"
  # local lFOLDER_GIT_REPO_ROOT="/tmp"
  local lFOLDER_GIT_REPO_ROOT=" /Users/max/wkspc/git"
  local lFOLDER_BATS_NAME=$(basename "${lBATS_GIT_URL}" ".git")
  # info
  luc_core_echo "purp" "uninstall $lTOOL_NAMEfrom ${lBATS_ROOT_INSTALL_FOLDER}/bin/${lFOLDER_BATS_NAME}"
  # do
  sudo ${lFOLDER_GIT_REPO_ROOT}/${lFOLDER_BATS_NAME}/uninstall.sh ${lBATS_ROOT_INSTALL_FOLDER}
  # info
  luc_core_echo "done"
}
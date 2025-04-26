# shortcut
luc_install_jekyll() { luc_jekyll_install "$@"; }

# purpose additional install specific to os:alpine
# args: NONE
luc_jekyll_alpine_install() {
  # local lRUBYGEM_VERSION="3.6.3"
  
  luc_core_echo "purp" "additional install for jekyll specific to alpine"
  # doas gem update --system $lRUBYGEM_VERSION
  
}

# purpose additional install specific to os:ubuntu
# args: NONE
luc_jekyll_ubuntu_install() {
  lBUNDLE_VERSION="bundle3.3"
  
  # info
  luc_core_echo "purp" "additional install for jekyll specific to ubuntu"

  # checkorexit this binary exists
  lPATH_BUNDLE="$(which ${lBUNDLE_VERSION})"; lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "${lBUNDLE_VERSION} is not installed" && return 1
  
  # checkorexit var exists
  [ -z "$GEM_HOME" ] && luc_core_echo "warn" "GEM_HOME is not defined" && return 2

  # define link
  lLINK_BUNDLE="$GEM_HOME/bin/bundle"
  luc_core_echo "info" "configure bundle for ubuntu > link ${lLINK_BUNDLE} to ${lPATH_BUNDLE}"
  [ ! -f "${lLINK_BUNDLE}" ] && ln -s ${lPATH_BUNDLE} ${lLINK_BUNDLE}
}

# purpose install tool
# args: NONE
luc_jekyll_install() {
  # define var
  local lCLI="jekyll"
  local lJEKYLL_WKSPC="$luc_EV_JEKYLL_FOLDER_WKSPC"
  local lGEM_TO_INSTALL=''
  local lDISTRO="$(luc_core_os_name_get)"
  local lKEY_GEM="luc_EV_JEKYLL_GEM_$(echo $lDISTRO | tr '[:lower:]' '[:upper:]')"
  [ ! "alpine" == "$lDISTRO" ] && lGEM_TO_INSTALL=${!lKEY_GEM} || eval lGEM_TO_INSTALL=\$$lKEY_GEM
  
  local lKEY_OSPACKAGE="luc_EV_JEKYLL_PACKAGE_$(echo $lDISTRO | tr '[:lower:]' '[:upper:]')"
  [ ! "alpine" == "$lDISTRO" ] && lPACKAGE_TO_INSTALL=${!lKEY_OSPACKAGE} || eval lPACKAGE_TO_INSTALL=\$${lKEY_OSPACKAGE}

  # info
  luc_core_echo "purp" "$(luc_core_method_name_get) > install $lCLI"
  luc_core_echo "info" "lOS_DETECTED        > $lDISTRO"
  luc_core_echo "info" "lPACKAGE_TO_INSTALL > $lPACKAGE_TO_INSTALL"
  luc_core_echo "info" "lGEM_TO_INSTALL     > $lGEM_TO_INSTALL"
  

  # installorexit OS PACKAGES
  luc_core_echo "step" "provision os packages"
  lECHOVAL=$(luc_core_os_package_provision ${lPACKAGE_TO_INSTALL}); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 
    
  # installorexit RUBY GEMS
  luc_core_echo "step" "provision ruby gems"
  lECHOVAL=$(luc_ruby_gem_install ${lGEM_TO_INSTALL}); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 2

  # installorexit additional OS/GEM packages
  case "$lDISTRO" in
    "alpine")          luc_jekyll_alpine_install ;;
    "ubuntu"|"debian") luc_jekyll_ubuntu_install ;;
    "alpine"|"rocky"|"alma") luc_core_echo "info" "nothing to do" && return 0 ;;
    "mac")             luc_core_echo "caut" "Done nothing" && retun 0 ;;
    *) luc_core_echo "warn" "$(luc_core_method_name_get) : unknow distro: $lDISTRO."; return 3 ;;
  esac

  # create root jekyll home 
  luc_core_echo "step" "create jekyll WORKSPACE: $lJEKYLL_WKSPC"
  mkdir -p "$lJEKYLL_WKSPC"

  # install jekyll gem dependencies 
  luc_core_echo "step" "create dummy site to install jekyll site std dependency"
  lECHOVAL=$(luc_jekyll_site_create --temp > /dev/null); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 3 

  # return
  return 0
}
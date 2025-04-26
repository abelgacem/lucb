# term: A topix is a jekyll site with a naming convention for the site (the folder name)
# purpose: manage topix > create, list, update.
# note: for serving and deploy topix, cf. server.

# purpose: list topix site that exists in a jekyll WORKSPACE
# note: helper function
# args: none
luc_jekyll_topix_list() {
  local lMSG_PURPOSE="list topix site that exists"
  local lMSG_USAGE="$(luc_core_method_name_get)"
  local lJEKYLL_WKSPC="$luc_EV_JEKYLL_FOLDER_WKSPC"
  local lTOPIX_PREFIX="$luc_EV_JEKYLL_SUFFIX_SITE"

  # checkorexit args are provided
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  
  # do not display :folder:suffix, folder:_xxxx, 
   ls $lJEKYLL_WKSPC | grep "$lTOPIX_PREFIX" | sed 's/-.*$//g' | grep -v "_.*"
}

# purpose: get a TOPIX:HOME from a TOPIX:NAME (no matter the folder exists)
# note: helper function
# args: <TOPIX_NAME>
luc_jekyll_topix_home_get() {
  local lMSG_PURPOSE="get TOPIX:HOME from TOPIX:NAME"
  local lMSG_USAGE="$(luc_core_method_name_get) <TOPIX_NAME>"
  local lMSG_EXAMPLE="$(luc_core_method_name_get) test" 
  local lTOPIX_NAME="$1"
  local lTOPIX_HOME="${luc_EV_JEKYLL_FOLDER_WKSPC}/${lTOPIX_NAME}-${luc_EV_JEKYLL_SUFFIX_SITE}/jksite"

  # checkorexit args are provided
  [ -z "$lTOPIX_NAME"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit ENVAR is set
  [ -z "$luc_EV_JEKYLL_FOLDER_WKSPC" ] ||
  [ -z "$luc_EV_JEKYLL_SUFFIX_SITE"  ] &&
  echo "ENVAR: luc_EV_JEKYLL_FOLDER_WKSPC or luc_EV_JEKYLL_SUFFIX_SITE is not defined" && return 2

  # return
  echo "$lTOPIX_HOME"
  return 0
  
}

# purpose: check a topix exits
# note: helper function
# return: 0 and topix:home if exists; else id and msg
# args: <TOPIX_NAME>
luc_jekyll_topix_check_exists() {
  local lMSG_PURPOSE="check a topix exits"
  local lMSG_USAGE="$(luc_core_method_name_get) <TOPIX_NAME>"
  local lMSG_EXAMPLE="$(luc_core_method_name_get) test" 
  local lTOPIX_NAME="$1"

  # checkorexit args are provided
  [ -z "$lTOPIX_NAME"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # getorexit topix HOME
  lECHOVAL=$(luc_jekyll_topix_home_get "${lTOPIX_NAME}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL." && return 2 || lTOPIX_HOME="$lECHOVAL"

  # checkorexit topix not exists
  lECHOVAL=$(luc_core_check_folder_exits "${lTOPIX_HOME}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL. Choose among" && luc_jekyll_topix_list && return 3

  # return
  echo "$lTOPIX_HOME"
  return 0
}

# purpose: create a topix
# args: <TOPIX_NAME>
luc_jekyll_topix_create() {
  local lMSG_PURPOSE="create a topix"
  local lMSG_USAGE="$(luc_core_method_name_get) <TOPIX_SITE_SNAME>"
  local lMSG_EXAMPLE="$(luc_core_method_name_get) myblog" 
  local lTOPIX_NAME="$1"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lTOPIX_NAME"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # getorexit topix HOME
  lECHOVAL=$(luc_jekyll_topix_home_get "${lTOPIX_NAME}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL." && return 2 || lTOPIX_HOME="$lECHOVAL"

  # checkorexit topix not exists
  lECHOVAL=$(luc_core_check_folder_exits "${lTOPIX_NAME}"); lRETVAL=$?
  [ 0 -eq "$lRETVAL" ] && luc_core_echo "warn" "folder already exists" && return 3

  # create topix
  luc_core_echo "info" "create topix : $lTOPIX_HOME"
  luc_jekyll_site_create "${lTOPIX_HOME}"
}

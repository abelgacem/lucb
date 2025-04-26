# shortcut
luc_jekyll_create_site() { luc_jekyll_site_create "$@"; }

# purpose: create a jekyll site
# note: helper frunction - does minimal check - do not use directly
# args: <JEKYLL_SITE_NAME>
luc_jekyll_site_create() {
  local lMSG_PURPOSE="create a jekyll site"
  local lMSG_USAGE="$(luc_core_method_name_get) <JEKYLL_SITE_NAME> | --temp"
  local lMSG_EXAMPLE="$(luc_core_method_name_get) myblog" 
  local lSITE_NAME="$1"

  # # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lSITE_NAME"     ] ||
  [ "--help" == "$1"      ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1
  [ "--temp" == "$1"      ] && lSITE_NAME="/tmp/jekyll-dummy"

  # createorexit site
  luc_core_echo "step" "create jekyll site: $lSITE_NAME" 
  jekyll new ${lSITE_NAME}

  # WORKAROUND: for google-protobuf
  luc_core_echo "todo" "WORKAROUND - uninstall unwanted platform specific gem : google-protobuf - " 
  echo "2" | gem uninstall google-protobuf --platform x86_64-linux -q -I > /dev/null 2>&1
  gem install --no-user-install google-protobuf 2>&1
  # chmod -R g+w ${lJEKYLL_SITE_HOME}
}


# purpose stop serving a jekyll site from source
# args: <JEKYLL_SITE_SNAME>
luc_jekyll_site_stop() {
  local lMSG_PURPOSE="stop serving a jekyll site"
  local lMSG_USAGE="$(luc_core_method_name_get) <JEKYLL_SITE_SNAME>"
  local lMSG_EXAMPLE="$(luc_core_method_name_get) myjekyllsite (SNAME)" 
  local lSITE_SNAME="$1"
  local lJEKYLL_WKSPC="$luc_EV_JEKYLL_FOLDER_WKSPC"
  local lJEKYLL_SITE_HOME="${lJEKYLL_WKSPC}/${lSITE_SNAME}-${luc_EV_JEKYLL_SUFFIX_SITE}"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lSITE_SNAME"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit site exists
  lECHOVAL=$(luc_core_check_folder_exits "${lJEKYLL_SITE_HOME}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lECHOVAL. Choose among" && luc_jekyll_site_list && return 2

  # do
  lPID=$(ps -ef | grep '{jekyll}' | grep -v grep | grep serve | awk '{print $1}')
  luc_core_echo "debu" "lJEKYLL_SITE_HOME=$lJEKYLL_SITE_HOME" 
  luc_core_echo "debu" "lPID=$lPID" 
  luc_core_echo "step" "stop serving the site from HOME" 
  kill -9 $lPID
}

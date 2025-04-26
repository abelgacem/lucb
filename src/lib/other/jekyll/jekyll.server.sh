# purpose: list topix served by an internal jekyll server for dev purpose
# args: none
luc_jekyll_server_list() {
  local lMSG_PURPOSE="list topix served by an internal jekyll server for dev purpose"
  local lMSG_USAGE="$(luc_core_method_name_get)"
  local lJEKYLL_WKSPC="$luc_EV_JEKYLL_FOLDER_WKSPC"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE"
  
  # checkorexit args are provided
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # get list of served topix
  lLIST_TOPIX=$(ps -ef | grep '{jekyll}' | grep -v grep | grep serve)
  [ -z "$lLIST_TOPIX" ] && luc_core_echo "caut" "no process found" && return 2

  # return 
  luc_core_echo "info" "list of topix that are served"
  echo "$lLIST_TOPIX"
  return 0
}

# purpose: start to serve a topix for dev purpose from HOME (not from build)
# args: <TOPIX_SNAME>
luc_jekyll_server_start() {
  local lMSG_PURPOSE="serve a topix for dev purpose from HOME (not from build)"
  local lMSG_USAGE="$(luc_core_method_name_get) <TOPIX_SNAME>"
  local lMSG_EXAMPLE="$(luc_core_method_name_get) myjekyllsite" 
  local lTOPIX_SNAME="$1"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lTOPIX_SNAME"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit topix exists
  lECHOVAL=$(luc_jekyll_topix_check_exists "${lTOPIX_SNAME}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "caut" "$lECHOVAL." && return 2 || lTOPIX_HOME="$lECHOVAL"

  # do the job
  # -w = rebuild on changes (cf. --force_polling)
  # -B = in background
  # -I = Enable incremental = faster
  # -l = auto refresh browsers
  # -d = path to builded site
  luc_core_echo "debu" "lTOPIX_HOME=$lTOPIX_HOME" 
  luc_core_echo "step" "serve the topix from HOME (not from build) in background" 
  # 
  jekyll serve -w  --source $lTOPIX_HOME -d /tmp/jksite/$lTOPIX_SNAME
  # jekyll serve -B -w -I --source $lTOPIX_HOME -d /tmp/$lTOPIX_SNAME
  # chmod -R g+w ${lJEKYLL_SITE_HOME}
}
# purpose: stop serving a topix for dev purpose from HOME (not from build)
# args: <TOPIX_NAME>
luc_jekyll_server_stop() {
  local lMSG_PURPOSE="stop serving a topix for dev purpose from HOME (not from build)"
  local lMSG_USAGE="$(luc_core_method_name_get) <TOPIX_NAME>"
  local lMSG_EXAMPLE="$(luc_core_method_name_get) myjekyllsite" 
  local lTOPIX_SNAME="$1"

  # purpose
  luc_core_echo "purp" "$lMSG_PURPOSE" 

  # checkorexit args are provided
  [ -z "$lTOPIX_SNAME"     ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # checkorexit topix exists
  lECHOVAL=$(luc_jekyll_topix_check_exists "${lTOPIX_SNAME}"); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL." && return 2 || lTOPIX_HOME="$lECHOVAL"

  # checkorexit topix is effectivelly served
  lPID=$(ps -ef | grep 'jekyll' | grep -v grep | grep serve | grep "${lTOPIX_HOME}" | awk '{print $2}' )
  [ -z "$lPID" ] && luc_core_echo "warn" "no process found" && return 3

  # kill the process
  luc_core_echo "debu" "lTOPIX_HOME=$lTOPIX_HOME" 
  luc_core_echo "debu" "lPID=$lPID" 
  luc_core_echo "step" "stop serving the site from HOME (kill -9 $lPID)" 
  kill -9 $lPID
}

# in the container
# alias srcluc=". $LUCSETUP > /dev/null"
# lTOPIX_SNAME=it
# srcluc ; rm -rf /tmp/jksite/it ; luc_jekyll_server_stop it; luc_jekyll_server_start $lTOPIX_SNAME
# srcluc ; lTOPIX_SNAME=math rm -rf /tmp/jksite/$lTOPIX_SNAME ; luc_jekyll_server_stop it; luc_jekyll_server_start $lTOPIX_SNAME
# on the remote
# luc_ssh_pf_jekyll_set 9000 o3u mxc-jekyll
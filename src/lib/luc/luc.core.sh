# purpose: add an env var in file /etc/environment
# constraints: user is supposed to be root
# args: <lKEY> <lVALUE>
luc_core_ve_set() {
  local lKEY="$1"
  local lVALUE="$2"
  local lENVFILE="/etc/environment"

  # checkorexit arg is provided  
  [ -z "$lKEY"   ] ||
  [ -z "$lVALUE" ] ||
  [ "--help" == "$1" ] && {    
    luc_core_echo "purp" "add an environment variable to file /etc/environment"
    luc_core_echo "usag" "$(luc_core_method_name_get) <lKEY> <lVALUE>"
    luc_core_echo "exam" "$(luc_core_method_name_get) Myvar MyValue"
    return 1
  }

  # check file exists
  [ ! -f /etc/environment ] && touch /etc/environment

  # exit if var already in file
  grep -q "^$lKEY=" $lENVFILE && return 0

  # add en var to envfile
  echo "$lKEY=$lVALUE" | tee -a /etc/environment > /dev/null

  return 0
}

# purpose: get a random id of length lINT (max = 33)
# args: lINT
luc_core_id_get() {
  local lINT="$1"

  # checkorexit arg is provided  
  [ -z "$lINT" ] ||
  [ "--help" == "$1" ] && {    
    luc_core_echo "purp" "generate a random hexadecimal string of length lINT (max = 33)"
    luc_core_echo "usag" "$(luc_core_method_name_get) <lINT>"
    luc_core_echo "exam" "$(luc_core_method_name_get) 12"
    return 1
  }

  # checkorexit arg is an integer
  lECHOVAL="$(luc_core_check_arg_is_integer $lINT)"; lRETVAL=$?
  [ "$lRETVAL" -ne 0 ] && echo "$lECHOVAL" && return 1
  
  # generate 33 digit string
  lUUID="$(uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]') "

  echo "${lUUID:0:$lINT}"
  return 0
}

# purpose: get/detect the OS name
# args: NONE
luc_core_os_name_get() {
  local lOS_MANAGED="${luc_EV_LUC_CORE_OS_MANAGED}"
  [ -f "/etc/os-release" ] && {
    echo "$(grep -oiE "$lOS_MANAGED" /etc/os-release | head -n 1 | tr '[:upper:]' '[:lower:]')" 
  } || {
    [ "$(uname)" == "Darwin" ] && echo "mac" || echo "Unsupported OS" && return 1
  }
}

# purpose: get/detect the OS name
# args: NONE
luc_core_os_name_get_v2() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [[ "$(uname)" == "Darwin" ]]; then
        echo "macos"  # Specific to macOS
    else
        log_message "ERROR" "Unsupported OS"
        exit 1
    fi

    # specific to macOS: checks if the sw_vers command is available
    # elif command -v sw_vers > /dev/null 2>&1; then
}

# purpose: colored and typed echo
# args: <lMSG_TYPE>
luc_core_echo() {
   # define var
   local lMSG_TYPE=$1
 
   # check 
   [ -z $1 ] && {
     echo "usage: [info|done|warn|caut|debu] [message]"
     return 1
   } 

   shift  # Remove the lMSG_TYPE argument - keep the msg

    # Set color codes
    # "todo") color_code="\033[1;36m" ;;   # todo
    case $lMSG_TYPE in
      "chec") color_code="\033[1;38;5;201m" ;;     # check
      "usag") color_code="\033[1;34m" ;;   # usage
      "purp") color_code="\033[1;34m" ;;   # purpose
      "usag") color_code="\033[1;34m" ;;   # usage
      "info") color_code="\033[32m"   ;;   # green
      "exam") color_code="\033[32m"   ;;   # green
      "done") color_code="\033[32m"   ;;   # bold green  - job already done
      "step") color_code="\033[1;32m" ;;   # bold green
      "doin")   color_code="\033[1;32m" ;;   # bold green
      "warn") color_code="\033[1;31m" ;;   # bold red
      "caut") color_code="\033[1;33m" ;;   # bold yellow - caution
      "todo") color_code="\033[1;33m" ;;   # bold yellow - todo
      "debu") color_code="\033[1;23m" ;;   # bold white  - debug
      *)      color_code="\033[0m"    ;;   # Default (no color)
    esac

    # Print the message in the specified color
    [  "todo"  == "$lMSG_TYPE" ] || 
    [  "step"  == "$lMSG_TYPE" ] && printf "${color_code}${lMSG_TYPE}\033[0m > ${color_code}%s\033[0m\n" "$@" || 
    printf "${color_code}${lMSG_TYPE}\033[0m > %s\n" "$@" && return 0
} 

# purpose: check folder exists
# return: 0 and input if exists; else 1 and msg
# args: <FOLDER_PATH>
luc_core_check_folder_exits() {
  local lFOLDER_PATH="$1"

  # checkorexit args are provided
  [ -z "$lFOLDER_PATH" ]       ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lUSAGE_MSG" && luc_core_echo "exam" "$(luc_core_method_name_get) /tmp/luc/test" && return 1

  # do check
  [ ! -d "$lFOLDER_PATH" ] && echo "folder does not exits: $lFOLDER_PATH" && return 2

  # return
  echo "$lFOLDER_PATH"
  return 0
  
}
# purpose: check folder exists
# args: <FILE_PATH>
luc_core_check_file_exits() {
  local lFILE_PATH="$1"

  # checkorexit args are provided
  [ -z "$lFILE_PATH" ]       ||
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) /tmp/luc/test" 
    return 1
  }

  # do check
  [ ! -f "$lFILE_PATH" ] &&  {
    echo "file not exits: $lFILE_PATH" && return 1
  } || {
    echo "file exits: $lFILE_PATH" && return 0
  }
  
}

# purpose: check CLI is installed
# note: check CLI is installed
# note: return 0 if string is in list else 1
# args: <STRING> <STR|STR|STR>
luc_core_check_string_is_inlist() {
  local lMSG_USAGE="$(luc_core_method_name_get) <STRING> <LIST>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) aaa 'bbb | cccc | ddd'" 
  local lSTRING="$1"
  shift; local lLIST="$@"

  # checkorexit args are provided
  [ -z "$lSTRING" ] ||
  [ -z "$lLIST"   ] ||
  [ "--help" == "$1" ] && luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # ACTION
  [[ "|$(echo "$lLIST" | tr -d ' ' )|" == *"|$lSTRING|"* ]]; lRETVAL="$?"
  [ 0 -ne "$lRETVAL" ] && echo "$lSTRING not in $lLIST" || echo "$lSTRING is in $lLIST"

  # RETURN
  return $lRETVAL
}  

# purpose: check CLI is installed
# not : do not echo a msg on return 1
# args: <lCLI_NAME>
luc_core_check_cli_is_installed() {
  local lCLI_NAME="$1"

  # checkorexit arg is provided
  [ -z "$1" ] && luc_core_echo "warn" "No CLI name provided." && return 1
  # do 
  lECHOVAL=$(command -v "$lCLI_NAME" &> /dev/null); lRETVAL="$?"
  [ 0 -ne "$lRETVAL" ] && echo "CLI is not installed : $lCLI" && return 1
  
  #### RETURN
  return 0
}

# purpose: check ARG is an integer
# args: lARG
luc_core_check_arg_is_integer() {
  local lARG="$1"

  # checkorexit arg is provided
  [ -z "$lARG" ] ||
  [ "--help" == "$1" ] && {    
    luc_core_echo "purp" "Check the arg provided is an integer."
    luc_core_echo "usag" "$(luc_core_method_name_get) <ARG>"
    luc_core_echo "exam" "$(luc_core_method_name_get) 12"
    luc_core_echo "exam" "$(luc_core_method_name_get) zz"
    return 1
  }

  # do 
  expr "$lARG" + 0 &>/dev/null && return 0 || 
  luc_core_echo "warn" "ARG is not an integer: $lARG" && return 1
}

luc_core_debug() {
  luc_core_echo "debu" "###############"
  luc_core_echo "debu" "pause debug"
  luc_core_echo "debu" "###############"
}



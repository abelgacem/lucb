# purpose: get the list of method name in env (ie. sourced)
# args: <lOBJTYPE>
luc_core_object_list() {
  local lOBJTYPE="${1:-}"
  local lUSAGE_MSG="$(luc_core_method_name_get) [OBJTYPE]"
  luc_core_echo "purp" "List LUC objects"


  # checkorexit args are provided
  [ "--help" == "$1" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG" 
    luc_core_echo "exam" "$(luc_core_method_name_get) (display all objects of all libraries)" 
    luc_core_echo "exam" "$(luc_core_method_name_get) cim" 
    return 1
  }
  
  # 
  luc_core_echo "info" "core variables"
  compgen -A variable | grep '^luc_EV_LUC_CORE' | sort | xargs -I{} sh -c "echo {} : \${}"
  # 
  luc_core_echo "info" "core functions"
  compgen -A function | grep '^luc_core' |sort 
  # # 
  # luc_core_echo "info" "other variables"
  # compgen -A variable | grep '^luc_EV' | grep -v '^luc_EV_LUC_CORE' | sort | xargs -I{} sh -c "echo {} : \${}"
  # 
  luc_core_echo "info" "other variables"
  compgen -A variable | grep "^luc_EV_$(echo "$lOBJTYPE" | tr '[:lower:]' '[:upper:]')" | grep -v '^luc_EV_LUC_CORE' | sort | xargs -I{} sh -c "echo {} : \${}"
  # # 
  # luc_core_echo "info" "other functions"
  # compgen -A function | grep '^luc_' | grep -v '^luc_core'  |sort
  # 
  luc_core_echo "info" "other functions"
  compgen -A function | grep "^luc_$lOBJTYPE" | grep -v '^luc_core'  |sort
}

# purpose: get the method name - works only inside a method (introspection)
luc_core_method_name_get() {
  # Check if running in Bash
  if [ -n "${BASH_VERSION}" ]; then
    # Use FUNCNAME for Bash
    echo "${FUNCNAME[1]}"
  elif [ -n "$0" ]; then
    # Fallback to script name for non-Bash shells
    echo "<function>"
  else
    # Ultimate fallback
    echo "Unknown"
  fi
}
# luc_core_method_name_get() {
#   # Determine the name of the current function or script
#   if [ -n "${FUNCNAME[1]}" ]; then
#     # For Bash, get the calling function name
#     echo "${FUNCNAME[1]}"
#   elif [ -n "$0" ]; then
#     # For other shells, fall back to the script name
#     echo "$0"
#   else
#     # Ultimate fallback
#     echo "Unknown"
#   fi
# }


# purpose: unload objects (ie. function, VE) specific to LUC from the current SHELL session
luc_core_object_unload() { 
  lPATTERN=$1
  # info
  # checkorexit $1 is provided
  [ -z $1 ] && {
    luc_core_echo "purp" "delete LUC objects in the current SHELL session"
    luc_core_echo "usag" "$(luc_core_method_name_get) (all | docker | buildah | ...)"
    return 1
  } 
  # do
  [ "all" == "$lPATTERN" ] && lPATTERN=""
  # info
  luc_core_echo "purp" "delete LUC objects: luc_$lPATTERN, in the current SHELL session"
  # do
  unset -f $(compgen -A function | grep "^luc_$lPATTERN"); 
  unset -f $(compgen -A variable | grep "^luc_EV_$lPATTERN"); 
  # here luc_core_echo is no more available
  printf "\033[32mdone\033[0m\n"
  return 0
} 

# purpose: expose objects (ie. function, VE) specific to LUC in the current SHELL session
luc_core_object_load() { 
  source srclib
}

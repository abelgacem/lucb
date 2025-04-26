# purpose: Create a Vanilla k8s cluster
# args: <DATE_BEGIN_SECONDE> <DATE_END_SECONDE>
luc_core_other_delay() {
  local lMSG_PURPOSE="Map seconde into minutes and seconds"  
  local lMSG_USAGE="$(luc_core_method_name_get) <DATE_BEGIN_SECONDE> <DATE_END_SECONDE>"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) 402 605"  
  local lDATE_BEGIN_SECONDE="$1" 
  local lDATE_END_SECONDE="$2"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lDATE_BEGIN_SECONDE" ] ||
  [ -z "$lDATE_END_SECONDE"   ] ||
  [ "--help" == "$1"          ] &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  # # checkorexit date are integer
  # (($lDATE_BEGIN_SECONDE == $lDATE_BEGIN_SECONDE)) 2>/dev/null || {
  #   echo "echo not a integer:  $lDATE_BEGIN_SECONDE" && return 2
  # }
  # # checkorexit date are integer
  # (($lDATE_END_SECONDE   == $lDATE_END_SECONDE))   2>/dev/null || {
  #   echo "echo not a integer:  $lDATE_END_SECONDE" && return 3
  # }
  ###### ACTION CALCULUS 
  lDELTA_SECOND=$(($lDATE_END_SECONDE -  $lDATE_BEGIN_SECONDE))
  lECHOVAL="$(($lDELTA_SECOND / 60)) minutes $(($lDELTA_SECOND % 60)) secondes"; lRETVAL=0 
  
  #####
  echo "$lECHOVAL"
  return $lRETVAL
}

# purpose : manage container images and images with Buildah

# shortcuts
# luc_cil_enter_provision      () { luc_cil_container_provision_play "$@"; }
# luc_cil_enter_provision      () { luc_cil_container_provision_file "$@"; }
# luc_cil_enter_configure      () { luc_cil_container_configure "$@"; }



# purpose: provision a container
# args: lCONTAINER_SID lACTION
luc_cil_container_provision_play() {
  luc_core_echo "purp" "provision a container by playing a CLI"
  local lCONTAINER_SID="$1"
  luc_core_echo "info" "\$1 = $1"
  luc_core_echo "info" "\$2 = $2"
  luc_core_echo "info" "\$@ = $@"
  shift
  luc_core_echo "info" "\$1 = $1"
  luc_core_echo "info" "\$2 = $2"
  luc_core_echo "info" "\$@ = $@"

  # luc_core_echo "info" "\$# = $#"
  # luc_core_echo "info" "\$@ = $@ X"
  # luc_core_echo "info" "buildah run "${lCONTAINER_SID}" "$@""
  # luc_core_echo "debu" "buildah run "${lCONTAINER_SID}" "$@""

  # check object exists
  lECHOVAL=$(luc_cil_container_id_get "${lCONTAINER_SID}"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # # check arguments
  # [ "$#" -ne 2 ]  && {
  #   luc_core_echo "warn" "Needed 2 args not empty: lIMAGE_SID, lACTION"
  #   return 2
  # }  

  luc_core_echo "step" "action: $lACTION"
  buildah run "${lCONTAINER_SID}" "$@"
}


# purpose: copy file from host to container
# args: lCONTAINER_SID lHOST_SRC lCONTAINER_DST
luc_cil_container_provision_copy() {
  luc_core_echo "purp" "provision file from host to container"
  local lCONTAINER_SID=$1
  local lHOST_SRC=$2
  local lCONTAINER_DST=$3

  # checkorexit container exists
  lECHOVAL=$(luc_cil_container_id_get "${lCONTAINER_SID}"); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1

  # check arguments
  [ "$#" -ne 3 ]  && {
    luc_core_echo "warn" "Needed 3 args not empty: lCONTAINER_SID lHOST_SRC lCONTAINER_DST"
    return 2
  }  

  # checkorexit file|folder exists
  [ -f "$lHOST_SRC" ] || [ -d "$lHOST_SRC" ] || {
    luc_core_echo "warn" "host file not exists : $lHOST_SRC"
    return 1
  }
  
  luc_core_echo "step" "copy from src=HOST:$lHOST_SRC to dst=CONTAINER:${lCONTAINER_DST}"
  buildah copy "${lCONTAINER_SID}" "$lHOST_SRC" "${lCONTAINER_DST}"
}
luc_cil_container_configure() {
  luc_core_echo "purp" "configure a container"
}
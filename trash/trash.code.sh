
# # purpose: 3 state function that check if an image exists
# ## if image exists AND is uniq,    => echo ID and return 0 
# ## if image exists AND is not uniq => return 2 
# ## if image not exists,            => return 1  
# mmx_buildah_image_id_get() {
#     local lIMAGE_ID_SHORT=$1

#   # check
#   [ -z $1 ] && {
#     luc_core_echo "warn" "No image name provided. Choose 1 among:" 
#     buildah images
#     return 1
#   }

#   # if 1 image exists => return 1 image:id 
#   # if N image exists => return N image:id in N lines 
#   # if error occur    => IMAGE_ID is empty  => meaning image does not exists
#   local IMAGE_ID=$(buildah images --format "{{.ID}}" "${lIMAGE_ID_SHORT}" 2>/dev/null)
#   # check - var is non-empty => meaning there is at least 1 image:id
#   [ -n "$IMAGE_ID" ] && {
#     # if 1 line   => echo ID and return 0
#     # if > 1 line => return 2
#     [ 1 -eq "$(wc -l <<< $IMAGE_ID)" ] && echo "$IMAGE_ID" && return 0 || return 2
#   }
#   return 1
# }



#   # Determine the Linux distribution
#   if grep -iq "alpine" /etc/os-release; then
#     sudo useradd -m -s /bin/ash "$lUSER_OS"
#   elif grep -iq "ubuntu" /etc/os-release || grep -iq "debian" /etc/os-release; then
#     sudo adduser --disabled-password --gecos "" "$lUSER_OS"
#   else
#     # Default for AlmaLinux, Rocky Linux, and other RHEL-based systems
#     sudo useradd -m -s /bin/bash "$lUSER_OS"
#   fi

#   luc_core_echo "info" "User $lUSER_OS created successfully."
# }



# vm_host_check_is_ssh_reachable "$lHOST_IP"  || {
#   luc_core_echo "warn" "host is unreachable: $lHOST_IP"
#   return 1
# }


# buildah containers --format "{{.ContainerID}}"

# vm_id_get
# luc_core_check_cli_is_installed "git"
# check_host_is_reachable "o3u" || echo "merde"
# vm_port_status_get "o3r" "81" 
# vm_port_status_list "o3u" "80 443 35729 6443 2379 2380 10250 10257 10259"
# vm_port_status_set "o1u 6443 tcp out close"
# vm_port_status_get "localhost" "6443"


# mmx_core_action_confirm() { 
#   # define var
#   local action="$1"
#   local message="$action? (y/n): "

#   # check
#   [ -z "$1" ] && {
#     luc_core_echo "warn" "No confirmation message provided."
#     return 1
#   }

#   # prompt user
#   ## First print the message
#   luc_core_echo "caut" "$message"

#   ## Then read the user input
#   read confirmation
#   # 
#   case "$confirmation" in
#     [Yy]*) return 0 ;; # User confirmed
#     *) return 1 ;;     # User declined
#   esac
# }

# purpose: provision luc tool
# prerequisit: a golden image with
#  - a sudo user
#  - a folder wkspc/tool
# mmx_core_provision() {
#   # define var
#   local lLUC_HOME="${luc_EV_LUC_CORE_HOME}"
#   local lLUC_LIB="${luc_EV_LUC_CORE_LIB}"
#   luc_core_echo "purp" "provision luc tool in $lLUC_HOME"
#   # create home folder
#   mkdir -p /$lLUC_LIB
#   # copy files
#   cp /tmp/luc/lib/* $lLUC_LIB/
#   # define envar
#   grep -q "^luc_EV_LUC_CORE_HOME=" /etc/environment || echo "luc_EV_LUC_CORE_HOME=$lLUC_HOME" | sudo tee -a /etc/environment > /dev/null
#   # done
#   luc_core_echo "done"
# }

# mmx_core_debug_list_item() {
#   local lLIST=$@
#   # list file:fullpathname
#   # echo "$lLIST" | tr ' ' '\n' | sed 's/^/1 item: /' | basename
#   # list file:name
#   echo ${lLIST} | tr ' ' '\n' | xargs -n1 basename | sed 's/^/1 item: /'
# }


# compgen -A variable | grep '^luc_EV' | sort | xargs -I{} sh -c "echo {} : \${}"
# compgen -A variable | grep '^luc_EV' | sort | while read -r var; do
# echo "$var : ${!var}"
# done


# # checkorexit CLI is installed
# CLI="$lIMAGE_TYPE";luc_core_check_cli_is_installed ${CLI} || { 
#   luc_core_echo "warn" "${CLI} is not installed." 
#   return 1 
# }

# # checkorexit image type is managed
#   [ ! "$lIMAGE_TYPE" == "docker" ]  && 
#   [ ! "$lIMAGE_TYPE" == "buildah" ] &&
#   luc_core_echo "usag" "$lUSAGE_MSG" && return 1

# # getorexit container name
# lCONTAINER_NAME=$(buildah from --name "${lCONTAINER_NAME_WANTED}" "$lIMAGE_SID 2>/dev/null)
# [ -z ${lCONTAINER_NAME} ] && luc_cil_display_container_exists_already "${lCONTAINER_NAME_WANTED}" && return 3
# echo "${lCONTAINER_NAME}" && return 0

# # checkorexit args
# [ "$#" -ne 2 ] && {
#   luc_core_echo "warn" "Needed 2 args: lIMAGE_SID lIMAGE_REGISTRY_PATH"
#   return 1
# }


# purpose: enter into an image or container
# args: lOBJECT_TYPE lOBJECT_SID
luc_cim_enter() {
  local lOBJECT_TYPE="$1"
  local lOBJECT_SID="$2"
  local lSHELL=''
  local lUSAGE_MSG="$(luc_core_method_name_get) --image|--container <lIMAGE_OR_CONTAINER_SID> [Flags]"
  local lCIM_TOOL=''

  # checkorexit cli exists
  luc_core_check_cli_is_installed docker  && lCIM_TOOL="docker"
  luc_core_check_cli_is_installed buildah && lCIM_TOOL="buildah"
  [ ! -n "$lCIM_TOOL" ] && luc_core_echo "warn" "none of docker|buildah is installed" && return 1

  # info
  luc_core_echo "purp" "enter a $lCIM_TOOL container or a container image."

  # checkorexit args are provided
  [ -z "$lOBJECT_TYPE" ]         ||
  [ -z "$lOBJECT_SID" ]          ||
  [ "$lOBJECT_TYPE" == "-help" ] && {
    luc_core_echo "usag" "$lUSAGE_MSG"
    luc_cim_list 
    return 1
  } 

  # checkorexit args are managed
  [ "$lOBJECT_TYPE" != "--image" ]      && 
  [ "$lOBJECT_TYPE" != "--container" ]  && 
  luc_core_echo "usag" "$lUSAGE_MSG" && return 1
  

  # checkorexit object exists
  lECHOVAL=$(luc_cim_property_get ${lOBJECT_TYPE} $lOBJECT_SID id); lRETVAL=$?  
  [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1 || lOBJECT_ID="$lECHOVAL"
  # luc_core_echo "debu" "lOBJECT_ID=$lOBJECT_ID"
  
  # get object:property
  lECHOVAL=$(luc_cim_property_get ${lOBJECT_TYPE} $lOBJECT_SID shell); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 || lSHELL="$lECHOVAL"

  # get object:property
  lECHOVAL=$(luc_cim_property_get ${lOBJECT_TYPE} $lOBJECT_SID name); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && echo "$lECHOVAL" && return 1 || lOBJECT_NAME="$lECHOVAL"

  # info
  luc_core_echo "debu" "lOBJECT_TYPE=${lOBJECT_TYPE/--/}"
  luc_core_echo "debu" "lOBJECT_ID=${lOBJECT_ID:0:6}"
  luc_core_echo "debu" "lOBJECT_NAME=$lOBJECT_NAME"
  luc_core_echo "debu" "lSHELL=$lSHELL"
  
  # Get in $@ the rest of the flags like -v xxxxx:yyyy:ro
  shift 2;

  # for image create a temporary container and enter
  [ "$lOBJECT_TYPE" == "--image" ] && {
    luc_core_echo "debu" "create a temporary container"
    luc_core_echo "debu" "run -t container"
  }
  # for container just enter
  [ "$lOBJECT_TYPE" == "--container" ] && {
    luc_core_echo "debu" "docker > if running     > docker exec -it $lOBJECT_ID$lSHELL -l"
    luc_core_echo "debu" "docker > if not running > create a temporary image then > docker run -it --rm $lOBJECT_ID$lSHELL -l > then delete tmp image"
    luc_core_echo "info" "enter container > ${lOBJECT_NAME}"
    luc_core_echo "debu" "$lCIM_TOOL run -t $@ $lOBJECT_ID $lSHELL -l"
    luc_core_echo "debu" "$lCIM_TOOL run -it $@ --rm test:test  $lSHELL -l"
  }

}


  # # configure container - define envar
  # lCONF="LUCSETUP=${lFOLDER_LUC_CONTAINER}/${lFILE_LUC_BOOT}"
  # luc_core_echo "step" "define envvar : ${lCONF}"
  # [ "docker"  == "$lCIM_TOOL" ] && {
  #   # create image from container
  #   $lCIM_TOOL commit  --change="ENV ${lCONF}" ${lCONTAINER_TEMPORARY_ID} ${lIMAGE_GOLDEN_NAMEANDTAG}
  #   # create temporary container from image
  #   lCONTAINER_TEMPORARY_NAME="temp-$(luc_core_id_get 5)"
  #   $lCIM_TOOL run -d --name ${lCONTAINER_TEMPORARY_NAME} -v ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}:ro ${lIMAGE_GOLDEN_NAMEANDTAG}
  #   # get container id
  #   lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.${lFIELD_CONTAINERID}}} ${lCONTAINER_TEMPORARY_NAME})
  #   lCONTAINER_TEMPORARY_ID="${lCONTAINER_TEMPORARY_ID:0:5}"
  # }
  # [ "buildah" == "$lCIM_TOOL" ] && {
  #   $lCIM_TOOL config  --env ${lCONF} ${lCONTAINER_TEMPORARY_ID}
  # }
  # luc_core_echo "done"


  # configure container - working dir
  lCONF="/home/${lOS_USER_SUDO}"
  luc_core_echo "step" "configure working dir : ${lCONF}"
  [ "docker"  == "$lCIM_TOOL" ] && {
    # create image from container
    $lCIM_TOOL commit  --change="WORKDIR ${lCONF}" ${lCONTAINER_TEMPORARY_ID} ${lIMAGE_GOLDEN_NAMEANDTAG}
    # create temporary container from image
    lCONTAINER_TEMPORARY_NAME="temp-$(luc_core_id_get 5)"
    $lCIM_TOOL run -d --name ${lCONTAINER_TEMPORARY_NAME} -v ${lFOLDER_LUC_HOST}:${lFOLDER_LUC_CONTAINER}:ro ${lIMAGE_GOLDEN_NAMEANDTAG}
    # get container id
    lCONTAINER_TEMPORARY_ID=$($lCIM_TOOL inspect --type container --format {{.${lFIELD_CONTAINERID}}} ${lCONTAINER_TEMPORARY_NAME})
    lCONTAINER_TEMPORARY_ID="${lCONTAINER_TEMPORARY_ID:0:5}"
  }
  [ "buildah" == "$lCIM_TOOL" ] && {
    $lCIM_TOOL config  --workingdir="${lCONF}" ${lCONTAINER_TEMPORARY_ID}
  }


# # Check
# CLI='buildah'; luc_core_check_cli_is_installed ${CLI} || { 
#   luc_core_echo "caut" "library : $lLIB > ${CLI} is not installed." 
#   return 1 
# }   

# # Check
# CLI='jq'; luc_core_check_cli_is_installed ${CLI} || { 
#   luc_core_echo "caut" "library : $lLIB > ${CLI} is not installed." 
#   return 1 
# }   

# local lPORT_CONTAINER="${luc_EV_CONTAINER_PORT_JEKYLL_CONTAINER}"
# local lPORT_HOST="${luc_EV_CONTAINER_PORT_JEKYLL_HOST}"
# lOPTION_PORT_AT_ENTER="--port $lPORT_HOST${lPORT_CONTAINER}"
# lOPTION_PORT_AT_CREATE="${lOPTION_PORT}"
# lOPTION_PORT_AT_CREATE=""
# luc_core_echo "info" "conf > port           : ${lOPTION_PORT_AT_ENTER}"
# ${lOPTION_PORT_AT_CREATE}  \


  # # create container
  # [ "$lCIM_TOOL" == "buildah" ] && {
  #   lECHOVAL=$(buildah from $lOPTIONS --name $lCONTAINER_NAME $lIMAGE_SID 2>&1)
  #   lRETVAL=$?
  # } 



  [ "$lCIM_TOOL" == "buildah" ] && {
    lFIELD_IMAGE_NAME='Name'
    lFIELD_CONTAINER_ID='ContainerID'
    lFIELD_CONTAINER_NAME='ContainerName'
    lFIELD_IMAGE_ID='ImageID'
    lFIELD_CMD="OCIv1.config.Cmd[]"
    lFIELD_PORT="OCIv1.config.ExposedPorts"
    lFIELD_ISRUNNING="State"
    # lFIELD_ENV="Config | fromjson | .config | .Env[]"
    lFIELD_ENV="OCIv1.config.Env"
    lFIELD_LABELS="Docker.config.Labels"
    lFIELD_LABEL_SHELL="Docker.config.Labels[\"${lLABEL_IMAGE_SHELL}\"]"
    lFIELD_LABEL_OSNAME="Docker.config.Labels[\"${lLABEL_IMAGE_OSNAME}\"]"
    lFIELD_JSON="${lOBJECT_PROPERTY/json:/}"
  }


      # lVALUE=$($lCIM_TOOL ${lOBJECT_TYPE/--/} list --all --format "{{$lFIELD_IMAGE_NAME}}" | grep  "$lOBJECT_SID" | awk -F'/' '{print $NF}'  | awk -F':' '{print $1}')

    image:path)
      lVALUE=$($lCIM_TOOL images --all --format "{{.$lFIELD_IMAGE_NAME}}:{{.Tag}}:{{.ID}}" | grep  "$lOBJECT_SID" | cut -d':' -f1 | xargs dirname)
      ;;


    # container:env)
    #   lVALUE=$($lCIM_TOOL inspect --type container $lOBJECT_SID | jq  ".${lFIELD_ENV}?" ) 
    #   ;;
    # image:label)
    #   lVALUE=$($lCIM_TOOL inspect --type image $lOBJECT_SID | jq -r ".${lFIELD_LABELS}?")
    #   ;;
    # image:shell)
    #   lVALUE=$($lCIM_TOOL inspect --type image $lOBJECT_SID | jq -r ".${lFIELD_LABEL_SHELL}?")
    #   ;;


    # container:isrunning)
    #   lVALUE=$($lCIM_TOOL inspect --type container $lOBJECT_SID | jq -r ".${lFIELD_ISRUNNING}?")
    #   ;;
    # container:shell|image:shell)
    #   lVALUE=$($lCIM_TOOL inspect $lOBJECT_SID  | jq ".${lFIELD_LABEL_SHELL}?");
    #   ;;
    # image:os:name|container:os:name)
    #   lVALUE=$($lCIM_TOOL inspect  $lOBJECT_SID | jq  -r ".${lFIELD_LABEL_OSNAME}?" ) 
    #   ;;
    # image:port)
    #   lVALUE=$($lCIM_TOOL inspect --type image $lOBJECT_SID | jq -r ".${lFIELD_PORT}?")
    #   ;;



    # image:json)
    #   $lCIM_TOOL inspect --type image  "$lOBJECT_SID" | jq . && return 0
    #   ;;

    # lFIELD_ENV="Config | fromjson | .config | .Env[]"
    # lFIELD_PORT="OCIv1.config.ExposedPorts"
    # lFIELD_ISRUNNING="State"
    # lFIELD_ENV="OCIv1.config.Env"
    # lFIELD_LABELS="Docker.config.Labels"
    # lFIELD_LABEL_SHELL="Docker.config.Labels[\"${lLABEL_IMAGE_SHELL}\"]"
    # lFIELD_LABEL_OSNAME="Docker.config.Labels[\"${lLABEL_IMAGE_OSNAME}\"]"


  # lookup field according to object_type
  [ "$lOBJECT_TYPE" == "--container" ] && {
      lCLI_DELETE='rm'
      lCLI_LIST='ps'
  }
  [ "$lOBJECT_TYPE" == "--image" ] && {
      lCLI_DELETE='rmi'
      lCLI_LIST='images'
  }
  
  # lookup field according to tool
  [ "$lCIM_TOOL" == "docker" ] && {
      lCLI_DELETE_OPTION='--force'
  }

  # get cli flogs
  shift 1; lOBJECT_LIST=$@
  # define vars when --all
  [  "$lOBJECT_SID" == "--all" ] && [ "$lCIM_TOOL" == "docker"  ] && {
    [ "$lOBJECT_TYPE" == "--container" ] && lOBJECT_LIST="$(docker container ls -aq)"
    [ "$lOBJECT_TYPE" == "--image" ]     && lOBJECT_LIST="$(docker images -aq)"
    [ -z "$lOBJECT_LIST/ /" ] && luc_core_echo "caut" "no objects to delete" && return 1
  }
  # define vars when --dangling
  [ "$lOBJECT_SID" == "--dangling" ] && {
    [ "$lOBJECT_TYPE" == "--container" ] && luc_core_echo "caut" "dangling container not exists" && return 1
    [ "$lOBJECT_TYPE" == "--image"     ] && lOBJECT_LIST="$($lCIM_TOOL images --all --quiet --filter dangling=true) $($lCIM_TOOL images --all | awk '/<none>/ { print $3 }')"
    [ -z "$lOBJECT_LIST/ /" ]  && luc_core_echo "caut" "no dangling image to delete" && return 1
  }
  # define vars when --temp
  [ "$lOBJECT_SID" == "--temp" ] && {
    [ "$lOBJECT_TYPE" == "--container" ] && lOBJECT_LIST="$($lCIM_TOOL ps --all --quiet --filter 'name=temp-')"
    [ "$lOBJECT_TYPE" == "--image"     ] && luc_core_echo "caut" "temp images not exists" && return 1
    [ -z "$lOBJECT_LIST/ /" ] && luc_core_echo "caut" "no temp container to delete" && return 1
  }


  # when docker
  [ "$lCIM_TOOL" == "docker" ]  && {
    # enter image via a temporary container
    $lCIM_TOOL run -it --rm  --name ${lCONTAINER_NAME_TEMP} $lOPTIONS $lIMAGE_SID${lIMAGE_SHELL} -l
    return 0
  }

  # when buildah
  [ "$lCIM_TOOL" == "buildah" ] && {
    # createorexit temporary container
    luc_core_echo "info" "create temporary container ${lCONTAINER_NAME_TEMP}"
    lECHOVAL=$(luc_cim_container_create ${lCONTAINER_NAME_TEMP} $lIMAGE_SID; lRETVAL=$?  
    [ 0 -ne "$lRETVAL" ]  && echo "$lECHOVAL" && return 1
    # enter the temporary container
    luc_core_echo "info" "enter temporary container ${lCONTAINER_NAME_TEMP}"
    $lCIM_TOOL run -t $lOPTIONS ${lCONTAINER_NAME_TEMP} ${lIMAGE_SHELL} -l 
    luc_core_echo "caut" "deleted temporary container ${lCONTAINER_NAME_TEMP}"
    $lCIM_TOOL rm ${lCONTAINER_NAME_TEMP}
    return 0
  }


# noargs 
luc_docker_image_delete () {
  # define var
  lIMAGE_NAME_PATTERN=$1
  lTHIS_METHOD_NAME="${FUNCNAME[0]}"
  [ $# -eq 0 ] && {
    echo 
    echo "name:      ${lTHIS_METHOD_NAME}"
    echo "purpose:   delete docker image"
    echo "input \$1 : image:name:pattern to delete"
    echo "example:   ${lTHIS_METHOD_NAME} os.alpine.3.10"
    echo "example:   ${lTHIS_METHOD_NAME} anaconda.u"
    echo 
    return
  }
  docker image list -a  | grep ${lIMAGE_NAME_PATTERN} |  xargs docker image rm -f 2> /dev/null
}

# noargs 
luc_docker_image_enter () {
  ## from method:input
  lIMAGE_ID="$1"

  [ $# -eq 0 ] && {
    echo 
    echo "name:      ${FUNCNAME[0]}"
    echo "purpose:   enter in a docker image"
    echo "input \$1: image name"
    echo "input \$1: can be > "
    echo "$(docker images --format "{{.Repository}}:{{.ID}}")" | sed -e "s/^/   - /"
    echo 
    return
  }

  # check image exists
  lRESULT="$(docker images -a | grep $lIMAGE_ID)"
  [ -z "$lRESULT" ] && echo "mx > WARNING > provided image id not exists: $lIMAGE_ID" && return
  # define var@local from image:id
  lCONTAINER_NAME="c$(docker inspect --format '{{json .RepoTags}}' $lIMAGE_ID | jq -r '.[]' | tr '/:' "-")"
  # define var@local from image:id
  lIMAGE_OS="$(docker inspect --format '{{json .Config.Env}}' $lIMAGE_ID | jq -r '.[]' | grep "gdk_NAME_OS" | cut -d"=" -f2)"
  # define var@local from image:os
  [ "alpine" == "$lIMAGE_OS" ] && lIMAGE_SHELL="/bin/sh" || lIMAGE_SHELL="/bin/bash"

  # mx:info@debug
  echo -e
  echo "mx > info > debug > lIMAGE_ID       = $lIMAGE_ID"
  echo "mx > info > debug > lCONTAINER_NAME = ${lCONTAINER_NAME}"
  echo "mx > info > debug > lIMAGE_OS       = $lIMAGE_OS"
  echo "mx > info > debug > lIMAGE_SHELL    = ${lIMAGE_SHELL}"

  # play cli
  docker run -it --name ${lCONTAINER_NAME} --rm $lIMAGE_ID ${lIMAGE_SHELL} -l
}

# noargs 
luc_docker_image_build () {
  # define var@local
  ## from var@(array,script)
  local l_LIST_IMAGE_TYPE=("${sl_LIST_IMAGE_TYPE[@]}");    l_NB_LIST_IMAGE_TYPE=${#l_LIST_IMAGE_TYPE[@]}
  local lLIST_IMAGE_OS=("${slLIST_IMAGE_OS[@]}");        lNB_LIST_IMAGE_OS=${#lLIST_IMAGE_OS[@]}
  local lLIST_IMAGE_PYTHON=("${sl_LIST_IMAGE_PYTHON[@]}");lNB_LIST_IMAGE_PYTHON=${#lLIST_IMAGE_PYTHON[@]}
  local lLIST_IMAGE_OTHER=("${sl_LIST_IMAGE_OTHER[@]}");  lNB_LIST_IMAGE_OTHER=${#lLIST_IMAGE_OTHER[@]}
  local lREGISTRY_ORG="${sl_REGISTRY_ORG}"
  local lREGISTRY_PUB="${slREGISTRY_PUB}"

  # display choice (ie. list of possible image:type to build)
  echo "List of possible image type to build ($l_NB_LIST_IMAGE_TYPE)"
  echo ${l_LIST_IMAGE_TYPE[@]} | sed -e "s@- @\n@g" -e "s@-@@g" | cat -n
  local lMSG01="enter your choice ($(echo 1-${l_NB_LIST_IMAGE_TYPE})) any other char will be considered as do noting  "
  # read choice (ie. index)
  read -p "$lMSG01 ? " lUSER_INPUT && [[ ! "${lUSER_INPUT}" =~ ^[1-${l_NB_LIST_IMAGE_TYPE}]$ ]] && echo "done nothing" && return
  
  # map choice to needed info
  local lINDEX=$((lUSER_INPUT -1)); local l_IMAGE_TYPE="${l_LIST_IMAGE_TYPE[$lINDEX]/-/}"
  [ "os"      == "$l_IMAGE_TYPE" ] && {
    local lLIST_IMAGE=("${slLIST_IMAGE_OS[@]}");local lNB_LIST_IMAGE=${lNB_LIST_IMAGE_OS}
  }

  [ "python"  == "$l_IMAGE_TYPE" ] && {
    local lLIST_IMAGE=("${sl_LIST_IMAGE_PYTHON[@]}");local lNB_LIST_IMAGE=${lNB_LIST_IMAGE_PYTHON}
  }

  [ "other"   == "$l_IMAGE_TYPE" ] && {
    local lLIST_IMAGE=("${sl_LIST_IMAGE_OTHER[@]}");local lNB_LIST_IMAGE=${lNB_LIST_IMAGE_OTHER}
  }

  # display choice (ie. list of possible image to build)
  echo "List of possible image to build ($lNB_LIST_IMAGE)"
  echo ${lLIST_IMAGE[@]} | sed -e "s@- @\n@g" -e "s@-@@g" | cat -n
  lMSG01="enter your choice ($(echo 1-${lNB_LIST_IMAGE})) any other char will be considered as do noting  "
  # read choice (ie. index)
  read -p "$lMSG01 ? " lUSER_INPUT && [[ ! "${lUSER_INPUT}" =~ ^[1-${lNB_LIST_IMAGE}]$ ]] && echo "done nothing" && return
  lINDEX=$((lUSER_INPUT -1))
  
  # map choice to needed info
  [ "os"      == "$l_IMAGE_TYPE" ] && {
    local lIMAGE_FROM=$(cut   -d':' -f1-2 <<< ${lLIST_IMAGE[$lINDEX]/-/})
    local lAPP_NAME=$(cut     -d':' -f1   <<< ${lLIST_IMAGE[$lINDEX]/-/})
    local lAPP_VERSION=$(cut  -d':' -f2   <<< ${lLIST_IMAGE[$lINDEX]/-/})
    local lDOCKERFILE_PATH="${slIDOCKERFILE_FOLDER_ROOT}/os"  
    local lREGISTRY_FROM="${lREGISTRY_PUB}"
    local lIMAGE_REGISTRY_PATH_FROM="library"
    [ "rocky" == "$lAPP_NAME" ] && lIMAGE_FROM=${lIMAGE_FROM/$lAPP_NAME/rockylinux}
    [ "alma"  == "$lAPP_NAME" ] && lIMAGE_FROM=${lIMAGE_FROM/$lAPP_NAME/almalinux}
  }

  [ "python"  == "$l_IMAGE_TYPE" ] && {
    local lFOLDER_NAME_IMAGE="python"
    local lIMAGE_FROM=$(awk  '{print $NF}' <<< ${lLIST_IMAGE[$lINDEX]} | sed -e "s@-@@")
    local lAPP_NAME="python.${lIMAGE_FROM%%:*}"
    local lAPP_VERSION=$(awk '{print $2}'  <<< ${lLIST_IMAGE[$lINDEX]/-/})
    local lDOCKERFILE_PATH="${slIDOCKERFILE_FOLDER_ROOT}/python"  
    local lREGISTRY_FROM="${lREGISTRY_ORG}"
    local lIMAGE_REGISTRY_PATH_FROM="library"
  }

  [ "other"   == "$l_IMAGE_TYPE" ] && {
    local lAPP_NAME=$(awk        '{print $1}'      <<< ${lLIST_IMAGE[$lINDEX]/-/})
    local lFOLDER_NAME_IMAGE="$lAPP_NAME"
    local lAPP_VERSION=$(awk     '{print $2}'      <<< ${lLIST_IMAGE[$lINDEX]/-/})
    local lIMAGE_FROM_NAME=$(awk '{print $(NF-1)}' <<< ${lLIST_IMAGE[$lINDEX]/-/})
    local lIMAGE_FROM_TAG=$(awk  '{print $NF}'     <<< ${lLIST_IMAGE[$lINDEX]} |  sed 's/.$//')
    local lIMAGE_FROM="${lIMAGE_FROM_NAME}:${lIMAGE_FROM_TAG}"
    local lPACKAGE_NAME=$lAPP_NAME
    local lDOCKERFILE_PATH="${slIDOCKERFILE_FOLDER_ROOT}/$lAPP_NAME"
    local lREGISTRY_FROM="${lREGISTRY_ORG}"
    local lIMAGE_REGISTRY_PATH_FROM="library"
    [ "on"      == "${lAPP_VERSION}" ] && lAPP_VERSION="${lIMAGE_FROM%%:*}"
    [ "awscli"  == "$lAPP_NAME"    ] && lPACKAGE_NAME="aws-cli"
    [ "ansible"  == "$lAPP_NAME"   ] && lPACKAGE_NAME="ansible-core"
  }


  # define cli
  local lCLI='mx_docker_image_build "$lIMAGE_FROM" "$lREGISTRY_FROM" "$lIMAGE_REGISTRY_PATH_FROM" "$lAPP_NAME" "$lAPP_VERSION"  "$lDOCKERFILE_PATH" "$lPACKAGE_NAME"'
    
  # # mx:info@debug
  # echo "mx > debug > play cli > $lCLI"
  # echo "lIMAGE_FROM                = $lIMAGE_FROM"
  # echo "lREGISTRY_FROM             = $lREGISTRY_FROM"
  # echo "lIMAGE_REGISTRY_PATH_FROM  = $lIMAGE_REGISTRY_PATH_FROM"
  # echo "lAPP_NAME                  = $lAPP_NAME"
  # echo "lAPP_VERSION               = $lAPP_VERSION"
  # echo "lDOCKERFILE_PATH           = $lDOCKERFILE_PATH"
  # echo "lPACKAGE_NAME              = $lPACKAGE_NAME"

  # play cli
  eval $lCLI    
}

# noargs 
mx_docker_image_build () {
  # define var@local
  ## from var@argument at runtime
  local lIMAGE_FROM=$1
  local lREGISTRY_FROM=$2
  local lIMAGE_REGISTRY_PATH_FROM=$3
  local lIMAGE_NAME_DEST=$4
  local lIMAGE_TAG_DEST=$5
  local lDOCKERFILE_PATH=$6
  local lIMAGE_PACKAGE=$7
  ## var@claculated
  local lIMAGE_PACKAGE=$7
   

  ## from var@(script)
  local lREGISTRY_DEST="${sl_REGISTRY_ORG}"
  local lIMAGE_REGISTRY_PATH_DEST="${sl_IMAGE_REGISTRY_PATH_ORG}"

  # check folder exits
  mx_check_folder_exits ${lDOCKERFILE_PATH}  || return

  # check app exits (ie. is installed)
  mx_check_app_exist docker        || return
  mx_check_app_exist dockercompose || return
  
  # export var used in file:dockercompose  
  export exp_REGISTRY_FROM="${lREGISTRY_FROM}"
  export exp_IMAGE_REGISTRY_PATH_FROM="${lIMAGE_REGISTRY_PATH_FROM}"
  export exp_REGISTRY_DEST="${lREGISTRY_ORG}"
  export exp_IMAGE_REGISTRY_PATH_DEST="${lIMAGE_REGISTRY_PATH_DEST}"
  export exp_IMAGE_FROM="${lIMAGE_FROM}"
  export exp_IMAGE_NAME_DEST="${lIMAGE_NAME_DEST}"
  export exp_IMAGE_TAG_DEST="${lIMAGE_TAG_DEST}"
  export exp_IMAGE_PACKAGE="${lIMAGE_PACKAGE}"
  export exp_IMAGE_NAME_FOLDER="${lDOCKERFILE_PATH##*/}"

  # mx:info@debug
  echo
  echo " exp_REGISTRY_FROM            = $exp_REGISTRY_FROM"
  echo " exp_REGISTRY_DEST            = $exp_REGISTRY_DEST"
  echo " exp_IMAGE_REGISTRY_PATH_FROM = $exp_IMAGE_REGISTRY_PATH_FROM"
  echo " exp_IMAGE_REGISTRY_PATH_DEST = $exp_IMAGE_REGISTRY_PATH_DEST"
  echo " exp_IMAGE_FROM               = $exp_IMAGE_FROM"
  echo " exp_IMAGE_NAME_DEST          = $exp_IMAGE_NAME_DEST"
  echo " exp_IMAGE_TAG_DEST           = $exp_IMAGE_TAG_DEST"
  echo " exp_IMAGE_PACKAGE            = $exp_IMAGE_PACKAGE"
  echo " exp_IMAGE_NAME_FOLDER        = $exp_IMAGE_NAME_FOLDER"
  echo
  echo "image src     =  $lREGISTRY_FROM/$lIMAGE_REGISTRY_PATH_FROM/$lIMAGE_FROM"
  echo "image dst     =  $lREGISTRY_DEST/$lIMAGE_REGISTRY_PATH_DEST/$lIMAGE_NAME_DEST:$lIMAGE_TAG_DEST"
  echo "dockerfile in =  $lDOCKERFILE_PATH"
  echo

  # # mx:info@debug
  # return

  # build image
  local lLIST_FOLDER="tmp01 tmp02 tmp03 tmp04 tmp05 tmp06 final"
  for tFOLDER in ${lLIST_FOLDER}
  do
    # Check folder exists else skip it
    [ -d "${lDOCKERFILE_PATH}/$tFOLDER" ] || continue
    # mx:info@info
    echo "mx > info > build image in folder: $tFOLDER"
    # define cli
    local lCLI="docker-compose -f ${lDOCKERFILE_PATH}/$tFOLDER/docker-compose.yml build"
    # mx:info@info
    echo "mx > info > play cli > $lCLI"
    # play cli
    eval $lCLI
  done

  # unset all exported var - ie. starting with exp_
  unset $(compgen -v exp_)
  
  # # mx:info@debug
  # return

  # mx:info@info
  echo "mx > info > delete image@intermediate"


  for tFOLDER in ${lLIST_FOLDER}
  do
    # Check folder exists else skip it
    [ -d "${lDOCKERFILE_PATH}/$tFOLDER" ] || continue
    local lCLI="docker image rm ${tFOLDER/tmp/tmp/}/${lIMAGE_NAME_DEST}"
    # mx:info@debug
    echo "mx > info > play cli > $lCLI"
    # play cli
    eval $lCLI 2> /dev/null 
  done

  # clean
  docker image prune -f  
}



# cat -n <<< "$(compgen -W "${l_LIST_IMAGE_TYPE[*]}" | tr -d ',')"


# # args: lFILTER
# mmx_docker_image_list_some () {
#   # define var from input
#   lFILTER="$1"

#   # check filter exists
#   [ ! -z $lFILTER ] && {
#     echo
#     docker image list --filter "label=$lFILTER"
#   } || {
#     echo
#     docker image list -a
#   }
#   echo
#   docker container list -a
# }


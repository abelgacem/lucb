#purpose: containerized cli
mmx_old_cil_skopeo () { 
  # define var
  local lIMAGE=${gsIMAGE_SKOPEO}
  #
  luc_core_echo "info" "using skopeo image: $lIMAGE"
  docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock --network host $lIMAGE"$@" 
}

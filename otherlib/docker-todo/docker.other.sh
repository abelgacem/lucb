
# mmx_docker_system_delete_all() {
#   # confirm action
#   lMSG01="delete all docker object"
#   lMSG02="all docker object deleted"
#   read -p "mx > INFO    > $lMSG01 (y) ? " lUSER_INPUT && [ ! "y" == "${lUSER_INPUT}" ] && echo "done nothing" && return
#   echo "mx > INFO    > $lMSG02" 
#   docker system prune -af
# }

# noargs 

# noargs 
mmx_docker_delete_all() {
  # confirm action
  lMSG01="delete all docker object"
  lMSG02="all docker object deleted"
  read -p "mx > INFO    > $lMSG01 (y) ? " lUSER_INPUT && [ ! "y" == "${lUSER_INPUT}" ] && echo "done nothing" && return
  echo "mx > INFO    > $lMSG02" 
  docker system prune -af
  echo -e "\nlist of docker containers after delete\n"
  docker container list -a
  echo -e "\nlist of docker images after delete\n"
  docker image list -a
}


luc_docker_core_info() {
  luc_core_echo "purp" "display client and server info"

  luc_core_echo "info" "version"
  docker --version
  luc_core_echo "info" "docker compose"
  docker-compose --version
  luc_core_echo "info" "system info"
  docker system info
}
# purpose: list docker objects 
luc_docker_core_list() {
  luc_core_echo "purp" "list docker images and containers"
  luc_core_echo "info" "images"
  docker image list --all
  luc_core_echo "info" "containers"
  docker container list -a
}

luc_docker_core_registry_list() {
  curl -v -H "Accept: application/json" -H "Content-Type: application/json" -X GET "http://127.0.0.1:5001/v2/_catalog"
}

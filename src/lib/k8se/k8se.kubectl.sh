luc_k8se_node_kubectl_configure() {
  lpurpose="remote configure the CLI:kubectl on a set of NODEs of a cluster"
  largs="<CPLANE>"
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) $largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get) o1u" 
  local lNODE_CPLANE="$@"
  local lCLI_JOIN
  # local lFILTER_ECHO="use|already|init|warning|error"

  ###### PREREQUISIT
  # checkorexit args are provided
  [ -z "$lNODE_CPLANE" ] ||
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ##### ACTION 
  lPHASENAME="kubectl > configure"
  luc_core_echo "doin" "node: $lNODE_CPLANE"  
  lCLI="luc_k8se_kubectl_configure"
  lECHOVAL=$(luc_core_vm_cli_run "$lNODE_CPLANE" "bash -l -c $lCLI" 2>&1); lRETVAL=$?
  [ 0 -ne "$lRETVAL" ] && luc_core_echo "warn" "$lPHASENAME > $(echo "$lECHOVAL" | grep -Eiv ${lFILTER_ECHO:-yo})" || {
    [ -z "$lECHOVAL" ] || luc_core_echo "info" "$lPHASENAME > $lECHOVAL"
  }

  ###### RETURN
  return 0
}
luc_k8se_kubectl_configure() {
  lpurpose="provision kubectl configuration to request the API-SERVER"  
  largs="<NONE>"  
  local lMSG_PURPOSE="$lpurpose"  
  local lMSG_USAGE="$(luc_core_method_name_get) largs"  
  local lMSG_EXAMPLE="$(luc_core_method_name_get)" 
  local lFILE_CONF="${HOME}/.kube/config" 
    
  ###### PREREQUISIT
  # checkorexit args are provided
  [ "--help" == "$1" ] && luc_core_echo "purp" "$lMSG_PURPOSE" &&  luc_core_echo "usag" "$lMSG_USAGE" && luc_core_echo "exam" "$lMSG_EXAMPLE" && return 1

  ###### ACTION CREATE CONFIG FILE
  sudo cat /etc/kubernetes/admin.conf | install -D -m 600 /dev/stdin $lFILE_CONF
  sudo chown $(id -u):$(id -g) $HOME/.kube/config


  ###### RETURN
  return 0
} # function


# sudo cp -i /etc/kubernetes/tmp/kubeadm-init-dryrun2683583560/admin.conf $HOME/.kube/config
# kubectl get pods -n kube-system
# export KUBECONFIG=/etc/kubernetes/admin.conf



  # echo -e "
  # apiVersion: v1
  # clusters:
  # - cluster:
  #     certificate-authority-data: $(sudo cat /etc/kubernetes/pki/ca.crt | base64 -w0)
  #     server: https://51.210.10.195:6443
  #   name: kubernetes
  # contexts:
  # - context:
  #     cluster: kubernetes
  #     user: kubernetes-admin
  #   name: kubernetes-admin@kubernetes
  # current-context: kubernetes-admin@kubernetes
  # kind: Config
  # preferences: {}
  # users:
  # - name: kubernetes-admin
  #   user:
  #     client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURLVENDQWhHZ0F3SUJBZ0lJTFNsOW1ScGtNVTB3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBME1EUXhOREUxTXpSYUZ3MHlOakEwTURReE5ESXdNelJhTUR3eApIekFkQmdOVkJBb1RGbXQxWW1WaFpHMDZZMngxYzNSbGNpMWhaRzFwYm5NeEdUQVhCZ05WQkFNVEVHdDFZbVZ5CmJtVjBaWE10WVdSdGFXNHdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFDdVZ4dngKV3ptY2tCOFE2K1AzdFFiMi9sVk9ORXh0VndwY25qNnZKend1UmVQU0ZkblBsU2xpNGJ2Q0FmSUhlRlpQYmNONgpEQXJNdCtveUhGNlpjaFNmNHlMWDcrSENJbTJuV3MyQnYyYlpZeGhYUWV3NDNYWFBZRG5KcHN5a2pIaFVobXVnCmV2VG80amdPcThFWmsrRjU2dCt5RjgzZk5wSzRHKzUxM2pzc2tMYkpYMlBRbUZyS1FZdks2clQ1V2VjYk1iY0sKNENLRmszcURxRUVsU3RzR1FQVGVPUlBuL0sxVTRMTUFIelBSTk1VZy9mSDFhSDViKytRSVhyTC9kbnFiOUM4TApNRmU1bjhkOTM5aWlhVm5qZkpkZXM3RnZ0S3FFUktnTUdlWThZb3ExTzY0cW0zYmo4dHlvQUd5WXUxM2NpSlBuCk52SlU2Skh4ejZCdGZWVXZBZ01CQUFHalZqQlVNQTRHQTFVZER3RUIvd1FFQXdJRm9EQVRCZ05WSFNVRUREQUsKQmdnckJnRUZCUWNEQWpBTUJnTlZIUk1CQWY4RUFqQUFNQjhHQTFVZEl3UVlNQmFBRlB4MlE5WHFNSk1tMlB5bwpBNVpSRXVac3BYSFlNQTBHQ1NxR1NJYjNEUUVCQ3dVQUE0SUJBUUJDc2lGbU4vQUd4bWdjbjRMbzJ2TnlhcGN6CmZqeERZSlE4eG1zTndDa1FTWUJocXhRVG82QUsyelNqNloxZWdhcjM4aUVKZ3BPU0V1dFJPV1Jjc1g0ejNzSFgKdHBtVWkyMmN2N0tTc0MwZFpPM2dzaVBFV1pCUmxuSEhNQWxCcThod3VDTEp5SnAwSVRQWEYvdzIwNnBYYVVOTApGTHVySnJtMlN0RUZkaENZR2wzUG5icjMyQ1pvWmN2ckZqSE4zbDNRL0Ewd1NwL3dxWENNcEgrWVlPaHk2VVlGCjFLNXc1YzA4c3ZuaU1CYUNKS0JSYlh0cU04ekc4SHpQN0JGaFIxWVNVWVlWU2UvSVlmMFdsanV6elA2VUJuM2oKTWgwSzBiZUJrT2lUU252Z2ZyR1lrUEtMaFI5bzVPOXM3bUViNzlGVEwydEF5akpoTjNxVjFCM1RYYzFaCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
  #     client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBcmxjYjhWczVuSkFmRU92ajk3VUc5djVWVGpSTWJWY0tYSjQrcnljOExrWGowaFhaCno1VXBZdUc3d2dIeUIzaFdUMjNEZWd3S3pMZnFNaHhlbVhJVW4rTWkxKy9od2lKdHAxck5nYjltMldNWVYwSHMKT04xMXoyQTV5YWJNcEl4NFZJWnJvSHIwNk9JNERxdkJHWlBoZWVyZnNoZk4zemFTdUJ2dWRkNDdMSkMyeVY5agowSmhheWtHTHl1cTArVm5uR3pHM0N1QWloWk42ZzZoQkpVcmJCa0QwM2prVDUveXRWT0N6QUI4ejBUVEZJUDN4CjlXaCtXL3ZrQ0Y2eS8zWjZtL1F2Q3pCWHVaL0hmZC9Zb21sWjQzeVhYck94YjdTcWhFU29EQm5tUEdLS3RUdXUKS3B0MjQvTGNxQUJzbUx0ZDNJaVQ1emJ5Vk9pUjhjK2diWDFWTHdJREFRQUJBb0lCQVFDSFBGRVRudlVJcW84KwpuQTBCT0M2SDUvQWFNdDFhTDV0OURzK0hKTU05RGIvVVZsalgrbGZaT1V0aENndEptaUl4aU82S1BNOGYwRVpkCnlyM2kvNmhhQW1JajZSTlJlVTFmOVVMV3M3Yy9SK3c0dTQxVzZ3c1k2d2JJa3BmSnlLRUt5QjZ5cE01WDNDc3AKemplQzlNQ0J4eHp3MUNCQlZ0N202OXZGR0xjRU1KR0paU1VadVRLNWZ5ejdvN0dNTkZNSVJtbVJvQ1RuZmpPLwprbktkZXAvSFYyRU1aMSt1eDc4ODVCdmV4dlB1eGJIVXp0eEc2bTFxV3owZWpub3Z5emw3MFZ6MDlRYVlpSVgxCkJ1M3JrMmhENHVKeWVmell4M3NvRGY2QWpndVE1QWZOWlN3R1JUSVVTQzNhdFVGdDVlOVQzR2tNM2xSZjBCMVgKNXk5RW1SVVJBb0dCQU5rVXpCVVFjTXV5Rm1mZzMzdUF3WmhueDF4bm9hNVJtVXE0aE1hSGgrZnZhWkJEeWtWVQpnQVMzdXhHZXhUeW9GcXo5ZnlMamFsKzV3OGRUQXhFaHpqRWlkeHExanI2L25kdkc0dDFtR0dweStML0NLbWQ1CmhFayt6RU8rY0FoNGJqTjh6Y2ZCZTVWOStmazZjMFh1RVNlbnU1WlZ5cjJpODRyVS9nMTV6ZEJuQW9HQkFNMlkKcWdRaDJjWjJwMlljQmxxaHRreURKL1E5MDR4ZkJ1ZlpmVVpRMlp2aTJodzhmQklQRFFSY2M1cTZpM0FMUmRmVQppRFIrMkl2dlJ2bWl3MXZsLzl5TURRdlh1b3Z6a2o4ZVRSNnNvWHk1aUMwaGlETVhOMnpjWVNPZ2lJakxGNUp3CktpSHFVY1IwcTQzdXJtdldGMGl1NnZmdWhBc3JocytDSFRyRWpMZjVBb0dCQUpQbVNvRlRlVFllK0lyL3QrT2kKUHNSQ2VKNnBjSXVleHEwVStFbDJ6NDZqSEM0Uk1iOTRxZHdNL2VRc1l6OUhXbU8wTnFtamZiY0lqcTNBRGdmZgpHMmQ0anVOZ3JZZWliNy9zU21jRGgwRUhZaGpzQmc0SHlheEpuOHZMOVBLZ2NweWJ2R3dMazlLdlNOK1lCaSt2CjJucEZHbFo3enl6UzE5RlArbU5lQ0c2akFvR0FYMkkxZG9kUjVyNkR1VjdGSCtVb2syVEI4NUYvaFA5TlQrRmEKT25ZbUR5bDI4V1NxVnlKK2NvaUY1Y0lvRU1wYUUrRDVkQWxwWTdxV0hoa0NNNitJUGdVSHhIZkloMGR3a1RINApxNE9CeEVDN1Nkemx1SFpMODRobTFNV1Vzb291bkhUSFIwYlR1cVk2TlRZSDIrWE9sWno1VEI5dlNWTmZUd1JaCmxUczg0ZGtDZ1lCOEQ4NHRqamh4VlZSQWtkZXo2VFZCeVFQQ0R0aERXU0ttR0lQK0JMRS9WYVJ1bVNodXArcmgKOU5xQk8za2F1RzRyeFM2YzMrbDBDTWhFdmNIcDlwcjdUampvcWpvY1ZuRERvd01sTVV5NVg4TFMyUXlnVjlvSwpHT2hFbkNyYStjUjZjNjUxT0t2ZTNVSytQYUN2cnlrQ0QraGM5V3Rhb1AvNTNESFJTN3pHS2c9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=
  # " | sed '/^$/d' | sed 's/^  //' |  install -D -m 600 /dev/stdin $lFILE_CONF > /dev/null



# kubectl create deployment test-nginx --image=nginx
# kubectl expose deployment test-nginx --port=80
# kubectl expose deployment test-nginx --port=80 --type=NodePort
# kubectl expose deployment test-nginx --port=80 --type=LoadBalancer
# kubectl get svc test-nginx    # get the assigned NodePort
# kubectl get svc test-nginx -w # get the assigned external IP
# kubectl run test-client --image=busybox --rm -it -- sh

# Inside the pod:
# # wget -qO- test-nginx

# Outside the pod with NodePort
# curl http://<NODE_PUBLIC_IP>:<NodePort>
# curl http://vps-9c33782a:32456 # If nodes are behind a firewall, allow traffic on the NodePort.

# Outside the pod with loadbalancer
# curl http://<EXTERNAL-IP>

# kubectl port-forward svc/test-nginx 8080:80
# curl http://localhost:8080
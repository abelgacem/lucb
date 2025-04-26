# purpose: Provision the container Runtime
# args: <cplane_vm_name> <worker_vm_name>
# args: <yaml file>
luc_k8se_cni_flannel_provision() {
  kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
} # function

# check
# kubectl get pods -n kube-system
# conf > /etc/cni/net.d/

# purpose: Provision the container Runtime
# args: <cplane_vm_name> <worker_vm_name>
# args: <yaml file>
luc_k8se_sysctl_calico_provision() {
  kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
} # function

# check
# kubectl get pods -n kube-system
# conf > /etc/cni/net.d/
# ls /etc/cni/net.d/
# 10-calico.conflist

# Calico, Cilium, Flannel, Weave, Multus.

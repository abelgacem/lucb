# define var sLIB if folder name differs
lLIB="k8se"
# define this var
lDESC="manage (ie. create) a kubernetes cluster"

# define envar
export luc_EV_K8SE_LUC_HOME_SRC="$luc_EV_LUC_CORE_HOME"
export luc_EV_K8SE_LUC_HOME_DST="/tmp/luc"
export luc_EV_K8SE_LUC_SETUP_RELPATH="$luc_EV_LUC_CORE_BOOT_RELPATH"

# env standard
# export luc_EV_K8SE_NODE_CPLANE="o3r"
# export luc_EV_K8SE_NODE_LIST="o1u|o2a"
export luc_EV_K8SE_NODE_LIST="o1u|o2a|o3r|o4d"
export luc_EV_K8SE_NODE_LIST="o1u|o2a"
export luc_EV_K8SE_NODE_CPLANE="o1u"
export luc_EV_K8SE_NODE_WORKER="o2a"

# Name
export luc_EV_K8SE_NAME="myk8se"
# Version
export luc_EV_K8SE_VERSION="1.32.0"
export luc_EV_K8SE_VERSION_KUBEADM="$luc_EV_K8SE_VERSION"
export luc_EV_K8SE_VERSION_KUBELET="$luc_EV_K8SE_VERSION"
export luc_EV_K8SE_VERSION_KUBECTL="$luc_EV_K8SE_VERSION"
export luc_EV_K8SE_VERSION_CR="${luc_EV_K8SE_VERSION%.*}"
export luc_EV_K8SE_VERSION_HELM="3.17.3" # for k8s 	1.32.x - 1.29.x
# HELM
export luc_EV_K8SE_HELM_VERSION="$luc_EV_K8SE_VERSION_HELM"
export luc_EV_K8SE_HELM_ARCH="linux-amd64"
export luc_EV_K8SE_HELM_URL="https://get.helm.sh/helm-v${luc_EV_K8SE_HELM_VERSION}-${luc_EV_K8SE_HELM_ARCH}.tar.gz"
# K8S COMPONENTS
luc_EV_K8SE_K8s_VERSION="${luc_EV_K8SE_VERSION%.*}"
# OS SERVICES
export luc_EV_K8SE_OS_SERVICE_CRIO="crio"
export luc_EV_K8SE_OS_SERVICE_KUBELET="kubelet"
# OS PACKAGES REPOSITORY
export luc_EV_K8SE_K8S_OS_PACKAGE_REPOSITORY="k8se-kubernetes"
export luc_EV_K8SE_CRIO_OS_PACKAGE_REPOSITORY="k8se-crio"
# KERNEL MODULES AND PARAMETERS
export luc_EV_K8SE_OS_SYSCTL="99-k8se-k8s"
# CR
export luc_EV_K8SE_CR_VERSION="$luc_EV_K8SE_VERSION_CR"
export luc_EV_K8SE_CR_NAME="crio"   # other is containerd
export luc_EV_K8SE_CR_SOCKET="unix:///var/run/crio/crio.sock" # other is containerd
# CNI
export luc_EV_K8SE_CNI_URL_CALICO="https://docs.projectcalico.org/manifests/calico.yaml"
# export luc_EV_K8SE_CNI_URL_CALICO="https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml"
export luc_EV_K8SE_CNI_URL_CALICO="https://docs.projectcalico.org/manifests/calico.yaml"
export luc_EV_K8SE_CNI_URL_FLANNEL="https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml"

##### RETURN
return 0











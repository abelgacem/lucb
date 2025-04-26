# define var sLIB if folder name differs
lLIB="containerd"
# define this var
lDESC="manage containerd"


export luc_EV_CONTAINERD_CONFILE="/etc/containerd/config.toml"


##### RETURN
return 0

# Todo
# [plugins."io.containerd.grpc.v1.cri"]
# sandbox_image = "registry.k8s.io/pause:3.10"
# [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
#   ...
#   [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#     SystemdCgroup = true
## sudo systemctl restart containerd

# Folder > content

## List
|Name|Tag|Desc|
|-|-|-|
|Vm||<li>Update > Repo.Yum</li><li>Provision > Package.Yum.Basic</li><li>Provision > File:/etc/profile.d From Scracth</li>
|User||<li>Provision > User.(Sudo, Ssh)</li>
|User.Git||<li>Provision > Package.Yum:Git</li><li>Configure > User:(Key:Git, Git:Alias)</li>|
||Kubectl|kubectl get nodes|
|Kubernetes|Cluster:Cni|kubectl get nodes|
<br>

## Howto

```bash
# Prepare > Vm
mxp vm.linux o1c bootstrap vm

# provision > User.(Sudo, Ssh)
mxp vm.linux o1c bootstrap user mxadmin

# provision > User.Git
mxp vm.linux o1m bootstrap user.git
```

# Step
- Bootstrap > in >Order

|Name|Desc|Test|
|-|-|-|
|Kubernetes|Master|
|Cluster|Kubernetes|
|Kubernetes|Kubectl|kubectl get nodes|
|Kubernetes|Cluster:Cni|kubectl get nodes|
<br>

# Step
```bash
# Install > Master : Tool
mxp vm.linux o1c bootstrap kubernetes master     mxadmin

# Create > Cluster 
mxp vm.linux o1c bootstrap cluster    kubernetes mxadmin

# Install > Kubectl > on > any > Vm
mxp vm.linux o2c bootstrap kubernetes kubectl    mxadmin
```

# Follow > Install
```bash
# On > Master
journalctl -u containerd -f
```
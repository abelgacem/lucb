# [&larr;][Back_Readme] Domain > It > Vm > Provision.Shell

See Also
|Name|Tag|Description|
|--|--|--|
|Ssh|[Whatis][Ssh_Whatis]|
|Vm|[Whatis][Vm_Whatis]|
<br>


# Semantic

- 1 > File      > Denote > Action:Provision
- 1 > File.Name > Denote > Action:Provision.Type



# Toknow
o3c
  - Denote > 1 > Entry, Object > in > ~/.ssh/config > That > denote > 1 
    - Ip
    - Vm.Remote:User > That > Is > sudo
  - Have
    - Key.Priv > on > Local (in ~/.ssh/)  
    - Key.Pub > on > remote

# Prerequisite
o3c > exists


# Howto > Provision > File.Root : Alias.Global

## Step



```bash
# Define > Var.Local
MxCodeFilename="provision.alias.sh"
MxCodeFolder="/usr/local/etc/git/provision/shell/provision.vm.linux"

# Copy > File:This > to > Vm.remote.Linux:/tmp
rsync ${MxCodeFolder}/${MxCodeFilename} o3c:/tmp

# Ssh > to > Vm
ssh o3c

# Define > Var.remote
MxCodeFilename="provision.alias.sh"
MxCodeFolder="/tmp"

# Play > File:This > from > Vm:/tmp
${MxCodeFolder}/${MxCodeFilename}
```


# Howto > Provision > Folder.Home
## Step
```bash
# Define > Var.Local
MxCodeFilename="provision.folder.home.sh"
MxCodeFolder="/usr/local/etc/git/provision/shell/provision.vm.linux"

# Copy > File:This > to > Vm.remote.Linux:/tmp
rsync ${MxCodeFolder}/${MxCodeFilename} o3c:/tmp

# Ssh > to > Vm
ssh o3c

# Define > Var.Remote
MxCodeFilename="provision.lib.folder.home.sh"
MxCodeFolder="/tmp"
# Play > File:This > from > Vm:/tmp
${MxCodeFolder}/${MxCodeFilename}
```

# Howto > Provision > File.Home.Lib.Mx.Git

# Prerequisite
o3c:Folder.Home:.mxlib > exists

## Step

```bash
# Define > Var.Local
MxCodeFilename="provision.file.lib.mx.git.home.sh"
MxCodeFolder="/usr/local/etc/git/provision/shell/provision.vm.linux"

MxLibFilename="git.lib.sh"
MxLibFolder="/usr/local/etc/git/code/lib/bash"

# Copy > File:This > to > Vm.remote.Centos.7:/tmp
rsync ${MxLibFolder}/${MxLibFilename} o3c:/tmp
rsync ${MxCodeFolder}/${MxCodeFilename} o3c:/tmp

# Ssh > to > Vm
ssh o3c

# Define > Var.Remote
MxCodeFilename="provision.file.lib.mx.git.home.sh"
MxCodeFolder="/tmp"

MxLibFilename="git.lib.sh"
MxLibFolder="/tmp"

# Play > File:This > from > Vm:/tmp
${MxFolder}/${MxFilename}
```

# Todo > Order
Provision
- Package.Base
- Package.Git
- Conf.Sshd
- Conf.Sudo
- Alias.Global
- Var.Etc
- Folder.Home
- Var.User
- Lib.Git
- Lib.User
- Conf.Git
- Key.Git
- Conf.Ssh
- Bashrc



[//]: #(Reference.Readme)
[Back_Readme]:         ../readme.md (List > Folder)

[Ssh_Whatis]:         ../../../topic/epi/topic/ssh/whatis/ssh_whatis.md
[Vm_Whatis]:          ../../../topic/epi/whatis/vm_whatis.md

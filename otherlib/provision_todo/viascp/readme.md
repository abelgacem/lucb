# [&larr;][Back_Readme] Folder : Content

Repo > of > Code.Bash

# Folder : Member
|Order|Name|Tag|Description|
|-|-|-|-|
|1|Os : Update||Update, Upgrade|
|2|Var.Global||/etc/profile.d|
|3|Var.User||$HOME|
|4|User : Folder||$HOME, Folder|
||Key.Priv.Ovh||$HOME, Secret|
||Tool : Git||Tool|
||Tool : Podman||Tool|
||Tool : Docker||Tool|
||Tool.Basic||Tool, Basic|
||Conf : Git||Conf, Git|
||Conf : Ssh||Conf, Git|
||Conf : Docker||Conf, Docker|
<br>


# Process
## Generic
- Copy > file > to > Vm:/tmp
- Play > file
## Specific
- For > Key.priv > First > copy > key > to > Vm:/tmp

# Tool
```bash
# Define > file > to > Scp
FilePath="..."

# Local > Scp > File
for tVm in o1u o2c; do scp ${FilePath} ${tVm}:/tmp; done

# Remote > Play > File
/tmp/FileName
```



[//]: #(Reference)
[Back_Readme]:           ../readme.md         "Home > Repository.Git"

[Bash_Whatis]:            /../topic/ep/docker/whatis/dockerfile_whatis.md "Whatis > Bash"
[Library_Whatis]:         /../topic/ep/docker/whatis/docker_whatis.md    "Whatis > 1 > Library"

# [&larr;][Back_Readme]Provision

# Whatis
|Verb|Noun|
|-|-|
|Is1|Project.Bash 
|AllowTo > Provision|Vm.Linux
# Howto > Start  
## Install > App > on > 1 > Vm   
|Action|||Comment|Howto|
|-|-|-|-|-| 
|**Git:Clone**|**Project.Git:Abtit:Code**| 
|<li>Copy</li>|File.Lib|git.lib.sh| to Remote:/tmp|scp 
|<li>Source</li>|File.Lib|/tmp/git.lib.sh|on > Remote
|<li>Play</li>|Cli|mx-git-clone abtit code|on > Remote
|**Bash:Source**|**Project.Sub > Provision**|
|<li>source</li>|File|${HOME}/debug/git/code/project/provision/init.sh|on > Remote
|**Provision**|**User:Var**|
|<li>Play</li>|Cli|mxp local var user|on > Remote
|<li>Source</li>|File|${HOME}/debug/var/mx.var.sh|on > Remote
|**Provision**|**User:Home:Tree**|
|<li>Play</li>|Cli|mxp local user folder|on > Remote
|<li>Source</li>|File|${HOME}/debug/var/mx.var.sh|on > Remote
|**Install**|**Secret:Key.Priv**|
|<li>Copy</li>|File.Key.Priv|key.ssh.priv.vm.ovh| to > Remote:/tmp| Scp
|<li>Play</li>|Cli|mxp local key private ovh|on > Remote
|**Configure**|**Ssh:Client**|
|<li>Play</li>|Cli|mxp local conf ssh|on > Remote

## Install > App > on > Another > Vm
|Action|||Comment|Howto|
|-|-|-|-|-| 
|**Git:Clone**|**Project.Git:Abtit:Code**| 
|<li>Copy</li>|File.Lib|git.lib.sh| to Remote:/tmp|scp 
|<li>Source</li>|File.Lib|/tmp/git.lib.sh|on > Remote
|<li>Play</li>|Cli|mx-git-clone abtit code|on > Remote
|**Bash:Source**|**Project.Sub > Provision**|
|<li>source</li>|File|${HOME}/debug/git/code/project/provision/init.sh|on > Remote
|**Provision**|**User:Var**|
|<li>Play</li>|Cli|mxp local var user|on > Remote
|<li>Source</li>|File|${HOME}/debug/var/mx.var.sh|on > Remote
|**Provision**|**User:Home:Tree**|
|<li>Play</li>|Cli|mxp local user folder|on > Remote
|<li>Source</li>|File|${HOME}/debug/var/mx.var.sh|on > Remote
|**Install**|**Secret:Key.Priv**|
|<li>Copy</li>|File.Key.Priv|key.ssh.priv.vm.ovh| to > Remote:/tmp| Scp
|<li>Play</li>|Cli|mxp local key private ovh|on > Remote
|**Configure**|**Ssh:Client**|
|<li>Play</li>|Cli|mxp local conf ssh|on > Remote

[//]: #(Reference)
[Back_Readme]:           ../README.md                   (Home > Topic)

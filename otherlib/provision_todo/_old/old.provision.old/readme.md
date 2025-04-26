# [&larr;][Back_Readme] Provision > Vm

Todo, Attention
- High Dependency between
  - Script
  - Script and Doc

# Folder > Purpose
Provide > Method.Bash > that
  - call > Code.(Script, Bash) > that > (is used to, allow to) > provision > Vm 
  - provide Autocomplete
# Member
|Name|Tag|Description|
|-|-|-|
|provision.sh|Bash, Code|-|
|provision.env.sh|Bash, Env|Dependency for provision.sh|

# Prerequiste
  
# Howto > Use > What > Exists

|StepId|Verb|Noun|Description|
|-|-|-|-|
|[01](#01)|Source|file : provision.sh||
|[02](#02)|Play|Cli : mx-vm-provision[tab][tab]||

# Howto > Add > Script.Wrapped

|StepId|Verb|Noun|Description|Comment|
|-|-|-|-|-|
|[01](#01)|Create|Folder : provision.xx||Copy/Past existing|
|[02](#02)|Update|File : [provision.env.sh][File_env]||Add Otp to Var: gvOtpxx|
|[02](#02)|Update|File : [provision.sh][File_script]||Add Otp in Method:Case|

# Terminoogy

|Name|Tag|Description|
|-|-|-|
|Otp|Acronyme|Object To Provision|
  

[//]: #(Reference.Readme)
[Back_Readme]:         ../readme.md (List > Folder)

[File_env]:            ./provision.env.sh
[File_script]:            ./provision.sh
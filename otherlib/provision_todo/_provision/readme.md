# [&larr;][Back_Readme] Provision > Vm

See Also
|Name|Tag|Description|
|--|--|--|
|Otp|[Whatis][Otp_Whatis]|
<br>


# Toknow
- Provision is IDEMPOTENT as defined by Ansible. Example
```
  - Create  > folder, file, user, ... > only > if > not > exist
  - Update  > folder, file, user, ... > only > if > it > exists
  - Read    > folder, file, user, ... > only > if > it > exists
```
# Todo, Attention
- High Dependency between
  - Script
  - Script and Doc

# Folder > Purpose
Provide > Method.Bash > that
  - provision
    - Vm.Windows (Todo)
    - Vm.Linux
    - Container.Linux
  - provide Autocomplete
  - call > Code.(Script, Bash) > that > (is used to, allow to) > provision > Vm 
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

[Otp_Whatis]:          ../toto/otp_whatis
[File_env]:            ./provision.env.sh
[File_script]:         ./provision.sh
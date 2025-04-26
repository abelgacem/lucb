# [&larr;][Back_Readme] Provision >  Vm:Base


# Purpose
Script > to > Provision > 1 > Vm.(Ovh, Remote) > with
  - 1 user that can
    - Sudo
    - Ssh to Vm.Ovh
    - Clone repo.Git from Github.Personal
  - 1..N Package.Basic
  - 1..N Lib.Custom (e.g Git)
  - Alias.BAsh

# Prerequiste
- [Only] Create > 1 > Vm > via > Ovh
# Howto

|StepId|Verb|Noun|Description|
|--|--|--|--|
|[01](#01)|Update|file : provision.env.sh||
|[02](#02)|Play|script : provision.vps.sh||

# Postrequisite.Check
  - User can SSh to Vm
  - Into Vm
    - User can sudo
    - Alias are available
    - cli: wget, tree, ... exist


# Work/Test on
- Vm.Ovh with centos : v7.9 

# Todo
- standardize naming for Ssh Key.pub in script

[//]: #(Reference.Readme)
[Back_Readme]:         ../readme.md (List > Folder)


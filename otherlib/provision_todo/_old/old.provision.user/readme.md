# [&larr;][Back_Readme] Provision >  Vm:User


# Purpose
Script > to > Provision > 1 > Vm.(Ovh, Remote) > with
  - 1 user that can
    - Sudo
    - be > sshed > from > remote (that have private key)

# Prerequiste
- Create > 1 > Vm > via
  - Ovh | Vmware
- Have > Access.Ssh > to > this > Vm > with > 1 User that is granted Sudo
# Howto

|StepId|Verb|Noun|Description|
|--|--|--|--|
|[01](#01)|Update|file : provision.env.sh||
|[02](#02)|Play|script : provision.vps.sh||

## Step 02
- source Lib.Git
- play script

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


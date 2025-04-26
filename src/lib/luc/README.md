[//]: #(Reference)


# Introduction
when sourcing Bash libraries, 2 class of core LUC objects get available:
- Environment variales
- Bash functions

# Core environment variables
|name|description|
|-|-|
|luc_EV_LUC_CORE_HOME|home of LUC when installed locally
|luc_EV_LUC_CORE_HOME/lib|Root directory of LUC libraries (both core and custom)
|luc_EV_LUC_CORE_HOME/bin|Root directory for LUC binaries
# Core Bash functions
|name|description|
|-|-|
|luc_core_resetluc|unsource all LUC objects (core and custom)|
|luc_core_setluc|source all LUC objects (core and custom)
|luc_core_os_xxx|deal with OS objects
|luc_core_check_cli_is_installed
|luc_core_echo|
|luc_core_install|
|luc_core_method_name_get|
|luc_core_object_list|

# Usage
## list all objects
```shell
luc_core_object_list
```

## unsource objects
```shell
# unsource all objects
luc_core_resetluc

# unsource docker objects
luc_core_resetluc docker

# unsource core os objects
luc_core_resetluc core_os
```

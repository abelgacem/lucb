[//]: #(Reference)
[repo_theme]:      https://github.com/abelgacem/topix-jk-theme-01
[ip_public]:       https://abelgacem.github.io/project/
[url_jekyll]:      https://jekyllrb.com
[url_githubpages]: https://pages.github.com
[doc_contribute]:  ./CONTRIBUTING.md
[doc_changelog]:  ./CHANGELOG.md
[env_local]:      ./env/README.md#env-local
[bats_git]:       https://github.com/bats-core/bats-core
[luc_object]:     ./src/lib/luc/README


# LucB
Welcome to Luc (the **L**inux **U**niversal **C**LI). The CLI of CLIs that runs in any Linux<sup>1</sup> computer, VM or container.

[![LICENSE](https://img.shields.io/badge/license-GNU_GPL_v3.0-green.svg)](https://choosealicense.com/licenses/gpl-3.0/)


# The Idea behind
- CLI (eg. aws, openstack, jekyll, ...) are now a jungle of options that in fact mimics/reflects API requests
- In everyday life we use only 20% of what the tool CLI allows or provides.
# Capabilities
- Allows to integrates only customized options of these **TOO** versatile CLIs
- Provides a simple extendable **Bash** library that can be used in everyday usage for developpers, devops, architects, ...

# Folder's content
|name|type|description|comment|
|-|-|-|-|
|`src`|folder|application's source code|
|`test`|folder|code to test the application changes|

- The project is written in BASH.
- Tests are done with [BATS][bats_git].


# What's new
see the [Changelog][doc_changelog]

# How to contribute
see the [contributing guide][doc_contribute]


# Test LUC
`git clone` this repository
```shell
# create a folder in your home
mkdir -p ~/wkspc/git

# clone the repo
cd       ~/wkspc/git
git clone https://github.com/abelgacem/luc-bash.git
```

- `source` the `BASH` librairies
- this will install nothing
- It will  **only** source some `BASH` scripts containing functions and environment variables
```shell
source ~/wkspc/git/luc-bash/src/setup/srclib
```

Launch a LUC CLI
```shell
# type
luc (press tabulation for completion)
```

# [Un]Install  LUC
```shell
# install - create the file /etc/profile.d/luc.rc.sh
luc_core_install

# uninstall - delete the file /etc/profile.d/luc.rc.sh
luc_core_install
```


## Unsource the environment
- this will, **just**,  uninstall LUC objects from the SHELL environment
```shell
# type
luc_core_resetluc
```


# List of core LUC objects
when sourcing the bash libraries, the SHELL evironment offers a set of LUC functions and environment variables. The complete ste of available objects is documented [there][luc_object]

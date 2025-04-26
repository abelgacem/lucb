[//]: #(Reference)
[repo_theme]:      https://github.com/abelgacem/topix-jk-theme-01
[ip_public]:       https://abelgacem.github.io/project/
[url_jekyll]:      https://jekyllrb.com
[url_githubpages]: https://pages.github.com
[doc_contribute]:  ./CONTRIBUTING.md
[doc_changelog]:  ./CHANGELOG.md
[env_local]:      ./env/README.md#env-local
[bats_git]:        https://github.com/bats-core/bats-core


# Script srclib
## purpose
- source a set of files below a root folder

## Requirements/Constraints
- the files to be sourced **must** be in the root folder or in a subfolder
- The script **shoud** 
  - be idempotent.
  - works in all linux familly (ie. alpine, ubuntu, rocky)

## Process
1. get the path to this folder
1. list files ending with a specific string (ie. '_env.sh' in this case)
1. source each file
1. if source is 
   - ok => source all files starting with the same prefix
   - ko => skip to next file



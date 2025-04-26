#!/bin/bash

# Section.Description
## (Var, Method).Global > Accessible > To > Method.Bash, Shell.Interactive

# Section.Toknow
## This > File          > Must   > Be > Sourced > At > (Os, Shell):boottime
## This > File:Location > Should > Be > /usr/local/etc/vmvar/
## Ssh
export gvListVmRemote="o1d o2d o3d"
## User.Os
export gvOsUserVmAdminName="vmadmin"
export gvOsUserDockerName="${gvOsUserVmAdminName}"
## Fs.Folder
export gvGitFolderRoot="/usr/local/etc/repogit"
## Git Repo
export gvGitApi="api.github.com"
export gvGitRepoEnv="env"
export gvGitRepoConf="conf"
export gvGitRepoBash="bash"
export gvGitRepoDockerfile="docker/dockerfile"
export gvGitRepoDockercompose="docker/dockercompose"
## Git Repo:Abtit
export gvGitAbtitRepoName="abtit"
export gvGitAbtitFolder="${gvGitFolderRoot}/${gvGitAbtitRepoName}"
## Git Repo:Omt 
export gvGitOmtRepoName="omt"
export gvGitOmtFolder="${gvGitFolderRoot}/${gvGitOmtRepoName}"
export gvGitOmtBranchWork="Dev"
## Docker
export gvDockercomposeName="dc.yml"
export gvDockerfileName="dockerfile"
export gvDockerDcfScriptName="res.sh"
export gvDockerOsUserName="${gvUserVmAdmin}"
export gvDockerOsUserPwd="${gvUserVmAdmin}"
export gvDockerPrefixImage="mxi"
export gvDockerRepoOmtName="abelgacem/omt"
export gvDockerPrefixApp="mxa"
## Deploy
export gvDeployRepoProfiledRoot="/etc/profile.d"
export gvDeployRepoVmvarRoot="/usr/local/etc/vmvar"
#export gvDeployEnvName=""
## Tool.Global
function echo_h1     { echo -e "\033[95m\033[1m  > ${*} \033[0m"; }
function echo_h2     { echo -e "\033[32m >> ${*} \033[0m"; }
# function echo_h3     { echo -e "\033[36m  >>> Check > ${*} \033[0m"; }
function echo_check  { echo -e "\033[36m  >>> Check > ${*} \033[0m"; }
function join_by     { local IFS="$1"; shift; echo "$*"; }
function list_var    { egrep -o "\\$\{.*\}" $1 | cut -d: -f2 | egrep -v "\\$\{\*\}" | egrep -v "\\$\{FUNCNAME\}" | tr "/" "\n" | egrep  "\\$"; }
function get_os   { 
  # Works for Mac, Ubuntu, Debian, Centos
  lvOsSignature="$(uname -v | cut -d' ' -f1 | cut -d- -f2)"
  case "$lvOsSignature" in
              "Darwin") lvUserNotRoot="mac" ;;
                     *) lvUserNotRoot="$(cat /etc/os-release | grep -i ^id= | tr -d '"' | cut -d'=' -f2)" ;;
  esac    
  echo ${lvUserNotRoot}
}
function get_dockersudo   {
  lvCmdPrefix=""
  lvUserCurrent=$(id -un)
  # Is user in group docker
  [ "mac" != "$(get_os)" ] && [ ! $(groups $(id -un) | grep -w -o docker) ]  && lvCmdPrefix="sudo -u ${gvOsUserDockerName}"
  echo ${lvCmdPrefix}
}
# 0 = True , 1 = False
# Error   = Non-Zero
# NoError = Zero
function check_folder   {
  lvFolder=${1}
  [ ! -d  ${lvFolder} ] && {
    echo_check "Mx > Error > Folder Not Found > ${lvFolder}"
    return 1
  }
  return 0  
}

# Method are accessible inside Method Like Var & Alias
export -f echo_h1
export -f echo_h2
export -f echo_check
export -f join_by
export -f list_var
export -f get_os


#!/usr/bin/env bats

# Load dependency
source $(dirname $BATS_TEST_FILENAME)/../../srcm

# description: BATS sdef function - called, before each test
function setup() {
  expose_all_bats_helper_method
  expose_method luc/luc.core.sh
}


@test "01 - luc_core_echo - nominal usecase" {
  run luc_core_echo "unknow" "a message"
}

@test "02 - luc_core_echo - nominal usecase - bug to solve cf. core.echo:01" {
  run luc_core_echo "unknow" "a message"
  # expected RETVAL
  [ "$status" -eq 0 ]
  # expected ECHO
  lMSG=$(echo "unknow > a message" | tr -d "\n")
  [ "$output" = "$lMSG" ]
}

@test "03 - luc_core_echo - no input - display usage" {
  run luc_core_echo
  # expected RETVAL
  [ "$status" -eq 1 ]
  # expected ECHO
  lMSG="usage: [info|done|warn|caut|debu] [message]"
  [ "$output" = "$lMSG" ]
}


  # echo output et -$output
  # echo status et -$status-

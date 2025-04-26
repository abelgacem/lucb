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
  # expected RETVAL
  [ "$status" -eq 0 ]
  # expected ECHO contains the following substring
  assert_line --partial 'unknow'
  assert_line --partial 'message'
}

@test "02 - luc_core_echo - no input - display usage" {
  run luc_core_echo
  # expected RETVAL
  [ "$status" -eq 1 ]
  # expected ECHO
  lEXPECTED_OUTPUT="usage: [info|done|warn|caut|debu] [message]"
  assert_output "${lEXPECTED_OUTPUT}"
}

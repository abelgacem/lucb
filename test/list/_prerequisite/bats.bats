#!/usr/bin/env bats

@test "01 - prerequisite - bats - CLI exits and output version 1.11.1" {
  # define var
  local lCLI_PARAM_VERSION="1.11.1"
  local lCLI_TO_TEST="bats --version"
  ## define expected
  local lEXPECTED_OUTPUT="Bats $lCLI_PARAM_VERSION"
  local lEXPECTED_RETVAL="0"
  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # test expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # test expected OUTPUT
  [ "$output" = "$lEXPECTED_OUTPUT" ]
}

@test "02 - prerequisite - bats - Helper file exists" {
  # define var
  local lCLI_PARAM_FILE="/home/ubuntu/wkspc/git/luc-bash/test/helper/bats-assert/src/assert_line.bash"
  local lCLI_TO_TEST="test -f "$lCLI_PARAM_FILE""
  ## define expected
  local lEXPECTED_OUTPUT=""
  local lEXPECTED_RETVAL="0"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  [ "$output" = "$lEXPECTED_OUTPUT" ]
}

@test "03 - prerequisite - bats - Helper method assert_line exists" {
  # define var
  local lCLI_PARAM_METHOD="assert_line"
  local lCLI_PARAM_FILE="/home/ubuntu/wkspc/git/luc-bash/test/helper/bats-assert/src/${lCLI_PARAM_METHOD}.bash"
  # make the method availbale
  source $lCLI_PARAM_FILE
  ## define expected
  local lCLI_TO_TEST="type -t ${lCLI_PARAM_METHOD}"
  local lEXPECTED_OUTPUT="function"
  local lEXPECTED_RETVAL="0"
  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  [ "$output" = "$lEXPECTED_OUTPUT" ]
}

# echo output et -$output-
# echo status et -$status-

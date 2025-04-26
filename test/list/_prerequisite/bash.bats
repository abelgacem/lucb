#!/usr/bin/env bats

@test "01 - prerequisite - bash - Current shell is BASH" {
  # define var
  local lCLI_TO_TEST="echo $SHELL"
  ## define expected
  local lEXPECTED_OUTPUT="/bin/bash"
  local lEXPECTED_RETVAL="0"
  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # test expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # test expected OUTPUT
  [ "$output" = "$lEXPECTED_OUTPUT" ]
}


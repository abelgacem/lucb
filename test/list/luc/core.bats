#!/usr/bin/env bats

# Load dependency
source $(dirname $BATS_TEST_FILENAME)/../../srcm

# description: BATS sdef function - called, before each test
function setup() {
  expose_all_bats_helper_method
  expose_method luc/luc.core.sh
  expose_method luc/luc.core.obj.sh
}


@test "01 - luc_core_echo - nominal usecase" {
  # define var
  local lCLI_PARAM_01="xxx"
  local lCLI_PARAM_02="a message"
  local lCLI_TO_TEST="luc_core_echo "${lCLI_PARAM_01}" "${lCLI_PARAM_02}""
  ## define expected
  local lEXPECTED_RETVAL="0"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lCLI_PARAM_01}
  assert_line --partial ${lCLI_PARAM_02}
}

@test "02 - luc_core_echo - no input - display usage" {
  # define var
  local lCLI_TO_TEST="luc_core_echo"
  ## define expected
  local lEXPECTED_OUTPUT="usage: [info|done|warn|caut|debu] [message]"
  local lEXPECTED_RETVAL="1"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # test expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # test expected OUTPUT
  assert_output "${lEXPECTED_OUTPUT}"
}


@test "03 - luc_core_os_name_get - nominal usecase" {
  # define var
  # local lCLI_PARAM_CLI="command"
  local lCLI_TO_TEST="luc_core_os_name_get"
  ## define expected
  local lEXPECTED_RETVAL="0"
  local lEXPECTED_OUTPUT="^(alma|alpine|debian|rocky|ubuntu)$"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # test expected OUTPUT - check the output matches one of the expected values
  assert_regex "$output" "$lEXPECTED_OUTPUT"
}

@test "04 - luc_core_check_cli_is_installed - nominal usecase - cli exists" {
  # define var
  local lCLI_PARAM_CLI="command"
  local lCLI_TO_TEST="luc_core_check_cli_is_installed "${lCLI_PARAM_CLI}""
  ## define expected
  local lEXPECTED_RETVAL="0"
  local lEXPECTED_OUTPUT=""

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_output "${lEXPECTED_OUTPUT}"
}

@test "05 - luc_core_check_cli_is_installed - nominal usecase - cli not exists" {
  # define var
  local lCLI_PARAM_CLI="xxx"
  local lCLI_TO_TEST="luc_core_check_cli_is_installed "${lCLI_PARAM_CLI}""
  ## define expected
  local lEXPECTED_RETVAL="1"
  local lEXPECTED_OUTPUT=""

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_output "${lEXPECTED_OUTPUT}"
}


@test "06 - luc_core_check_cli_is_installed - no input - display warn" {
  # define var
  local lCLI_TO_TEST="luc_core_check_cli_is_installed"
  ## define expected
  local lEXPECTED_OUTPUT="warn"
  local lEXPECTED_RETVAL="1"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT}
}

test_function() {
  luc_core_method_name_get
}
@test "07 - luc_core_method_name_get - nominal usecase" {
  # define var
  local lCLI_TO_TEST="test_function"
  # define expected
  local lEXPECTED_RETVAL="0"
  local lEXPECTED_OUTPUT="$lCLI_TO_TEST"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_output "${lEXPECTED_OUTPUT}"
}

@test "08 - luc_core_method_name_get - abnormal use (ie. outside a method)" {
  # define var
  local lCLI_TO_TEST="luc_core_method_name_get"
  # define expected
  local lEXPECTED_RETVAL="0"
  local lEXPECTED_OUTPUT="bats_merge_stdout_and_stderr"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_output "${lEXPECTED_OUTPUT}"
}


  # echo output et -$output
  # echo status et -$status-

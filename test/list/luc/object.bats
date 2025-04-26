#!/usr/bin/env bats

# Load dependency
source $(dirname $BATS_TEST_FILENAME)/../../srcm

# description: BATS sdef function - called, before each test
function setup() {
  expose_all_bats_helper_method
  expose_method luc/luc.core.obj.sh # contains the method to test
  expose_method luc/luc.core.sh     # contains some dependencies
}


@test "01 - luc_core_object_list - nominal usecase" {
  # define var
  local lCLI_TO_TEST="luc_core_object_list"
  ## define expected
  local lEXPECTED_RETVAL="0"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="info"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
}

@test "02 - luc_core_object_unload - no input - display usage" {
  # define var
  local lCLI_TO_TEST="luc_core_object_unload"
  ## define expected
  local lEXPECTED_RETVAL="1"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="usag"
  local lEXPECTED_OUTPUT_03="warn"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
  assert_line --partial ${lEXPECTED_OUTPUT_03}
}

@test "03 - luc_core_object_unload - any input - do action wether object exists or not" {
  # define var
  local lCLI_PARAM_OBJECTCLASS="xxx"
  local lCLI_TO_TEST="luc_core_object_unload ${lCLI_PARAM_OBJECTCLASS}"
  ## define expected
  local lEXPECTED_RETVAL="0"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="done"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
}

@test "04 - luc_core_object_load - test failed because it is TODO" {
  # define var
  local lCLI_TO_TEST="luc_core_object_load"
  ## define expected
  local lEXPECTED_RETVAL="0"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
}


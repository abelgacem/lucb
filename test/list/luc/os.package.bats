#!/usr/bin/env bats

# Load dependency
source $(dirname $BATS_TEST_FILENAME)/../../srcm

# description: BATS sdef function - called, before each test
function setup() {
  expose_all_bats_helper_method
  expose_method luc/luc.os.package.sh  # method to test
  expose_method luc/luc.core.sh        # dependency methods
  expose_method luc/luc.core.obj.sh    # dependency methods
  expose_method_mock luc.os.package.sh # mock methods to override dependency methods
}

@test "01 - luc_core_os_package_upgrade - nominal usecase - simulation as root" {
  # mock method to simulate user is root in this usecase
  luc_core_os_user_check_is_root () { 
    return 0 
  }
  # define var
  local lCLI_TO_TEST="luc_core_os_package_upgrade"
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

@test "02 - luc_core_os_package_upgrade - nominal usecase - as non root" {
  # define var
  local lCLI_TO_TEST="luc_core_os_package_upgrade"
  ## define expected
  local lEXPECTED_RETVAL="1"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="warn"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
}

@test "03 - luc_core_os_package_provision - nominal usecase" {
  # define var
  local lCLI_PARAM_PACKAGE="app01 app02"
  local lCLI_TO_TEST="luc_core_os_package_provision ${lCLI_PARAM_PACKAGE}"
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
  assert_line --partial ${lCLI_PARAM_PACKAGE}
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
}

@test "04 - luc_core_os_package_provision - no input - display usage" {
  # define var
  local lCLI_TO_TEST="luc_core_os_package_provision"
  ## define expected
  local lEXPECTED_RETVAL="1"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="warn"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
}

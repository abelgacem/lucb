#!/usr/bin/env bats

# Load dependency
source $(dirname $BATS_TEST_FILENAME)/../../srcm

# description: BATS sdef function - called, before each test
function setup() {
  expose_all_bats_helper_method
  expose_method luc/luc.os.user.sh   # method to test
  expose_method luc/luc.core.sh      # dependency methods
  expose_method luc/luc.core.obj.sh  # dependency methods
  expose_method_mock luc.os.user.sh  # mock methods to override dependency methods
}

@test "01 - luc_core_os_user_sudo_provision - no input - as non root" {
  # define var
  local lCLI_TO_TEST="luc_core_os_user_sudo_provision"
  ## define expected
  local lEXPECTED_RETVAL="1"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="usag"
  local lEXPECTED_NUMBER_OF_OUTPUT_LINES="2"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
  # expected number of OUPUTED lines
  local lACTUAL_NUMBER_OF_OUTPUT_LINES=$(echo "$output" | wc -l)
  assert_equal "${lACTUAL_NUMBER_OF_OUTPUT_LINES}" "${lEXPECTED_NUMBER_OF_OUTPUT_LINES}"
}

@test "02 - luc_core_os_user_sudo_provision - an input - as non root" {
  # define var
  local lCLI_PARAM_USER="xxx"
  local lCLI_TO_TEST="luc_core_os_user_sudo_provision $lCLI_PARAM_USER"
  ## define expected
  local lEXPECTED_RETVAL="1"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="warn"
  local lEXPECTED_NUMBER_OF_OUTPUT_LINES="2"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
  # expected number of OUPUTED lines
  local lACTUAL_NUMBER_OF_OUTPUT_LINES=$(echo "$output" | wc -l)
  assert_equal "${lACTUAL_NUMBER_OF_OUTPUT_LINES}" "${lEXPECTED_NUMBER_OF_OUTPUT_LINES}"
}

@test "03 - luc_core_os_user_sudo_provision - nominal usecase - no input - simulation as root" {
  # mock method to simulate user is root in this usecase
  luc_core_os_user_check_is_root () { 
    return 0 
  }
  # define var
  local lCLI_TO_TEST="luc_core_os_user_sudo_provision"
  ## define expected
  local lEXPECTED_RETVAL="1"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="usag"
  local lEXPECTED_NUMBER_OF_OUTPUT_LINES="2"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
  # expected number of OUPUTED lines
  local lACTUAL_NUMBER_OF_OUTPUT_LINES=$(echo "$output" | wc -l)
  assert_equal "${lACTUAL_NUMBER_OF_OUTPUT_LINES}" "${lEXPECTED_NUMBER_OF_OUTPUT_LINES}"
}

@test "04 - luc_core_os_user_sudo_provision - nominal usecase - an input - simulation as root" {
  # mock method to simulate os name
  luc_core_os_name_get () { 
    echo "ubuntu"
    return 0 
  }
  # mock method to simulate root user
  luc_core_os_user_check_is_root () { 
    return 0 
  }
  luc_core_os_user_check_is_root () { 
    return 0 
  }
  # mock method to simulate grep - to avoid writing in the file /etc/environment
  grep () { 
    return 0
  }
  # define var
  local lCLI_PARAM_USER="xxxxxx"
  local lCLI_TO_TEST="luc_core_os_user_sudo_provision $lCLI_PARAM_USER"
  ## define expected
  local lEXPECTED_RETVAL="0"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="done"
  local lEXPECTED_NUMBER_OF_OUTPUT_LINES="2"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
  # expected number of OUPUTED lines
  local lACTUAL_NUMBER_OF_OUTPUT_LINES=$(echo "$output" | wc -l)
  assert_equal "${lACTUAL_NUMBER_OF_OUTPUT_LINES}" "${lEXPECTED_NUMBER_OF_OUTPUT_LINES}"
}

@test "05 - luc_core_os_user_workspace_provision - no input - display usage" {
  # define var
  local lCLI_TO_TEST="luc_core_os_user_workspace_provision"
  ## define expected
  local lEXPECTED_RETVAL="1"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="usag"
  local lEXPECTED_NUMBER_OF_OUTPUT_LINES="2"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
  # expected number of OUPUTED lines
  local lACTUAL_NUMBER_OF_OUTPUT_LINES=$(echo "$output" | wc -l)
  assert_equal "${lACTUAL_NUMBER_OF_OUTPUT_LINES}" "${lEXPECTED_NUMBER_OF_OUTPUT_LINES}"
}

@test "06 - luc_core_os_user_workspace_provision - user not exists" {
  # define var
  local lCLI_PARAM_USER="xxx"
  local lCLI_PARAM_WKSPC="zzz"
  local lCLI_TO_TEST="luc_core_os_user_workspace_provision "$lCLI_PARAM_USER" "$lCLI_PARAM_WKSPC""
  ## define expected
  local lEXPECTED_RETVAL="1"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="warn"
  local lEXPECTED_OUTPUT_03="User"
  local lEXPECTED_NUMBER_OF_OUTPUT_LINES="2"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
  assert_line --partial ${lEXPECTED_OUTPUT_03}
  # expected number of OUPUTED lines
  local lACTUAL_NUMBER_OF_OUTPUT_LINES=$(echo "$output" | wc -l)
  assert_equal "${lACTUAL_NUMBER_OF_OUTPUT_LINES}" "${lEXPECTED_NUMBER_OF_OUTPUT_LINES}"
}


@test "06 - luc_core_os_user_workspace_provision - nominal usecase" {
  # mock CLI 
  mkdir () { 
    return 1
  }
  # mock CLI
  grep () { 
    return 0
  }
  # define var
  local lCLI_PARAM_USER="$(id -nu)" 
  local lCLI_PARAM_WKSPC="yyy"
  # mock variable with an existing directory
  local lWORKSPACE_PATH="/home/${lCLI_PARAM_USER}" # this folder exists
  local lCLI_TO_TEST="luc_core_os_user_workspace_provision "$lCLI_PARAM_USER" "$lCLI_PARAM_WKSPC""
  ## define expected
  local lEXPECTED_RETVAL="0"
  local lEXPECTED_OUTPUT_01="purp"
  local lEXPECTED_OUTPUT_02="done"
  local lEXPECTED_NUMBER_OF_OUTPUT_LINES="2"

  # Play CLI
  run ${lCLI_TO_TEST}
  echo "for debug in case of failed output >  -$output"
  # expected RETVAL
  [ $status -eq "$lEXPECTED_RETVAL" ]
  # expected OUTPUT
  assert_line --partial ${lEXPECTED_OUTPUT_01}
  assert_line --partial ${lEXPECTED_OUTPUT_02}
  # expected number of OUPUTED lines
  local lACTUAL_NUMBER_OF_OUTPUT_LINES=$(echo "$output" | wc -l)
  assert_equal "${lACTUAL_NUMBER_OF_OUTPUT_LINES}" "${lEXPECTED_NUMBER_OF_OUTPUT_LINES}"
}

# @test "07 - luc_core_os_user_workspace_provision - folder already exists" {
#   # mock CLI
#   mkdir () { 
#     luc_core_echo "done" "already"
#     return 1
#   }
#   # mock CLI
#   grep () { 
#     return 0
#   }
#   # define var
#   local lCLI_PARAM_USER="$(id -nu)" # this user exists
#   local lCLI_PARAM_WKSPC="a"
#   # mock variable with an existing directory
#   local lCLI_TO_TEST="luc_core_os_user_workspace_provision "$lCLI_PARAM_USER" "$lCLI_PARAM_WKSPC""
#   ## define expected
#   local lEXPECTED_RETVAL="1"
#   local lEXPECTED_OUTPUT_01="purp"
#   local lEXPECTED_OUTPUT_02="done"
#   local lEXPECTED_NUMBER_OF_OUTPUT_LINES="2"

#   # Play CLI
#   run ${lCLI_TO_TEST}
#   echo "for debug in case of failed output >  -$output"
#   echo "for debug in case of failed lWORKSPACE_PATH >  -$lWORKSPACE_PATH"
#   # expected RETVAL
#   [ $status -eq "$lEXPECTED_RETVAL" ]
#   # expected OUTPUT
#   assert_line --partial ${lEXPECTED_OUTPUT_01}
#   assert_line --partial ${lEXPECTED_OUTPUT_02}
#   # expected number of OUPUTED lines
#   local lACTUAL_NUMBER_OF_OUTPUT_LINES=$(echo "$output" | wc -l)
#   assert_equal "${lACTUAL_NUMBER_OF_OUTPUT_LINES}" "${lEXPECTED_NUMBER_OF_OUTPUT_LINES}"
# }

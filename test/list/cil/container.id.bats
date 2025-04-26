#!/usr/bin/env bats

# Load dependency
source $(dirname $BATS_TEST_FILENAME)/../../srcm

# description: BATS sdef function - called, before each test
function setup() {
  expose_all_bats_helper_method
  expose_method other/cil/cil.image.sh
}

@test "luc_cil_container_id_get returns container ID for valid SID" {
  PATH="$PWD/mocks:$PATH" # Use the mock for the test
  run luc_cil_container_id_get "test-container"
  [ "$status" -eq 0 ]
  [[ "$output" == "mock-container-id" ]]
}

@test "luc_cil_container_id_get fails for missing SID" {
  run luc_cil_container_id_get
  [ "$status" -eq 1 ]
  [[ "$output" == *"Container not provided"* ]]
}




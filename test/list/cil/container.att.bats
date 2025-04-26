#!/usr/bin/env bats

# # Load dependency
# load ../../srcm

# # Source the specific function file
# setup() {
#   expose_method "luc.core.sh
# }


@test "luc_cil_container_attribute_get retrieves attribute NAME" {
  PATH="$PWD/mocks:$PATH"
  run luc_cil_container_attribute_get "test-container" "NAME"
  [ "$status" -eq 0 ]
  [[ "$output" == "mock-container-name" ]]
}

@test "luc_cil_container_attribute_get returns error for invalid key" {
  PATH="$PWD/mocks:$PATH"
  run luc_cil_container_attribute_get "test-container" "INVALID_KEY"
  [ "$status" -eq 3 ]
  [[ "$output" == *"pbs finding key referenced by INVALID_KEY in json"* ]]
}

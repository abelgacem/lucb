#!/usr/bin/env bats

# Load dependency
source $(dirname $BATS_TEST_FILENAME)/../../srcm

# description: BATS sdef function - called, before each test
function setup() {
  expose_all_bats_helper_method
  expose_method other/cil/cil.image.sh
}

@test "01 - luc_cil_image_id_get - nominal usecase" {
  run luc_cil_image_id_get anid
  # expected RETVAL
  [ "$status" -eq 0 ]
  # expected ECHO
  lEXPECTED_OUTPUT="3912a92804ab"
  assert_output "${lEXPECTED_OUTPUT}"
}

@test "02 - luc_cil_image_id_get - no input - display warning and images available" {
  run luc_cil_image_id_get
  # expected RETVAL
  [ "$status" -eq 1 ]
  # expected ECHO
  assert_output --partial "warn > No image ID provided. Choose one among:"
  assert_output --partial "No image ID provided. Choose one among:"
  assert_output --partial "REPOSITORY                     TAG      IMAGE ID       CREATED         SIZE"
}

@test "03 - luc_cil_image_id_get - good input - image not found" {
  run luc_cil_image_id_get anid
  # run bash -c 'luc_cil_image_id_get'
  # expected RETVAL
  [ "$status" -eq 2 ]
}

@test "04 - luc_cil_image_id_get - good input - multiple images found" {
  run luc_cil_image_id_get anid
  # run bash -c 'luc_cil_image_id_get'
  # expected RETVAL
  [ "$status" -eq 3 ]
  # expected ECHO
}



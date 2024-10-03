test_that("pprof_sitrep() and helpers", {
  expect_message(pprof_sitrep(), regexp = "go")
  expect_message(found_go_bin_path(), regexp = "Go binary")
  expect_message(found_go_bin_env(), regexp = "PROFFER_GO_BIN")
  expect_message(missing_go_bin_path(), regexp = "Go binary")
  expect_message(missing_go_bin_env(), regexp = "PROFFER_GO_BIN")
})

test_that("pprof_path() and helpers", {
  expect_true(is.character(go_bin_path()))
  expect_true(is.character(go_bin_env()))
  expect_true(is.character(go_bin_sys()))
})

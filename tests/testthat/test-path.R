test_that("pprof_path() and helpers", {
  expect_true(is.character(pprof_path()))
  expect_true(is.character(pprof_env()))
  expect_true(is.character(pprof_env_new()))
  expect_true(is.character(pprof_env_old()))
  expect_true(is.character(pprof_sys()))
  expect_true(is.character(go_path()))
  expect_true(is.character(go_bin_path()))
  expect_true(is.character(go_bin_env()))
  expect_true(is.character(go_bin_sys()))
  expect_true(is.character(go_ext_sys()))
})

test_that("pprof_path() listens to PROFFER_PPROF_PATH", {
  skip_if_not_installed("withr")
  exp <- tempfile()
  file.create(exp)
  out <- withr::with_envvar(
    c(PROFFER_PPROF_PATH = exp),
    pprof_path()
  )
  expect_equal(out, exp)
})

test_that("pprof_path() listens to old pprof_path", {
  skip_if_not_installed("withr")
  exp <- tempfile()
  file.create(exp)
  out <- withr::with_envvar(
    c(PROFFER_PPROF_PATH = "", pprof_path = exp),
    pprof_path()
  )
  expect_equal(out, exp)
})

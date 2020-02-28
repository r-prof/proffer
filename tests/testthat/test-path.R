test_that("pprof_path() and helpers", {
  expect_true(is.character(pprof_path()))
  expect_true(is.character(env_proffer_pprof_path()))
  expect_true(is.character(env_pprof_go_path()))
  expect_true(is.character(env_go_dir()))
  expect_true(is.character(env_go_bin()))
  expect_true(is.character(env_go_ext()))
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

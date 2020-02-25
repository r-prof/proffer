test_that("assert_pprof()", {
  skip_on_os("windows")
  if (file.exists(pprof_path())) {
    expect_null(assert_pprof())
  } else {
    expect_error(assert_pprof(), regexp = "cannot find pprof")
  }
})

test_that("pprof_path()", {
  skip_on_os("windows")
  for (verbose in c(TRUE, FALSE)) {
    expect_true(is.character(pprof_path(verbose)))
  }
})

test_that("missing_pprof()", {
  expect_error(missing_pprof(), regexp = "cannot find pprof")
})

test_that("pprof_path() environment vars", {
  skip_if_not_installed("withr")
  withr::with_envvar(
    c(PROFFER_PPROF_PATH = ""),
    expect_message(pprof_path(), regexp = "PROFFER_PPROF_PATH")
  )
  withr::with_envvar(
    c(PROFFER_PPROF_PATH = "", pprof_path = ""),
    expect_message(pprof_path(), regexp = "pprof_path")
  )
})

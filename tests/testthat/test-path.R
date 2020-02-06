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
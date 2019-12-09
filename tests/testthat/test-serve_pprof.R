test_that("random_port()", {
  port <- random_port()
  expect_true(is.integer(port))
  expect_equal(length(port), 1L)
})

test_that("assert_pprof()", {
  env <- Sys.getenv("pprof")
  on.exit(Sys.setenv(pprof = env))
  Sys.unsetenv("pprof")
  expect_error(assert_pprof(), regexp = "cannot find pprof")
  tmp <- tempfile()
  file.create(tmp)
  Sys.setenv(pprof = tmp)
  expect_silent(assert_pprof())
})

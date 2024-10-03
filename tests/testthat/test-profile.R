test_that("record_pprof() and convert to rprof", {
  skip_on_cran()
  pprof <- record_pprof(slow_function())
  samples <- profile::read_pprof(pprof)
  expect_silent(profile::validate_profile(samples))
  rprof <- to_rprof(pprof)
  samples <- profile::read_rprof(rprof)
  expect_silent(profile::validate_profile(samples))
})

test_that("record_rprof() and convert to pprof", {
  skip_on_cran()
  rprof <- record_rprof(slow_function())
  samples <- profile::read_rprof(rprof)
  expect_silent(profile::validate_profile(samples))
  pprof <- to_pprof(rprof)
  samples <- profile::read_pprof(pprof)
  expect_silent(profile::validate_profile(samples))
})

test_that("arguments to record_rprof()", {
  skip_on_cran()
  rprof <- record_rprof(slow_function())
  prof <- profile::read_rprof(rprof)
  expect_silent(profile::validate_profile(prof))
  rprof <- record_rprof(slow_function(), rprof = rprof, append = TRUE)
  # Needs fix in {profile}
  suppressWarnings(prof2 <- profile::read_rprof(rprof))
  expect_silent(profile::validate_profile(prof2))
  expect_gt(nrow(prof2$samples), nrow(prof$samples))
})

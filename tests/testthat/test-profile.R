test_that("record_pprof() and convert to rprof", {
  pprof <- record_pprof(replicate(1e2, sample.int(1e4)))
  samples <- profile::read_pprof(pprof)
  expect_silent(profile::validate_profile(samples))
  rprof <- to_rprof(pprof)
  samples <- profile::read_rprof(rprof)
  expect_silent(profile::validate_profile(samples))
})

test_that("record_rprof() and convert to pprof", {
  rprof <- record_rprof(replicate(1e2, sample.int(1e4)))
  samples <- profile::read_rprof(rprof)
  expect_silent(profile::validate_profile(samples))
  pprof <- to_pprof(rprof)
  samples <- profile::read_pprof(pprof)
  expect_silent(profile::validate_profile(samples))
})

test_that("arguments to record_rprof()", {
  rprof <- record_rprof(replicate(1e2, sample.int(1e4)))
  prof <- profile::read_rprof(rprof)
  expect_silent(profile::validate_profile(prof))

  rprof <- record_rprof(
    replicate(1e2, sample.int(1e4)),
    rprof = rprof,
    append = TRUE
  )
  # Needs fix in {profile}
  suppressWarnings(prof2 <- profile::read_rprof(rprof))
  expect_silent(profile::validate_profile(prof2))

  expect_gt(nrow(prof2$samples), nrow(prof$samples))

  expect_error(
    record_rprof(replicate(1e2, sample.int(1e4)), bogus = argument),
    "bogus",
    fixed = TRUE
  )
})

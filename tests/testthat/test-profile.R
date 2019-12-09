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

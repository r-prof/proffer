test_that("install_go() is deprecated", {
  skip_on_cran()
  expect_warning(install_go())
})

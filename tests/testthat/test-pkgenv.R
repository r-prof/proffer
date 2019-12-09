test_that("populate_pkgenv()", {
  expect_silent(populate_pkgenv())
  expect_true(is.logical(pkgenv[["on_windows"]]))
})

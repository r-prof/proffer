test_that("", {
  port <- random_port()
  expect_true(is.integer(port))
  expect_equal(length(port), 1L)
})

test_that("on_windows()", {
  expect_true(is.logical(on_windows()))
})

test_that("%||%", {
  expect_equal("x" %||% "y", "x")
  expect_equal(character(0) %||% "y", character(0))
  expect_equal(NULL %||% "y", "y")
})

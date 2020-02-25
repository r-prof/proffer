test_that("%||%", {
  expect_equal("x" %||% "y", "x")
  expect_equal(character(0) %||% "y", character(0))
  expect_equal(NULL %||% "y", "y")
})

test_that("random_port()", {
  port <- random_port()
  expect_true(is.integer(port))
  expect_equal(length(port), 1L)
})

test_that("verbose_msg", {
  expect_message(verbose_msg(TRUE, "abc", "def"))
  expect_silent(verbose_msg(FALSE, "abc", "def"))
})

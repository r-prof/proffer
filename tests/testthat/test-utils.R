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

test_that("with_path()", {
  hash <- "46f6ded6b2f73c352be884dae6317700"
  bin <- paste0(
    system.file(package = "processx", "bin", "px"),
    system.file(package = "processx", "bin", .Platform$r_arch, "px.exe")
  )
  px <- with_path(
    hash,
    processx::run(bin, c("getenv", "PATH"))
  )
  expect_true(grepl(hash, px$stdout))
})

test_that("verbose_msg", {
  expect_message(verbose_msg(TRUE, "abc", "def"))
  expect_silent(verbose_msg(FALSE, "abc", "def"))
})

test_that("%||%", {
  expect_equal("x" %||% "y", "x")
  expect_equal(character(0) %||% "y", character(0))
  expect_equal(NULL %||% "y", "y")
})

test_that("%fl%", {
  tmp <- tempfile()
  file.create(tmp)
  expect_equal(tmp %fl% "y", tmp)
  expect_equal("" %fl% "y", "y")
})

test_that("random_port()", {
  port <- random_port()
  expect_true(is.integer(port))
  expect_equal(length(port), 1L)
})

test_that("trn()", {
  expect_equal(trn(TRUE, "a", "b"), "a")
  expect_equal(trn(FALSE, "a", "b"), "b")
})

test_that("with_safe_path(), nonempty case", {
  hash <- "46f6ded6b2f73c352be884dae6317700"
  bin <- paste0(
    system.file(package = "processx", "bin", "px"),
    system.file(package = "processx", "bin", .Platform$r_arch, "px.exe")
  )
  px <- with_safe_path(
    hash,
    processx::run(bin, c("getenv", "PATH"))
  )
  expect_true(grepl(hash, px$stdout))
})

test_that("with_safe_path(), empty case", {
  hash <- ""
  bin <- paste0(
    system.file(package = "processx", "bin", "px"),
    system.file(package = "processx", "bin", .Platform$r_arch, "px.exe")
  )
  px <- with_safe_path("", processx::run(bin, c("getenv", "PATH")))
  expect_false(grepl("^:", px$stdout))
})

test_that("install_go() on Mac", {
  x <- structure(list(), class = "darwin")
  dest <- "/home/you"
  vers <- "1.14"
  expect_message(install_go_impl(x, dest, vers, FALSE))
})

test_that("install_go() on Windows", {
  x <- structure(list(), class = "windows")
  dest <- "/home/you"
  vers <- "1.14"
  expect_message(install_go_impl(x, dest, vers, FALSE))
})

test_that("install_go() on Linux", {
  expect_message(msg_go_install_linux("/home/you"))
  skip_if_offline()
  skip_if_not(go_platform_class() == "linux")
  tmp <- tempfile()
  dir.create(tmp)
  install_go(destination = tmp, quiet = TRUE)
  pprof_bin <- file.path(tmp, "go/pkg/tool/linux_amd64/pprof")
  go_bin <- file.path(tmp, "go/bin/go")
  expect_true(file.exists(pprof_bin))
  expect_true(file.exists(go_bin))
})

test_that("serve_pprof()", {
  skip("interactive only")
  pprof <- record_pprof(slow_function())
  # Should launch a browser and not show a message.
  px <- serve_pprof(pprof, browse = TRUE, verbose = FALSE)
  px$kill()
  # Should show a message but not launch a browser.
  px <- serve_pprof(pprof, browse = FALSE, verbose = TRUE)
  px$kill()
})

test_that("serve_rprof()", {
  skip("interactive only")
  rprof <- record_rprof(slow_function())
  # Should launch a browser and not show a message.
  px <- serve_rprof(rprof, browse = TRUE, verbose = FALSE)
  px$kill()
  # Should show a message but not launch a browser.
  px <- serve_rprof(rprof, browse = FALSE, verbose = TRUE)
  px$kill()
})

test_that("pprof()", {
  skip("interactive only")
  # Should launch a browser and not show a message.
  px <- pprof(
    slow_function(),
    browse = TRUE,
    verbose = FALSE
  )
  px$kill()
  # Should show a message but not launch a browser.
  px <- pprof(
    slow_function(),
    browse = FALSE,
    verbose = TRUE
  )
  px$kill()
})

test_that("test_pprof()", {
  skip("interactive only")
  # Should launch a browser and show a message.
  px <- test_pprof()
  px$kill()
})

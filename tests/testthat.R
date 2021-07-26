library(testthat)
library(proffer)

if (identical(Sys.getenv("NOT_CRAN"), "true")) {
  test_check("proffer")
}

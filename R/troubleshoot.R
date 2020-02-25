#' @title Test `pprof()`
#' @export
#' @seealso [pprof()]
#' @description Do a test run of `pprof()` to verify that the
#'   system dependencies like `pprof` work as expected.
#' @details See <https://github.com/r-prof/proffer#installation>
#'   for setup instructions.
#' @inheritParams pprof
#' @examples
#' \dontrun{
#' test_pprof()
#' }
test_pprof <- function(
  host = "localhost",
  port = NULL,
  browse = interactive(),
  verbose = TRUE
) {
  slow_function <- function() {
    n <- 1e3
    x <- data.frame(x = sample.int(n), y = sample.int(n))
    for (i in seq_len(n)) {
      x[i, ] <- x[i, ] + 1
    }
    x
  }
  pprof(
    slow_function(),
    host = host,
    port = port,
    browse = browse,
    verbose = verbose
  )
}

#' @title Check if `proffer` can find your `pprof` installation.
#' @export
#' @description Returns silently if `pprof` is installed
#'   and throws an error if `pprof` is missing.
#' @details See <https://github.com/r-prof/proffer#installation>
#'   for setup instructions.
#' @param verbose Logical, whether to print out messages
#'   when `proffer` is having trouble searching for `pprof`.
#' @examples
#' \dontrun{
#' assert_pprof()
#' }
assert_pprof <- function(verbose = TRUE) {
  if (file.exists(pprof_path(verbose = verbose))) {
    return(invisible())
  }
  missing_pprof()
}

missing_pprof <- function() {
  stop(
    "cannot find pprof executable. ",
    "See the setup instructions at https://r-prof.github.io/proffer.",
    call. = FALSE
  )
}

#' @title Show the path to the pprof executable.
#' @export
#' @description Defaults to the `PROFFER_PPROF_PATH` environment variable.
#'   Otherwise, it searches your Go lang installation for `pprof`.
#' @details See <https://github.com/r-prof/proffer#installation>
#'   for setup instructions.
#' @return Character, path to `pprof` it exists and `""` otherwise.
#' @param verbose Logical, whether to print out messages
#'   when `proffer` is having trouble searching for `pprof`.
#' @examples
#' \dontrun{
#' pprof_path()
#' }
pprof_path <- function(verbose = TRUE) {
  pprof_path <- Sys.getenv("PROFFER_PPROF_PATH")
  if (file.exists(pprof_path)) {
    return(pprof_path)
  }
  verbose_msg(verbose, "Cannot find pprof at 'PROFFER_PPROF_PATH' env var:", pprof_path)
  pprof_path <- Sys.getenv("pprof_path")
  if (file.exists(pprof_path)) {
    return(pprof_path)
  }
  verbose_msg(verbose, "Cannot find pprof at 'pprof_path' env var:", pprof_path)
  pprof_search(verbose)
}

pprof_search <- function(verbose) {
  if (nchar(Sys.which("go")) == 0) {
    verbose_msg(verbose, "Go lang compiler tools not installed.")
    return("")
  }
  gopath <- system2("go", c("env", "GOPATH"), stdout = TRUE)
  if (!dir.exists(gopath)) {
    verbose_msg(verbose, "Cannot find 'GOPATH' at", gopath)
    return("")
  }
  pprof_path <- file.path(gopath, "bin", "pprof")
  if (.Platform$OS.type == "windows") {
    pprof_path <- paste0(pprof_path, ".exe")
  }
  if (!file.exists(pprof_path)) {
    verbose_msg(verbose, "Cannot find pprof in GOPATH: ", pprof_path)
    return("")
  }
  pprof_path
}

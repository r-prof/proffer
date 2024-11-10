#' @title Profile R code and record pprof samples.
#' @export
#' @description Run R code and record pprof samples.
#'   Profiles are recorded with [record_rprof()]
#'   and then converted with [to_pprof()].
#' @return Path to a file with pprof samples.
#' @inheritParams record_rprof
#' @param pprof Path to a file with pprof samples.
#'   Also returned from the function.
#' @examples
#' if (identical(Sys.getenv("PROFFER_EXAMPLES"), "true")) {
#' # Returns a path to pprof samples.
#' record_pprof(replicate(1e2, sample.int(1e4)))
#' }
record_pprof <- function(
  expr,
  seconds_timeout = Inf,
  pprof = tempfile(),
  ...
) {
  rprof <- record_rprof(
    expr = expr,
    seconds_timeout = seconds_timeout,
    ...
  )
  to_pprof(rprof, pprof = pprof)
  pprof
}

#' @title Profile R code and record Rprof samples.
#' @export
#' @description Run R code and record Rprof samples.
#' @return Path to a file with Rprof samples.
#' @param expr An R expression to profile.
#' @param seconds_timeout Maximum number of seconds of elapsed time
#'   to profile `expr`. When the timeout is reached, `proffer` stops running
#'   `expr` and returns the profiling samples taken during the
#'   `seconds_timeout` time window.
#' @param rprof Path to a file with Rprof samples.
#'   Also returned from the function.
#' @param ... Additional arguments passed on to [Rprof()].
#' @examples
#' if (identical(Sys.getenv("PROFFER_EXAMPLES"), "true")) {
#' # Returns a path to Rprof samples.
#' record_rprof(replicate(1e2, sample.int(1e4)))
#' }
record_rprof <- function(
  expr,
  seconds_timeout = Inf,
  rprof = tempfile(),
  ...
) {
  on.exit(Rprof(NULL))
  Rprof(filename = rprof, ...)
  R.utils::withTimeout(expr, timeout = seconds_timeout, onTimeout = "silent")
  rprof
}

#' @title Convert Rprof samples to pprof format.
#' @export
#' @description Convert Rprof samples to pprof format.
#' @return Path to pprof samples.
#' @param rprof Path to Rprof samples.
#' @param pprof Path to pprof samples.
#' @examples
#' if (identical(Sys.getenv("PROFFER_EXAMPLES"), "true")) {
#' rprof <- record_rprof(replicate(1e2, sample.int(1e4)))
#' to_pprof(rprof)
#' }
to_pprof <- function(rprof, pprof = tempfile()) {
  samples <- profile::read_rprof(path = rprof)
  profile::write_pprof(x = samples, path = pprof)
  pprof
}

#' @title Convert pprof samples to Rprof format.
#' @export
#' @description Convert pprof samples to Rprof format.
#' @return Path to pprof samples.
#' @param pprof Path to pprof samples.
#' @param rprof Path to Rprof samples.
#' @examples
#' if (identical(Sys.getenv("PROFFER_EXAMPLES"), "true")) {
#' pprof <- record_pprof(replicate(1e2, sample.int(1e4)))
#' to_rprof(pprof)
#' }
to_rprof <- function(pprof, rprof = tempfile()) {
  samples <- profile::read_pprof(path = pprof)
  profile::write_rprof(x = samples, path = rprof)
  rprof
}

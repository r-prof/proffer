#' @title Profile R code and record pprof samples.
#' @export
#' @description Run R code and record pprof samples.
#'   Profiles are recorded with [record_rprof()]
#'   and then converted with [to_pprof()].
#' @return Path to a file with pprof samples.
#' @param expr An R expression to profile.
#' @param pprof Path to a file with pprof samples.
#'   Also returned from the function.
#' @param ... Additional arguments passed on to [Rprof()]
#'   via [record_rprof()].
#' @examples
#' # Returns a path to pprof samples.
#' record_pprof(replicate(1e2, sample.int(1e4)))
record_pprof <- function(expr, pprof = tempfile(), ...) {
  rprof <- record_rprof(expr, ...)
  to_pprof(rprof, pprof = pprof)
  pprof
}

#' @title Profile R code and record Rprof samples.
#' @export
#' @description Run R code and record Rprof samples.
#' @return Path to a file with Rprof samples.
#' @param expr An R expression to profile.
#' @param rprof Path to a file with Rprof samples.
#'   Also returned from the function.
#' @param ... Additional arguments passed on to [Rprof()].
#' @examples
#' # Returns a path to Rprof samples.
#' record_rprof(replicate(1e2, sample.int(1e4)))
record_rprof <- function(expr, rprof = tempfile(), ...) {
  on.exit(Rprof(NULL))
  Rprof(filename = rprof, ...)
  expr
  rprof
}

#' @title Convert Rprof samples to pprof format.
#' @export
#' @description Convert Rprof samples to pprof format.
#' @return Path to pprof samples.
#' @param rprof Path to Rprof samples.
#' @param pprof Path to pprof samples.
#' @examples
#' rprof <- record_rprof(replicate(1e2, sample.int(1e4)))
#' to_pprof(rprof)
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
#' pprof <- record_pprof(replicate(1e2, sample.int(1e4)))
#' to_rprof(pprof)
to_rprof <- function(pprof, rprof = tempfile()) {
  samples <- profile::read_pprof(path = pprof)
  profile::write_rprof(x = samples, path = rprof)
  rprof
}

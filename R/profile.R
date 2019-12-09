#' @title Profile R code and record pprof samples.
#' @export
#' @description Run R code and record pprof samples.
#' @return Path to a file with pprof samples.
#' @param expr An R expression to profile.
#' @param pprof Path to a file with pprof samples.
#'   Also returned from the function.
#' @examples
#' # Returns a path to pprof samples.
#' record_pprof(replicate(1e2, sample.int(1e4)))
record_pprof <- function(expr, pprof = tempfile()) {
  rprof <- record_rprof(expr)
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
#' @examples
#' # Returns a path to Rprof samples.
#' record_rprof(replicate(1e2, sample.int(1e4)))
record_rprof <- function(expr, rprof = tempfile()) {
  on.exit(Rprof(NULL))
  Rprof(filename = rprof)
  force(expr)
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

#' @title Visualize profiling data with pprof.
#' @export
#' @description Visualize profiling data with pprof.
#' @details Uses a local interactive server.
#'   Navigate a browser to a URL in the message.
#' @return Nothing.
#' @param pprof Path to pprof samples.
#' @param host Host name. Set to `"localhost"` to view locally
#'   or `"0.0.0.0"` to view from another machine.
#' @param port Port number.
#' @examples
#' pprof <- record_pprof(replicate(1e2, sample.int(1e4)))
#' to_rprof(pprof)
vis_pprof <- function(pprof, host = "localhost", port = NULL) {
  server <- sprintf("%s:%s", host, port %||% random_port())
  message("local pprof server: http://", server)
  args <- c("-http", server, pprof)
  if (on_windows()) {
    shell(paste(c("pprof", args), collapse = " "))
  } else {
    system2("pprof", args)
  }
}

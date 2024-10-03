#' @title Test `pprof()`
#' @export
#' @seealso [pprof()]
#' @description Do a test run of `pprof()` to verify that the
#'   system dependencies like `pprof` work as expected.
#' @details See <https://github.com/r-prof/proffer#installation>
#'   for setup instructions.
#' @inheritParams pprof
#' @examples
#' if (identical(Sys.getenv("PROFFER_EXAMPLES"), "true")) {
#' test_pprof()
#' }
test_pprof <- function(
  host = "localhost",
  port = proffer::random_port(),
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

#' @title Profile R code and visualize with pprof.
#' @export
#' @description Run R code and display profiling results
#'   in a local interactive pprof server.
#'   Results are collected with [record_pprof()].
#' @return A `processx::process$new()` handle. Use this handle
#'   to take down the server with `$kill()`.
#' @inheritParams serve_pprof
#' @param expr R code to run and profile.
#' @param ... Additional arguments passed on to [Rprof()]
#'   via [record_pprof()].
#' @examples
#' if (identical(Sys.getenv("PROFFER_EXAMPLES"), "true")) {
#' # Start a pprof virtual server in the background.
#' px <- pprof(replicate(1e2, sample.int(1e4)))
#' # Terminate the server.
#' px$kill()
#' }
pprof <- function(
  expr,
  host = "localhost",
  port = proffer::random_port(),
  browse = interactive(),
  verbose = TRUE,
  ...
) {
  pprof <- record_pprof(expr, ...)
  serve_pprof(
    pprof = pprof,
    host = host,
    port = port,
    browse = browse,
    verbose = verbose
  )
}

#' @title Visualize Rprof() output with pprof.
#' @export
#' @description Use pprof to visualize profiling data
#'   produced by `Rprof()` or [record_rprof()].
#' @details Uses a local interactive server.
#'   Navigate a browser to a URL in the message.
#'   The server starts in a background process
#' @return A `processx::process$new()` handle. Use this handle
#'   to take down the server with `$kill()`.
#' @inheritParams serve_pprof
#' @param rprof Path to profiling samples generated
#'   by `Rprof()` or [record_rprof()].
#' @examples
#' if (identical(Sys.getenv("PROFFER_EXAMPLES"), "true")) {
#' rprof <- record_rprof(replicate(1e2, sample.int(1e4)))
#' # Start a pprof virtual server in the background.
#' px <- serve_rprof(rprof)
#' # Terminate the server.
#' px$kill()
#' }
serve_rprof <- function(
  rprof,
  host = "localhost",
  port = proffer::random_port(),
  browse = interactive(),
  verbose = TRUE
) {
  pprof <- to_pprof(rprof)
  serve_pprof(
    pprof = pprof,
    host = host,
    port = port,
    browse = browse,
    verbose = verbose
  )
}

#' @title Visualize profiling data with pprof.
#' @export
#' @description Visualize profiling data with pprof.
#' @details Uses a local interactive server.
#'   Navigate a browser to a URL in the message.
#'   The server starts in a background process
#' @return A `processx::process$new()` handle. Use this handle
#'   to take down the server with `$kill()`.
#' @param pprof Path to pprof samples.
#' @param host Host name. Set to `"localhost"` to view locally
#'   or `"0.0.0.0"` to view from another machine. If you view
#'   from another machine, the printed out URL will not be valid.
#'   For example, if `pprof()` or `serve_pprof()` prints
#'   "http://0.0.0.0:8080", then you need to replace 0.0.0.0
#'   with your computer's name or IP address, e.g.
#'   "http://my_computer.com:8080".
#' @param port Port number for hosting the local pprof server.
#'   Chosen randomly by default.
#' @param browse Logical, whether to open a browser to view
#'   the pprof server.
#' @param verbose Logical, whether to print console messages
#'   such as the URL of the local `pprof` server.
#' @examples
#' if (identical(Sys.getenv("PROFFER_EXAMPLES"), "true")) {
#' pprof <- record_pprof(replicate(1e2, sample.int(1e4)))
#' # Start a pprof virtual server in the background.
#' px <- serve_pprof(pprof)
#' # Terminate the server.
#' px$kill()
#' }
serve_pprof <- function(
  pprof,
  host = "localhost",
  port = proffer::random_port(),
  browse = interactive(),
  verbose = TRUE
) {
  server <- sprintf("%s:%s", host, port)
  args <- c("-http", server, "-no_browser", pprof)
  process <- serve_pprof_impl(args)
  if (browse) {
    browse_port(host, port, process, verbose)
  }
  if (verbose) {
    show_url(host, port)
  }
  invisible(process)
}

#' @title Choose a random free TCP port.
#' @export
#' @description Choose a random free TCP port.
#' @details This function is a simple wrapper around
#'   `parallelly::freePort()` with the default port range
#'   covering ephemeral ports only.
#' @return Port number, positive integer of length 1.
#' @param lower Integer of length 1, lower bound of the port number.
#' @param upper Integer of length 1, upper bound of the port number.
#' @examples
#' random_port()
random_port <- function(lower = 49152L, upper = 65535L) {
  parallelly::freePort(ports = seq.int(from = lower, to = upper, by = 1L))
}

browse_port <- function(host, port, process, verbose) {
  spinner <- cli::make_spinner()
  if_any(verbose, spinner$spin(), NULL)
  while (!pingr::is_up(destination = host, port = port)) {
    if_any(process$is_alive(), Sys.sleep(0.01), stop0(process$read_all_error()))
    if_any(verbose, spinner$spin(), NULL)
  }
  spinner$finish()
  url <- paste0("http://", host, ":", port, "/ui/flamegraph")
  utils::browseURL(url)
}

show_url <- function(host, port) {
  cli::cli_ul()
  url <- sprintf("http://%s:%s/ui/flamegraph", host, port)
  cli::cli_li("url: {.url {url}}")
  cli::cli_li("host: {host}")
  cli::cli_li("port: {port}")
  cli::cli_end()
}

serve_pprof_impl <- function(args) {
  processx::run(
    command = go_bin_path(),
    args = c("telemetry", "off"),
    stdout = "|",
    stderr = "|",
    error_on_status = FALSE
  )
  processx::process$new(
    command = go_bin_path(),
    args = c("tool", "pprof", args),
    stdout = "|",
    stderr = "|",
    supervise = TRUE
  )
}

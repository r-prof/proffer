#' @title Profile R code and visualize with pprof.
#' @export
#' @description Run R code and display profiling results
#'   in a local interactive pprof server.
#' @return A `processx::process$new()` handle. Use this handle
#'   to take down the server with `$kill()`.
#' @inheritParams serve_pprof
#' @param expr R code to run and profile.
#' @examples
#' \dontrun{
#' # Start a pprof virtual server in the background.
#' px <- pprof(replicate(1e2, sample.int(1e4)))
#' # Terminate the server.
#' px$kill()
#' }
pprof <- function(
  expr,
  host = "localhost",
  port = NULL,
  browse = interactive(),
  verbose = TRUE
) {
  pprof <- record_pprof(expr)
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
#' \dontrun{
#' rprof <- record_rprof(replicate(1e2, sample.int(1e4)))
#' # Start a pprof virtual server in the background.
#' px <- serve_rprof(rprof)
#' # Terminate the server.
#' px$kill()
#' }
serve_rprof <- function(
  rprof,
  host = "localhost",
  port = NULL,
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
#' \dontrun{
#' pprof <- record_pprof(replicate(1e2, sample.int(1e4)))
#' # Start a pprof virtual server in the background.
#' px <- serve_pprof(pprof)
#' # Terminate the server.
#' px$kill()
#' }
serve_pprof <- function(
  pprof,
  host = "localhost",
  port = NULL,
  browse = interactive(),
  verbose = TRUE
) {
  server <- sprintf("%s:%s", host, port %||% random_port())
  url <- sprintf("http://%s", server)
  args <- c("-http", server, pprof)
  px <- serve_pprof_impl(args, verbose)
  if (verbose) {
    message(url)
  }
  if (browse) {
    utils::browseURL(url)
  }
  px
}

serve_pprof_impl <- function(args, verbose) {
  with_safe_path(
    Sys.getenv("PROFFER_GRAPHVIZ_PATH"),
    processx::process$new(
      command = pprof_path(verbose),
      args = args,
      stdout = "|",
      stderr = "|",
      supervise = TRUE
    )
  )
}

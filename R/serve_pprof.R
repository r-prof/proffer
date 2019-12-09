#' @title Profile R code and visualize with pprof.
#' @export
#' @description Run R code and display profiling results
#'   in a local interactive pprof server.
#' @return A `callr::r_bg()` handle. Use this handle
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

#' @title Visualize profiling data with pprof.
#' @export
#' @description Visualize profiling data with pprof.
#' @details Uses a local interactive server.
#'   Navigate a browser to a URL in the message.
#'   The server starts in a background process
#' @return A `callr::r_bg()` handle. Use this handle
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
#' @param verbose Logical, whether to print the URL of the pprof
#'   server to the R console as a message.
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
  assert_pprof()
  server <- sprintf("%s:%s", host, port %||% random_port())
  url <- sprintf("http://%s", server)
  func <- ifelse(on_windows(), serve_pprof_windows, serve_pprof_linux)
  args <- c("-http", server, pprof)
  env <- callr::rcmd_safe_env()
  px <- callr::r_bg(func = func, args = list(args = args), supervise = TRUE)
  if (verbose) {
    message(url)
  }
  if (browse) {
    utils::browseURL(url)
  }
  px
}

serve_pprof_windows <- function(args) {
  shell(paste(c("pprof", args), collapse = " "))
}

serve_pprof_linux <- function(args) {
  system2(Sys.getenv("pprof_path"), args)
}

random_port <- function(from = 49152L, to = 65355L) {
  sample(seq.int(from = from, to = to, by = 1L), size = 1L)
}

assert_pprof <- function() {
  if (file.exists(Sys.getenv("pprof_path"))) {
    return()
  }
  missing_pprof()
}

missing_pprof <- function() {
  stop(
    "cannot find pprof at ",
    shQuote(Sys.getenv("pprof_path")),
    ". See the setup instructions at https://wlandau.github.io/proffer.",
    call. = FALSE
  )
}

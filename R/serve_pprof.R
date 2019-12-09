#' @title Visualize profiling data with pprof.
#' @export
#' @description Visualize profiling data with pprof.
#' @details Uses a local interactive server.
#'   Navigate a browser to a URL in the message.
#'   The server starts in a background process
#' @return A `callr::r_bg()` handler. Use this handler
#' @param pprof Path to pprof samples.
#' @param host Host name. Set to `"localhost"` to view locally
#'   or `"0.0.0.0"` to view from another machine.
#' @param port Port number.
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
# nocov start
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
# nocov end

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

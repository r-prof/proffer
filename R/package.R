#' proffer: profile R code with pprof
#' @description It can be challenging to find sources of
#' slowness in large workflows, and the proffer package can help.
#' Proffer runs R code and displays summaries
#' to show where the code is slowest. Proffer leverages
#' the pprof utility to create highly efficient, clear, easy-to-read
#' interactive displays that help users find ways to reduce runtime.
#' The package also contains helpers to convert profiling data
#' to and from pprof format and visualize existing profiling data files.
#' For documentation, visit <https://r-prof.github.io/proffer/>.
#' @name proffer-package
#' @aliases proffer
#' @author William Michael Landau \email{will.landau@@gmail.com}
#' @examples
#' # TBD
#' @references <https://github.com/r-prof/proffer>
#' @importFrom cli cli_alert_danger cli_alert_info cli_alert_success cli_h1
#'   cli_li cli_ul make_spinner
#' @importFrom parallelly freePort
#' @importFrom processx process
#' @importFrom profile read_rprof write_pprof
#' @importFrom R.utils withTimeout
#' @importFrom RProtoBuf readProtoFiles
#' @importFrom utils browseURL Rprof
#' @importFrom withr with_path
#' @examples
#' if (identical(Sys.getenv("PROFFER_EXAMPLES"), "true")) {
#' # Start a pprof virtual server in the background.
#' px <- pprof(replicate(1e2, sample.int(1e4)))
#' # Terminate the server.
#' px$kill()
#' }
NULL

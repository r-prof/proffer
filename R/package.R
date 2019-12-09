#' proffer: pprof-powered profiling packaged for R
#' @docType package
#' @description Profiling in R powered by pprof.
#' @name proffer-package
#' @aliases proffer
#' @author William Michael Landau \email{will.landau@@gmail.com}
#' @examples
#' # TBD
#' @references <https://github.com/wlandau/pprof>
#' @importFrom callr r_bg
#' @importFrom profile read_rprof write_pprof
#' @importFrom RProtoBuf readProtoFiles
#' @importFrom utils browseURL Rprof
#' @examples
#' \dontrun{
#' # Start a pprof virtual server in the background.
#' px <- pprof(replicate(1e2, sample.int(1e4)))
#' # Terminate the server.
#' px$kill()
#' }
NULL

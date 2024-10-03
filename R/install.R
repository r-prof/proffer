#' @title Deprecated
#' @export
#' @keywords internal
#' @description Deprecated. To install Go, visit <https://go.dev/dl/>
#'   and choose the appropriate build for your platform.
#' @param destination Full path to the Go installation with the `pprof`
#'   and Go executables.
#' @param version Character, a version string such as `"1.19.5"`.
#' @param quiet Logical, whether to suppress console messages.
install_go <- function(
  destination = tempfile(),
  version = NULL,
  quiet = FALSE
) {
  .Deprecated(
    package = "proffer",
    old = "install_go()",
    new = "https://go.dev/dl/"
  )
  invisible()
}

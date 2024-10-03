#' @title Deprecated
#' @export
#' @keywords internal
#' @description Deprecated.
#' @return Character, path to Go.
#' @examples
#' if (identical(Sys.getenv("PROFFER_EXAMPLES"), "true")) {
#' pprof_path()
#' }
pprof_path <- function() {
  .Deprecated(package = "proffer", old = "pprof_path()")
  go_bin_path()
}

go_bin_path <- function() {
  go_bin_env() %fl% go_bin_sys()
}

go_bin_env <- function() {
  Sys.getenv("PROFFER_GO_BIN")
}

go_bin_sys <- function() {
  unname(Sys.which("go"))
}

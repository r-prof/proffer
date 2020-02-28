#' @title Show the path to the pprof executable.
#' @export
#' @description Defaults to the `PROFFER_PPROF_PATH` environment variable.
#'   Otherwise, it searches your Go lang installation for `pprof`.
#' @details See <https://github.com/r-prof/proffer#installation>
#'   for setup instructions.
#' @return Character, path to `pprof` it exists and `""` otherwise.
#' @examples
#' \dontrun{
#' pprof_path()
#' }
pprof_path <- function() {
  pprof_path <- Sys.getenv("PROFFER_PPROF_PATH")
  if (file.exists(pprof_path)) {
    return(pprof_path)
  }
  pprof_path <- Sys.getenv("pprof_path")
  if (file.exists(pprof_path)) {
    return(pprof_path)
  }
  if (nchar(Sys.which("go")) == 0) {
    return("")
  }
  gopath <- with_safe_path(
    Sys.getenv("PROFFER_GO_PATH"),
    system2("go", c("env", "GOPATH"), stdout = TRUE)
  )
  if (!dir.exists(gopath)) {
    return("")
  }
  pprof_path <- file.path(gopath, "bin", "pprof")
  if (.Platform$OS.type == "windows") {
    pprof_path <- paste0(pprof_path, ".exe")
  }
  if (!file.exists(pprof_path)) {
    return("")
  }
  pprof_path
}

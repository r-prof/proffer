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
  env_proffer_pprof_path() %fl%
    env_pprof_path() %fl%
    env_pprof_go_path()
}

env_proffer_pprof_path <- function() {
  Sys.getenv("PROFFER_PPROF_PATH")
}

env_pprof_path <- function() {
  Sys.getenv("pprof_path")
}

env_pprof_go_path <- function() {
  ifelse(
    file.exists(env_go_dir()),
    env_pprof_go_path_impl(),
    ""
  )
}

env_pprof_go_path_impl <- function() {
  paste0(file.path(env_go_dir(), "bin", "pprof"), env_go_ext())
}

env_go_dir <- function() {
  ifelse(
    file.exists(env_go_bin()),
    env_go_dir_impl(),
    ""
  )
}

env_go_dir_impl <- function() {
  with_safe_path(
    Sys.getenv("PROFFER_GO_PATH"),
    system2("go", c("env", "GOPATH"), stdout = TRUE)
  )
}

env_go_bin <- function() {
  Sys.which("go")
}


env_go_ext <- function() {
  ifelse(.Platform$OS.type == "windows", ".exe", "")
}

#' @title Verify pprof installation
#' @export
#' @description Check if `pprof` and its dependencies are installed.
pprof_sitrep <- function() {
  sitrep_pprof_path()
  sitrep_pprof_env_new()
  sitrep_pprof_env_old()
  sitrep_pprof_sys()
  sitrep_go_path()
  sitrep_go_bin_path()
  sitrep_go_bin_env()
  sitrep_go_bin_sys()
  sitrep_graphviz_path()
  sitrep_graphviz_env()
  sitrep_graphviz_sys()
  cli_test_pprof()
}

sitrep_pprof_path <- function() {
  ifelse(
    file.exists(pprof_path()),
    cli_pprof_path_found(),
    cli_pprof_path_missing()
  )
}



cli_pprof_path_found <- function() {
  cli::cli_alert_success("pprof path found. {pprof_path()}")
}

cli_pprof_path_missing <- function() {
  cli::cli_alert_danger("pprof path missing. {pprof_path()}")
}

cli_test_pprof <- function() {

}


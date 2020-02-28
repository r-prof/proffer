#' @title Verify pprof installation
#' @export
#' @description Check if `pprof` and its dependencies are installed.
pprof_sitrep <- function() {
  sitrep_pprof_path()
  sitrep_pprof_env_new()
  sitrep_pprof_env_old()
  sitrep_go_bin_path()
  sitrep_go_path()
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

sitrep_pprof_env_new <- function() {
  ifelse(
    file.exists(pprof_path_env_new()),
    cli_pprof_env_new_found(),
    cli_pprof_env_new_missing()
  )
}

sitrep_pprof_env_old <- function() {
  ifelse(
    file.exists(pprof_path_env_old()),
    cli_pprof_env_old_found(),
    cli_pprof_env_old_missing()
  )
}

sitrep_go_bin_path <- function() {
  ifelse(
    file.exists(pprof_path()),
    cli_go_bin_path_found(),
    cli_go_bin_path_missing()
  )
}

sitrep_go_path <- function() {
  ifelse(
    file.exists(pprof_path()),
    cli_go_path_found(),
    cli_go_path_missing()
  )
}

cli_pprof_path_found <- function() {
  cli::cli_alert_success("pprof path found. {pprof_path()}")
}

cli_pprof_path_missing <- function() {
  cli::cli_alert_danger("pprof path missing. {pprof_path()}")
}

cli_pprof_path_found <- function() {
  cli::cli_alert_success("go binary found. {env_go_bin()}")
}

cli_pprof_path_missing <- function() {
  cli::cli_alert_danger("go binary missing. {env_go_bin()}")
}

cli_go_dir_found <- function() {
  cli::cli_alert_success("go directory found. {env_go_dir()}")
}

cli_go_dir_missing <- function() {
  cli::cli_alert_danger("go directory missing. {env_go_dir()}")
}

cli_dot_found <- function() {

}

cli_dot_missing <- function() {

}

cli_test_pprof <- function() {

}


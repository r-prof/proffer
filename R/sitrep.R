#' @title Verify pprof installation
#' @export
#' @description Check if `pprof` and its dependencies are installed.
#'   Print useful messages along the way.
pprof_sitrep <- function() {
  sitrep_pprof()
  sitrep_go_bin()
  sitrep_go_dir()
  sitrep_dot()
  cli_test_pprof()
}

sitrep_pprof <- function() {
  ifelse(
    file.exists(pprof_path()),
    cli_pprof_found(),
    cli_pprof_missing()
  )
}

sitrep_go_bin <- function() {
  ifelse(
    file.exists(env_go_bin()),
    cli_go_bin_found(),
    cli_go_bin_missing()
  )
}

sitrep_go_dir <- function() {
  ifelse(
    file.exists(env_go_dir()),
    cli_go_dir_found(),
    cli_go_dir_missing()
  )
}

sitrep_dot <- function() {
  ifelse(
    file.exists(env_go_dir()),
    cli_dot_found(),
    cli_dot_missing()
  )
}

cli_pprof_found <- function() {
  cli::cli_alert_success("pprof found. {pprof_path()}")
}

cli_pprof_missing <- function() {
  cli::cli_alert_danger("pprof missing. {pprof_path()}")
}

cli_go_bin_found <- function() {
  cli::cli_alert_success("go binary found. {env_go_bin()}")
}

cli_go_bin_missing <- function() {
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


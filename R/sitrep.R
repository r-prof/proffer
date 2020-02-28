#' @title Verify pprof installation
#' @export
#' @description Check if `pprof` and its dependencies are installed.
#' @examples
#' pprof_sitrep()
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
    found_pprof_path(),
    missing_pprof_path()
  )
}

sitrep_pprof_env_new <- function() {
  ifelse(
    file.exists(pprof_env_new()),
    found_pprof_env_new(),
    missing_pprof_env_new()
  )
}

sitrep_pprof_env_old <- function() {
  ifelse(
    file.exists(pprof_env_old()),
    found_pprof_env_old(),
    missing_pprof_env_old()
  )
}

sitrep_pprof_sys <- function() {
  ifelse(
    file.exists(pprof_sys()),
    found_pprof_sys(),
    missing_pprof_sys()
  )
}

sitrep_go_path <- function() {
  ifelse(
    file.exists(go_path()),
    found_go_path(),
    missing_go_path()
  )
}

sitrep_go_bin_path <- function() {
  ifelse(
    file.exists(go_bin_path()),
    found_go_bin_path(),
    missing_go_bin_path()
  )
}

sitrep_go_bin_env <- function() {
  ifelse(
    file.exists(go_bin_env()),
    found_go_bin_env(),
    missing_go_bin_env()
  )
}

sitrep_go_bin_sys <- function() {
  ifelse(
    file.exists(go_bin_sys()),
    found_go_bin_sys(),
    missing_go_bin_sys()
  )
}

found_pprof_path <- function() {
  cli::cli_alert_success("pprof path {pprof_path()}")
}

found_pprof_env_new <- function() {
  cli::cli_alert_success("PROFFER_PPROF_PATH path {pprof_env_new()}")
}

found_pprof_env_old <- function() {
  cli::cli_alert_success("pprof_path path {pprof_env_new()}")
}

found_pprof_sys <- function() {
  cli::cli_alert_success("pprof system path {pprof_sys()}")
}

found_go_path <- function() {
  cli::cli_alert_success("go path {go_path()}")
}

found_go_bin_path <- function() {
  cli::cli_alert_success("go binary path {go_bin_path()}")
}

found_go_bin_env <- function() {
  cli::cli_alert_success("PROFFER_GO_PATH path {go_bin_env()}")
}

found_go_bin_sys <- function() {
  cli::cli_alert_success("go binary system path {go_bin_sys()}")
}

missing_pprof_path <- function() {
  cli::cli_alert_danger("pprof path missing {pprof_path()}")
}

missing_pprof_env_new <- function() {
  cli::cli_alert_info("PROFFER_PPROF_PATH path missing {pprof_env_new()}")
}

missing_pprof_env_old <- function() {
  cli::cli_alert_info("pprof_path path missing {pprof_env_new()}")
}

missing_pprof_sys <- function() {
  cli::cli_alert_info("pprof system path missing {pprof_sys()}")
}

missing_go_path <- function() {
  cli::cli_alert_danger("go path missing {go_path()}")
}

missing_go_bin_path <- function() {
  cli::cli_alert_danger("go binary path missing {go_bin_path()}")
}

missing_go_bin_env <- function() {
  cli::cli_alert_info("PROFFER_GO_PATH path missing{go_bin_env()}")
}

missing_go_bin_sys <- function() {
  cli::cli_alert_info("go binary system path missing {go_bin_sys()}")
}

#' @title Verify pprof installation
#' @export
#' @description Check if `pprof` and its dependencies are installed.
#' @examples
#' pprof_sitrep()
pprof_sitrep <- function() {
  msg_li("Call test_pprof() to test installation.")
  cli::cli_h1("Requirements")
  sitrep_go_bin_path()
  cli::cli_h1("Custom")
  sitrep_go_bin_env()
  invisible()
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

found_go_bin_path <- function() {
  cli::cli_alert_success("Go binary {.path {go_bin_path()}}")
}

found_go_bin_env <- function() {
  cli::cli_alert_success("{.envvar PROFFER_GO_BIN} {.path {go_bin_env()}}")
}

missing_go_bin_path <- function() {
  cli::cli_alert_info("Go binary missing {.path {go_bin_path()}}")
  msg_li("See {.url https://golang.org/doc/install} to install Go.")
}

missing_go_bin_env <- function() {
  cli::cli_alert_info(
    "{.envvar PROFFER_GO_BIN} missing {.path {go_bin_env()}}"
  )
  msg_renviron()
  msg_li("PROFFER_GO_BIN={.path {go_bin_sys()}}")
}

msg_li <- function(x) {
  cli::cli_ul()
  cli::cli_li(x)
  cli::cli_end()
}

msg_renviron <- function() {
  msg_li(
    "Run {.code usethis::edit_r_environ()} to edit {.file .Renviron} file."
  )
}

#' @title Verify pprof installation
#' @export
#' @description Check if `pprof` and its dependencies are installed.
#' @examples
#' pprof_sitrep()
pprof_sitrep <- function() {
  msg_li("Call test_pprof() to test installation.")
  cli::cli_h1("Requirements")
  sitrep_pprof_path()
  sitrep_go_bin_path()
  sitrep_go_path()
  sitrep_graphviz_path()
  cli::cli_h1("Custom")
  sitrep_pprof_env_new()
  sitrep_go_bin_env()
  sitrep_graphviz_env()
  cli::cli_h1("System")
  sitrep_pprof_sys()
  sitrep_go_bin_sys()
  sitrep_graphviz_sys()
  cli::cli_h1("Deprecated")
  sitrep_pprof_env_old()
  invisible()
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
    pprof_env_old() == "",
    missing_pprof_env_old(),
    found_pprof_env_old()
  )
}

sitrep_pprof_sys <- function() {
  ifelse(
    file.exists(pprof_sys()),
    found_pprof_sys(),
    missing_pprof_sys()
  )
}

sitrep_go_bin_path <- function() {
  ifelse(
    file.exists(go_bin_path()),
    found_go_bin_path(),
    missing_go_bin_path()
  )
}

sitrep_go_path <- function() {
  ifelse(
    file.exists(go_path()),
    found_go_path(),
    missing_go_path()
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

sitrep_graphviz_path <- function() {
  ifelse(
    file.exists(graphviz_path()),
    found_graphviz_path(),
    missing_graphviz_path()
  )
}

sitrep_graphviz_env <- function() {
  ifelse(
    file.exists(graphviz_env()),
    found_graphviz_env(),
    missing_graphviz_env()
  )
}

sitrep_graphviz_sys <- function() {
  ifelse(
    file.exists(graphviz_sys()),
    found_graphviz_sys(),
    missing_graphviz_sys()
  )
}

found_pprof_path <- function() {
  cli::cli_alert_success("pprof {.path {pprof_path()}}")
}

found_pprof_env_new <- function() {
  cli::cli_alert_success(
    "{.envvar PROFFER_PPROF_BIN} {.path {pprof_env_new()}}"
  )
}

found_pprof_env_old <- function() {
  cli::cli_alert_info("{.envvar pprof_path} {.path {pprof_env_old()}}")
  msg_li(
    "{.envvar pprof_path} is deprecated. Use {.envvar PROFFER_PPROF_BIN}."
  )
}

found_pprof_sys <- function() {
  cli::cli_alert_success("pprof system path {.path {pprof_sys()}}")
}

found_go_bin_path <- function() {
  cli::cli_alert_success("Go binary {.path {go_bin_path()}}")
}

found_go_path <- function() {
  cli::cli_alert_success("Go folder {.path {go_path()}}")
}

found_go_bin_env <- function() {
  cli::cli_alert_success("{.envvar PROFFER_GO_BIN} {.path {go_bin_env()}}")
}

found_go_bin_sys <- function() {
  cli::cli_alert_success("Go binary system path {.path {go_bin_sys()}}")
}

found_graphviz_path <- function() {
  cli::cli_alert_success("Graphviz {.path {graphviz_path()}}")
}

found_graphviz_env <- function() {
  cli::cli_alert_success(
    "{.envvar PROFFER_GRAPHVIZ_BIN} {.path {graphviz_env()}}"
  )
}

found_graphviz_sys <- function() {
  cli::cli_alert_success("Graphviz system path {.path {graphviz_sys()}}")
}

missing_pprof_path <- function() {
  cli::cli_alert_danger("pprof missing {.path {pprof_path()}}")
  msg_li("See {.url https://github.com/google/pprof} to install pprof.")
}

missing_pprof_env_new <- function() {
  cli::cli_alert_info(
    "{.envvar PROFFER_PPROF_BIN} missing {.path {pprof_env_new()}}"
  )
  msg_renviron()
  msg_li("PROFFER_GO_BIN={.path {pprof_sys()}}")
}

missing_pprof_env_old <- function() {
  cli::cli_alert_success(
    "{.envvar pprof_path} env variable omitted."
  )
}

missing_pprof_sys <- function() {
  cli::cli_alert_info("pprof system path missing {.path {pprof_sys()}}")
  msg_li("See {.url https://github.com/google/pprof} to install pprof.")
}

missing_go_bin_path <- function() {
  cli::cli_alert_danger("Go binary missing {.path {go_bin_path()}}")
  msg_li("See {.url https://golang.org/doc/install} to install Go.")
}

missing_go_path <- function() {
  cli::cli_alert_danger("Go folder missing {.path {go_path()}}")
  msg_li("See {.url https://golang.org/doc/install} to install Go.")
  msg_li(
    paste(
      "If the Go folder is missing but the Go binary is non-missing,",
      "you may need to configure the GOPATH environment variable.",
      "See {.url https://github.com/golang/go/wiki/GOPATH}.", collapse = " "
    )
  )
}

missing_go_bin_env <- function() {
  cli::cli_alert_info(
    "{.envvar PROFFER_GO_BIN} missing {.path {go_bin_env()}}"
  )
  msg_renviron()
  msg_li("PROFFER_GO_BIN={.path {go_bin_sys()}}")
}

missing_go_bin_sys <- function() {
  cli::cli_alert_info("Go binary system path missing {.path {go_bin_sys()}}")
  msg_li("See {.url https://golang.org/doc/install} to install Go.")
}

missing_graphviz_path <- function() {
  cli::cli_alert_danger("Graphviz missing {.path {graphviz_path()}}")
  msg_li("See {.url https://www.graphviz.org/download} to install Graphviz.")
}

missing_graphviz_env <- function() {
  cli::cli_alert_info(
    "{.envvar PROFFER_GRAPHVIZ_BIN} missing {.path {graphviz_env()}}"
  )
  msg_renviron()
  msg_li("PROFFER_GRAPHVIZ_BIN={.path {graphviz_sys()}}")
}

missing_graphviz_sys <- function() {
  cli::cli_alert_info("Graphviz system path missing {.path {graphviz_sys()}}")
  msg_li("See {.url https://www.graphviz.org/download} to install Graphviz.")
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

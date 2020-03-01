#' @title Verify pprof installation
#' @export
#' @description Check if `pprof` and its dependencies are installed.
#' @examples
#' pprof_sitrep()
pprof_sitrep <- function() {
  msg_li("Call test_pprof() to test installation.")

  pprof <- sitrep_pprof_anywhere()
  graphviz <- sitrep_graphviz_anywhere()

  if (pprof && graphviz) {
    msg_li("Call test_pprof() to test installation.")
  }

  invisible()
}

sitrep_pprof_path <- function() {
  branch(
    file.exists(pprof_path()),
    found_pprof_path(),
    missing_pprof_path()
  )
}

sitrep_pprof_env_new <- function() {
  branch(
    file.exists(pprof_env_new()),
    found_pprof_env_new(),
    missing_pprof_env_new()
  )
}

sitrep_pprof_env_old <- function() {
  branch(
    file.exists(pprof_env_old()),
    found_pprof_env_old(),
    missing_pprof_env_old()
  )
}

sitrep_pprof_sys <- function() {
  branch(
    file.exists(pprof_sys()),
    found_pprof_sys(),
    missing_pprof_sys()
  )
}

sitrep_go_path <- function() {
  branch(
    file.exists(go_path()),
    found_go_path(),
    missing_go_path()
  )
}

sitrep_go_bin_env <- function() {
  branch(
    file.exists(go_bin_env()),
    found_go_bin_env(),
    missing_go_bin_env()
  )
}

sitrep_go_bin_sys <- function() {
  branch(
    file.exists(go_bin_sys()),
    found_go_bin_sys(),
    missing_go_bin_sys()
  )
}

sitrep_graphviz_env <- function() {
  branch(
    file.exists(graphviz_env()),
    found_graphviz_env(),
    missing_graphviz_env()
  )
}

sitrep_graphviz_sys <- function() {
  branch(
    file.exists(graphviz_sys()),
    found_graphviz_sys(),
    missing_graphviz_sys()
  )
}

found_pprof_path <- function() {
  cli::cli_alert_success("pprof path {pprof_path()}")
}

found_pprof_env_new <- function() {
  cli::cli_alert_success("PROFFER_PPROF_PATH path {pprof_env_new()}")
}

found_pprof_env_old <- function() {
  cli::cli_alert_info("pprof_path path {pprof_env_old()}")
  msg_li("pprof_path is deprecated. Use PROFFER_PPROF_PATH instead.")
}

found_pprof_sys <- function() {
  cli::cli_alert_success("pprof system path {pprof_sys()}")
}

found_go_path <- function() {
  cli::cli_alert_success("Go path {go_path()}")
}

found_go_bin_path <- function() {
  cli::cli_alert_success("Go binary path {go_bin_path()}")
}

found_go_bin_env <- function() {
  cli::cli_alert_success("PROFFER_GO_PATH path {go_bin_env()}")
}

found_go_bin_sys <- function() {
  cli::cli_alert_success("Go binary system path {go_bin_sys()}")
}

found_graphviz_path <- function() {
  cli::cli_alert_success("Graphviz path {graphviz_path()}")
}

found_graphviz_env <- function() {
  cli::cli_alert_success("PROFFER_GRAPHVIZ_PATH {graphviz_env()}")
}

found_graphviz_sys <- function() {
  cli::cli_alert_success("Graphviz system path {graphviz_sys()}")
}

missing_pprof_path <- function() {
  cli::cli_alert_danger("pprof path missing {pprof_path()}")
  msg_li("See {.url https://github.com/google/pprof} to install pprof.")
}

missing_pprof_env_new <- function() {
  cli::cli_alert_info("PROFFER_PPROF_PATH path missing {pprof_env_new()}")
  suggest_edit_r_environ()
  msg_li("PROFFER_PPROF_PATH={unname(Sys.which(\"pprof\"))}")
}

missing_pprof_env_old <- function() {
  cli::cli_alert_success("pprof_path env variable omitted {pprof_env_old()}")
}

missing_pprof_sys <- function() {
  cli::cli_alert_info("pprof system path missing {pprof_sys()}")
  msg_li("See https://github.com/google/pprof to install pprof.")
}

missing_go_path <- function() {
  cli::cli_alert_danger("Go path missing {go_path()}")
  msg_li("See https://golang.org/doc/install to install Go.")
  msg_li("See https://github.com/golang/go/wiki/GOPATH to configure GOPATH.")
}

missing_go_bin_path <- function() {
  cli::cli_alert_danger("Go binary path missing {go_bin_path()}")
  msg_li("See https://golang.org/doc/install to install Go.")
}

missing_go_bin_env <- function() {
  cli::cli_alert_info("PROFFER_GO_PATH path missing {go_bin_env()}")
  suggest_edit_r_environ()
  msg_li("PROFFER_GO_PATH={unname(Sys.which(\"go\"))}")
}

missing_go_bin_sys <- function() {
  cli::cli_alert_info("Go binary system path missing {go_bin_sys()}")
  msg_li("See https://golang.org/doc/install to install Go.")
}

missing_graphviz_path <- function() {
  cli::cli_alert_danger("Graphviz path missing {graphviz_path()}")
  msg_li("See https://www.graphviz.org/download to install Graphviz.")
}

missing_graphviz_env <- function() {
  cli::cli_alert_info("PROFFER_GRAPHVIZ_PATH path missing {graphviz_env()}")
  suggest_edit_r_environ()
  msg_li("PROFFER_GRAPHVIZ_PATH={unname(Sys.which(\"dot\"))}")
}

missing_graphviz_sys <- function() {
  cli::cli_alert_info("Graphviz system path missing {graphviz_sys()}")
  msg_li("See https://www.graphviz.org/download to install Graphviz.")
}

msg_li <- function(x) {
  cli::cli_ul()
  cli::cli_li(x)
  cli::cli_end()
}

suggest_edit_r_environ <- function() {
  msg_li("Run {.code usethis::edit_r_environ()} to edit the {.path .Renviron} file.")
}

branch <- function(condition, true, false) {
  if (condition) {
    true
  } else {
    false
  }
  condition
}

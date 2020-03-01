pprof_env_new <- function() {
  Sys.getenv("PROFFER_PPROF_PATH")
}

pprof_env_old <- function() {
  Sys.getenv("pprof_path")
}

go_bin_env <- function() {
  Sys.getenv("PROFFER_GO_PATH")
}

go_bin_sys <- function() {
  unname(Sys.which("go"))
}

go_ext_sys <- function() {
  ifelse(.Platform$OS.type == "windows", ".exe", "")
}

graphviz_env <- function() {
  Sys.getenv("PROFFER_GRAPHVIZ_PATH")
}

graphviz_sys <- function() {
  unname(Sys.which("dot"))
}

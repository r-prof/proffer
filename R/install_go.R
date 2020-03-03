#' @title Install pprof and Go
#' @export
#' @description This function installs Go, which comes with its own
#'   installation of `pprof`. Only for amd64 architectures running
#'   Linux, Mac OS, or Windows.
#' @details On Linux, users will need to set
#'   the environment variables `PROFFER_PPROF_BIN` and `PROFFER_GO_BIN` using
#'   `usethis::edit_r_environ()`. Typically, if `destination` is `/home/you`,
#'   then typically those lines look like
#'   `PROFFER_GO_BIN=/home/you/go/pkg/tool/linux_amd64/pprof`
#'   `PROFFER_PPROF_BIN=/home/you/go/bin/go`.
#' @param destination Full path to install pprof and Go on Linux systems.
#'   Defaults to `Sys.getenv("HOME")`, which means the default
#'   Go installation path is `file.path(Sys.getenv("HOME"), "go")`.
#'   After installation succeeds, follow the instructions in the
#'   console messages for setting the appropriate environment
#'   variables so `proffer` can use Go and `pprof`.
#' @param version Character, a version string such as `"1.14"`
install_go <- function(
  destination = Sys.getenv("HOME"),
  version = "1.14",
  quiet = FALSE
) {
  stopifnot(is.character(version) && length(version) == 1L)
  run_go_installer(download_go(version, quiet), destination, quiet)
  invisible()
}

run_go_installer <- function(path, destination, quiet) {
  run_go_installer_impl(go_platform_obj(), path, destination, quiet)
}

run_go_installer_impl <- function(x, path, destination, quiet) {
  UseMethod("run_go_installer_impl")
}

run_go_installer_impl.linux <- function(x, path, destination, quiet) {
  utils::untar(path, exdir = destination)
  if (!quiet) {
    msg_go_installation(x, destination)
  }
}

run_go_installer_impl.darwin <- function(x, path, destination, quiet) {

}

run_go_installer_impl.windows <- function(x, path, destination, quiet) {

}

run_go_installer_impl.default <- function(x, path, destination, quiet) {
  go_error_install_platform()
}

download_go <- function(version, quiet) {
  url <- go_url(version)
  tmp <- tempfile()
  utils::download.file(url, tmp, quiet = quiet)
  tmp
}

go_url <- function(version) {
  paste0(
    "https://dl.google.com/go/go",
    version,
    ".",
    go_platform_ext()
  )
}

go_platform_ext <- function() {
  go_platform_ext_impl(go_platform_obj())
}

go_platform_obj <- function() {
  structure(list(), class = go_platform_class())
}

go_platform_class <- function() {
  tolower(Sys.info()[["sysname"]])
}

go_platform_ext_impl <- function(x) {
  UseMethod("go_platform_ext_impl")
}

go_platform_ext_impl.linux <- function(x) {
  "linux-amd64.tar.gz"
}

go_platform_ext_impl.darwin <- function(x) {
  "darwin-amd64.pkg"
}

go_platform_ext_impl.windows <- function(x) {
  "windows-amd64.msi"
}

go_platform_ext_impl.default <- function(x) {
  go_error_install_platform()
}

go_error_install_platform <- function() {
  stop("cannot install Go on your platform", call. = FALSE)
}

msg_go_installation <- function(x, destination) {
  UseMethod("msg_go_installation")
}

msg_go_installation.linux <- function(x, destination) {
  pprof_bin <- file.path(destination, "go/pkg/tool/linux_amd/pprof")
  go_bin <- file.path(destination, "go/bin/go")
  cli_alert_success(
    paste(
      "pprof installed to",
      "{.path {file.path(destination, \"go/pkg/tool/linux_amd/pprof\")}}"
    )
  )
  cli_alert_success("Go installed to {.path {file.path(destination, \"go\")}}")
  cli::cli_ul()
  cli::cli_li(
    paste(
      "Open your {.file .Renviron} file with {.code usethis::edit_r_environ()}",
      "and add the following lines:"
    )
  )
  cli::cli_li("PROFFER_PPROF_BIN={.path {pprof_bin}}")
  cli::cli_li("PROFFER_GO_BIN={.path {go_bin}}")
  cli::cli_end()
}

#' @title Install pprof and Go on Linux
#' @export
#' @description On Linux, this function actually installs Go,
#'   which comes with its own
#'   installation of `pprof`. On Mac and Windows, the function
#'   simply points the user to a link to download the installer.
#'   Assumes amd64 architecture.
#' @details On Linux, users will need to set
#'   the environment variables `PROFFER_PPROF_BIN` and `PROFFER_GO_BIN` using
#'   `usethis::edit_r_environ()`. Typically, if `destination` is `/home/you`,
#'   then typically those lines look like
#'   `PROFFER_GO_BIN=/home/you/go/pkg/tool/linux_amd64/pprof`
#'   `PROFFER_PPROF_BIN=/home/you/go/bin/go`.
#' @param destination Only relevant to Linux,
#'   full path to the Go installation with the `pprof` and Go executables.
#'   Defaults to `Sys.getenv("HOME")`, which means the default
#'   Go installation path is `file.path(Sys.getenv("HOME"), "go")`.
#'   That means the Go binary will be at
#'   `file.path(Sys.getenv("HOME"), "go/bin/go")`
#'   and `pprof` will be at
#'   `file.path(Sys.getenv("HOME"), "go/pkg/tool/linux_amd64/pprof")`.
#'   You will need to set environment variables in your `.Renviron` file,
#'   e.g. `PROFFER_PPROF_BIN=/home/you/go/pkg/tool/linux_amd64/pprof`
#'   and `PROFFER_GO_BIN=/home/you/go/bin/go`. `usethis::edit_r_environ()`
#'   is helpful for this.
#' @param version Character, a version string such as `"1.14"`.
#' @param quiet Logical, whether to suppress console messages.
install_go <- function(
  destination = Sys.getenv("HOME"),
  version = "1.14",
  quiet = FALSE
) {
  stopifnot(is.character(version) && length(version) == 1L)
  install_go_impl(go_platform_obj(), destination, version, quiet)
  invisible()
}

go_platform_obj <- function() {
  structure(list(), class = go_platform_class())
}

go_platform_class <- function() {
  tolower(Sys.info()[["sysname"]])
}

install_go_impl <- function(x, destination, version, quiet) {
  UseMethod("install_go_impl")
}

install_go_impl.linux <- function(x, destination, version, quiet) {
  url <- paste0(go_base_url(), version, ".", "linux-amd64.tar.gz")
  tmp <- tempfile()
  utils::download.file(url, tmp, quiet = quiet)
  utils::untar(tmp, exdir = destination, verbose = !quiet)
  if (!quiet) {
    msg_go_install_linux(destination)
  }
}

msg_go_install_linux <- function(destination) {
  pprof_bin <- file.path(destination, "go/pkg/tool/linux_amd64/pprof")
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

install_go_impl.darwin <- function(x, destination, version, quiet) {
  url <- paste0(go_base_url(), version, ".", "darwin-amd64.pkg")
  cli::cli_ul()
  cli::cli_li("Download and run {.url {url}}")
  cli::cli_end()
}

install_go_impl.windows <- function(x, destination, version, quiet) {
  url <- paste0(go_base_url(), version, ".", "windows-amd64.msi")
  cli::cli_ul()
  cli::cli_li("Download and run {.url {url}}")
  cli::cli_end()
}

install_go_impl.default <- function() {
  stop("cannot install Go on your platform", call. = FALSE)
}

go_base_url <- function() {
  "https://dl.google.com/go/go"
}

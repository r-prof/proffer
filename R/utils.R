populate_pkgenv <- function() {
  populate_on_windows()
}

populate_on_windows <- function() {
  on_windows <- unname(tolower(Sys.info()["sysname"]) == "windows")
  pkgenv[["on_windows"]] <- on_windows
}

random_port <- function(from = 49152L, to = 65355L) {
  sample(seq.int(from = from, to = to, by = 1L), size = 1L)
}

on_windows <- function() {
  pkgenv[["on_windows"]]
}

`%||%` <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}

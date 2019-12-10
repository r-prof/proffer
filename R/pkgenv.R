populate_pkgenv <- function() {
  populate_on_windows()
}

populate_on_windows <- function() {
  on_windows <- unname(tolower(Sys.info()["sysname"]) == "windows")
  pkgenv[["on_windows"]] <- on_windows
}

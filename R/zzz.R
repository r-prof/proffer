pkgenv <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  populate_pkgenv() # nocov
}

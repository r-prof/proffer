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

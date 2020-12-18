`%||%` <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}

`%fl%` <- function(x, y) {
  if (!all(file.exists(x))) {
    y
  } else {
    x
  }
}

trn <- function(condition, x, y) {
  if (condition) {
    x
  } else {
    y
  }
}

with_safe_path <- function(path, code) {
  if (!is.null(path) && !is.na(path) && path != "") {
    withr::with_path(path, code)
  } else {
    code
  }
}

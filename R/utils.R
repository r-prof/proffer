`%fl%` <- function(x, y) {
  if (!all(file.exists(x))) {
    y
  } else {
    x
  }
}

stop0 <- function(...) {
  stop(..., call. = FALSE)
}

trn <- function(condition, x, y) {
  if (condition) {
    x
  } else {
    y
  }
}

warn0 <- function(...) {
  warning(..., call. = FALSE)
}

with_safe_path <- function(path, code) {
  if (!is.null(path) && !is.na(path) && path != "") {
    withr::with_path(path, code)
  } else {
    code
  }
}

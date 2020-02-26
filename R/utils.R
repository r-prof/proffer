`%||%` <- function(x, y) {
  if (is.null(x)) {
    y
  } else {
    x
  }
}

random_port <- function(from = 49152L, to = 65355L) {
  sample(seq.int(from = from, to = to, by = 1L), size = 1L)
}

with_safe_path <- function(path, code) {
  if (!is.null(path) && !is.na(path) && path != "") {
    withr::with_path(path, code)
  } else {
    code
  }
}

verbose_msg <- function(verbose, ...) {
  stopifnot(is.logical(verbose))
  if (verbose) {
    message(paste(...))
  }
}

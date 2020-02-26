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

with_path <- function(new, code) {
  path <- c(PATH = paste0(new, ":", Sys.getenv("PATH")))
  withr::with_envvar(path, code)
}

verbose_msg <- function(verbose, ...) {
  stopifnot(is.logical(verbose))
  if (verbose) {
    message(paste(...))
  }
}

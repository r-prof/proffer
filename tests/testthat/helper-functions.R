slow_function <- function() {
  n <- 1e3
  x <- data.frame(x = sample.int(n), y = sample.int(n))
  for (i in seq_len(n)) {
    x[i, ] <- x[i, ] + 1
  }
  x
}

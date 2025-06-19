
<!-- README.md is generated from README.Rmd. Please edit that file -->

# proffer <img src="https://r-prof.github.io/proffer/reference/figures/logo.png" align="right" alt="logo" width="120" height="139" style="border: none; float: right;">

[![CRAN](https://www.r-pkg.org/badges/version/proffer)](https://cran.r-project.org/package=proffer)
[![license](https://img.shields.io/badge/licence-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![check](https://github.com/r-prof/proffer/workflows/check/badge.svg)](https://github.com/r-prof/proffer/actions?workflow=check)
[![codecov](https://codecov.io/github/r-prof/proffer/coverage.svg?branch=main)](https://app.codecov.io/github/r-prof/proffer?branch=main)

The `proffer` package profiles R code to find bottlenecks. Visit
<https://r-prof.github.io/proffer/> for documentation.
<https://r-prof.github.io/proffer/reference/index.html> has a complete
list of available functions in the package.

## Why use a profiler?

This data processing code is slow.

``` r
system.time({
  n <- 1e5
  x <- data.frame(x = rnorm(n), y = rnorm(n))
  for (i in seq_len(n)) {
    x[i, ] <- x[i, ] + 1
  }
  x
})
#>   user  system elapsed 
#> 82.060  28.440 110.582 
```

Why exactly does it take so long? Is it because `for` loops are slow as
a general rule? Let us find out empirically.

``` r
library(proffer)
px <- pprof({
  n <- 1e5
  x <- data.frame(x = rnorm(n), y = rnorm(n))
  for (i in seq_len(n)) {
    x[i, ] <- x[i, ] + 1
  }
  x
})
#> ● url: http://localhost:57517
#> ● host: localhost
#> ● port: 57517
```

When we navigate to `http://localhost:64610` and look at the flame
graph, we see `[<-.data.frame()` (i.e. `x[i, ] <- x[i, ] + 1`) is taking
most of the runtime.

<center>

<a href="https://r-prof.github.io/proffer/reference/figures/flame.png">
<img src="https://r-prof.github.io/proffer/reference/figures/flame.png" alt="top" align="center" style = "border: none; float: center;">
</a>
</center>

So we refactor the code to avoid data frame row assignment. Much faster,
even with a `for` loop!

``` r
system.time({
  n <- 1e5
  x <- rnorm(n)
  y <- rnorm(n)
  for (i in seq_len(n)) {
    x[i] <- x[i] + 1
    y[i] <- y[i] + 1
  }
  x <- data.frame(x = x, y = y)
})
#>    user  system elapsed 
#>   0.012   0.000   0.013
```

Moral of the story: before you optimize, throw away your assumptions and
run your code through a profiler. That way, you can spend your time
optimizing where it counts!

## Managing the pprof server

The `pprof` server is a background
[`processx`](https://github.com/r-lib/processx) process, and you can
manage it with the `processx` methods [described
here](https://processx.r-lib.org/#managing-external-processes). Remember
to terminate the process with `$kill()` when you are done with it.

``` r
# px is a process handler.
px <- pprof({
  n <- 1e4
  x <- data.frame(x = rnorm(n), y = rnorm(n))
  for (i in seq_len(n)) {
    x[i, ] <- x[i, ] + 1
  }
  x
})
#> ● url: http://localhost:50195
#> ● host: localhost
#> ● port: 50195

# Summary of the background process.
px
#> PROCESS 'pprof', running, pid 10451.

px$is_alive()
# [1] TRUE

# Error messages, some of which do not matter.
px$read_error()
#> [1] "Main binary filename not available.\n"

# Terminate the process when you are done.
px$kill()
```

## Serving pprof remotely

As with Jupyter notebooks, you can serve `pprof` from one computer and
use it from another computer on the same network. On the server, you
must

1.  Find the server’s host name or IP address in advance.
2.  Supply `"0.0.0.0"` as the `host` argument.

``` r
system2("hostname")
#> mycomputer

px <- pprof({
  n <- 1e4
  x <- data.frame(x = rnorm(n), y = rnorm(n))
  for (i in seq_len(n)) {
    x[i, ] <- x[i, ] + 1
  }
  x
}, host = "0.0.0.0")
#> ● url: http://localhost:610712
#> ● host: localhost
#> ● port: 610712
```

Then, in the client machine navigate a web browser to the server’s host
name or IP address and use the port number printed above,
e.g. `https://mycomputer:61072`.

## Installation

For old versions of `proffer` (0.0.2 and below) refer to [these older
installation
instructions](https://github.com/r-prof/proffer/blob/f76bde56796396e83fee00f94430c94974f18303/README.md#installation)
instead of the ones below.

### The R package

The latest release of `proffer` is available on
[CRAN](https://CRAN.R-project.org).

``` r
install.packages("proffer")
```

Alternatively, you can install the development version from GitHub.

``` r
# install.packages("remotes")
remotes::install_github("r-prof/proffer")
```

The `proffer` package requires the `RProtoBuf` package, which may
require installation of additional system dependencies on Linux. See its
[installation
instructions](https://github.com/eddelbuettel/rprotobuf#installation).

### Non-R dependencies

`proffer` requires the copy of `pprof` that comes pre-packaged with the
Go language. You can install Go at <https://go.dev/doc/install>.[^1]

### Configuration

You can set the `PROFFER_GO_BIN` environment variable to a custom
location for the Go binary. See
[`usethis::edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html)
for directions on how to make this configuration permanent.

### Local testing

Run `pprof_sitrep()` again to verify that everything is installed and
configured correctly.

``` r
library(proffer)
pprof_sitrep()
#> • Call test_pprof() to test installation.
#> 
#> ── Requirements ────────────────────────────────────────────────────────────────
#> ✔ Go binary '/usr/local/go/bin/go'
#> 
#> ── Custom ──────────────────────────────────────────────────────────────────────
#> ✔ `PROFFER_GO_BIN` '/usr/local/go/bin/go'
```

If all dependencies are accounted for, `proffer` should work. Test it
out with `test_pprof()`. On a local machine, it should launch a browser
window showing an instance of `pprof`.

``` r
library(proffer)
process <- test_pprof()
```

When you are done testing, you can clean up the process to conserve
resources.

``` r
process$kill()
```

## Telemetry

Recent versions of Go implement telemetry by default. Functions in
`proffer` such as `pprof()` turn off telemetry in order to comply with
CRAN policies. Read <https://go.dev/doc/telemetry> to learn how to
restore telemetry settings after using `proffer`.

## Contributing

We encourage participation through
[issues](https://github.com/r-prof/proffer/issues) and [pull
requests](https://github.com/r-prof/proffer/pulls). `proffer` has a
[Contributor Code of
Conduct](https://github.com/r-prof/proffer/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.

## Resources

Profilers identify bottlenecks, but the do not offer solutions. It helps
to learn about fast code in general so you can think of efficient
alternatives to try.

- <http://adv-r.had.co.nz/Performance.html>
- <https://www.r-bloggers.com/2016/01/strategies-to-speedup-r-code/>
- <https://www.r-bloggers.com/2013/04/faster-higher-stonger-a-guide-to-speeding-up-r-code-for-busy-people/>
- <https://cran.r-project.org/package=data.table/vignettes/datatable-intro.html>

## What about `profvis`

[`profvis`](https://github.com/r-lib/profvis) is a more widely used and
established profiling package, and it existed before `proffer`.
`proffer` was originally developed because:

1.  [`profvis`](https://github.com/r-lib/profvis) flame graphs [did not
    originally support
    aggregation](https://github.com/r-lib/profvis/issues/115).
2.  [`profvis`](https://github.com/r-lib/profvis) visualizations
    [performed slowly on large profiling
    datasets](https://github.com/r-lib/profvis/issues/104).

Since then, (1) [has been
fixed](https://github.com/r-lib/profvis/pull/126), and it is possible to
produce aggregated flame graphs with
`print(profvis::provis(...), aggregate = TRUE)`. When (2) is also
addressed, `proffer` may be superseded.

[^1]: One of the graph visualizations requires Graphviz, which you
    <https://www.graphviz.org/download>, but this visualization is
    arguably not as useful as the flame graph.

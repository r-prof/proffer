
<!-- README.md is generated from README.Rmd. Please edit that file -->

# proffer <img src="https://r-prof.github.io/proffer/reference/figures/logo.png" align="right" alt="logo" width="120" height="139" style="border: none; float: right;">

[![CRAN](https://www.r-pkg.org/badges/version/proffer)](https://cran.r-project.org/package=proffer)
[![license](https://img.shields.io/badge/licence-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![check](https://github.com/r-prof/proffer/workflows/check/badge.svg)](https://github.com/r-prof/proffer/actions?workflow=check)
[![codecov](https://codecov.io/github/r-prof/proffer/coverage.svg?branch=main)](https://codecov.io/github/r-prof/proffer?branch=main)

The `proffer` package profiles R code to find bottlenecks. Visit
<https://r-prof.github.io/proffer> for documentation.
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

When we navigate to <http://localhost:64610> and look at the flame
graph, we see `[<-.data.frame()` (i.e. `x[i, ] <- x[i, ] + 1`) is taking
most of the runtime.

<center>

<a href="https://r-prof.github.io/proffer/reference/figures/flame.png">
<img src="https://r-prof.github.io/proffer/reference/figures/flame.png" alt="top" align="center" style = "border: none; float: center;">
</a>

</center>

So we refactor the code to avoid data frame row assignment. Much faster,
even with a `for` loop\!

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
#>   0.044   0.001   0.045
```

Moral of the story: before you optimize, throw away your assumptions and
run your code through a profiler. That way, you can spend your time
optimizing where it counts\!

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

<!-- end list -->

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

`proffer` requires

1.  Go: <https://golang.org/doc/install>
2.  Graphviz: <https://www.graphviz.org/download>
3.  `pprof`: <https://github.com/google/pprof> (already comes with Go)

`pprof` itself is already installed with Go. We highly recommend you use
Go’s default copy of `pprof` because [compatibility
issues](https://github.com/r-prof/proffer/issues/27) could arise if you
install the latest `pprof` manually.

Mac and Windows installers of Go and Graphviz are available at the links
above. On Linux, you can install Go (and thus `pprof`) directly from R:

``` r
library(proffer)
install_go() # Also installs pprof if on Linux.
```

### Configuration

First, run `pprof_sitrep()` to see if `proffer` can already find all the
required non-R dependencies. Then, run `test_pprof()` to see if `pprof`
actually works for you. If both checks pass, you are done with
installation.

Otherwise, open your your `.Renviron` file and define special
environment variables that point to system dependencies. The
[`edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html)
function in the [`usethis`](https://usethis.r-lib.org) package can help
you. Configuration varies according to your platform and installation
method.

#### Linux

    PROFFER_PPROF_BIN=/home/YOU/go/pkg/tool/linux_amd64/pprof
    PROFFER_GO_BIN=/home/YOU/go/bin/go
    PROFFER_GRAPHVIZ_BIN=/usr/bin/dot

#### Mac OS

    PROFFER_PPROF_BIN=/usr/local/bin/pprof
    PROFFER_GO_BIN=/usr/local/bin/go
    PROFFER_GRAPHVIZ_BIN=/usr/local/bin/dot

#### Windows

    PROFFER_PPROF_BIN=C:\Go\pkg\tool\windows_amd64\pprof.exe
    PROFFER_GO_BIN=C:\Go\bin\go.exe
    PROFFER_GRAPHVIZ_BIN="C:\Program Files (x86)\Graphviz2.38\bin\dot.exe"

### Verification

Run `pprof_sitrep()` again to verify that everything is installed and
configured correctly.

``` r
library(proffer)
pprof_sitrep()
#> ● Call test_pprof() to test installation.
#> 
#> ── Requirements ────────────────────────────────────────────────────────────────
#> ✓ pprof /Users/c240390/go/bin/pprof
#> ✓ Graphviz /usr/local/bin/dot
#> 
#> ── Go ──────────────────────────────────────────────────────────────────────────
#> ✓ Go binary /usr/local/bin/go
#> ✓ Go folder /Users/c240390/go
#> 
#> ── Custom ──────────────────────────────────────────────────────────────────────
#> ✓ `PROFFER_PPROF_BIN` /Users/c240390/go/bin/pprof
#> ✓ `PROFFER_GO_BIN` /usr/local/bin/go
#> ✓ `PROFFER_GRAPHVIZ_BIN` /usr/local/bin/dot
#> 
#> ── System ──────────────────────────────────────────────────────────────────────
#> ✓ pprof system path /Users/c240390/go/bin/pprof
#> ✓ Go binary system path /usr/local/bin/go
#> ✓ Graphviz system path /usr/local/bin/dot
#> 
#> ── Deprecated ──────────────────────────────────────────────────────────────────
#> ✓ `pprof_path` env variable omitted.
```

If all dependencies are accounted for, `proffer` should work. Test it
out with `test_pprof()`. On a local machine, it should launch a browser
window showing an instance of `pprof`.

``` r
library(proffer)
test_pprof()
```

## Contributing

We encourage participation through
[issues](https://github.com/r-prof/proffer/issues) and [pull
requests](https://github.com/r-prof/proffer/pulls). `proffer` has a
[Contributor Code of
Conduct](https://github.com/r-prof/CODE_OF_CONDUCT.md). By contributing
to this project, you agree to abide by its terms.

## Resources

Profilers identify bottlenecks, but the do not offer solutions. It helps
to learn about fast code in general so you can think of efficient
alternatives to try.

  - <http://adv-r.had.co.nz/Performance.html>
  - <https://www.r-bloggers.com/strategies-to-speedup-r-code/>
  - <https://www.r-bloggers.com/faster-higher-stonger-a-guide-to-speeding-up-r-code-for-busy-people/>
  - <https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html>

## Similar work

### profvis

The [`profvis`](https://github.com/rstudio/profvis) is much easier to
install than `proffer` and equally easy to invoke.

``` r
library(profvis)
profvis({
  n <- 1e5
  x <- data.frame(x = rnorm(n), y = rnorm(n))
  for (i in seq_len(n)) {
    x[i, ] <- x[i, ] + 1
  }
  x
})
```

However, `profvis`-generated flame graphs can be [difficult to
read](https://github.com/rstudio/profvis/issues/115) and [slow to
respond to mouse clicks](https://github.com/rstudio/profvis/issues/104).

<center>

<a href="https://r-prof.github.io/proffer/reference/figures/profvis.png">
<img src="https://r-prof.github.io/proffer/reference/figures/profvis.png" alt="top" align="center" style = "border: none; float: center;">
</a>

</center>

`proffer` uses [`pprof`](https://github.com/google/pprof) to create
friendlier, faster visualizations.

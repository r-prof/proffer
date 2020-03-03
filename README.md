
<!-- README.md is generated from README.Rmd. Please edit that file -->

# proffer <img src="https://r-prof.github.io/proffer/reference/figures/logo.png" align="right" alt="logo" width="120" height="139" style="border: none; float: right;">

[![CRAN](https://www.r-pkg.org/badges/version/proffer)](https://cran.r-project.org/package=proffer)
[![license](https://img.shields.io/badge/licence-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Travis build
status](https://travis-ci.org/r-prof/proffer.svg?branch=master)](https://travis-ci.org/r-prof/proffer)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/r-prof/proffer?branch=master&svg=true)](https://ci.appveyor.com/project/r-prof/proffer)
[![Codecov](https://codecov.io/github/r-prof/proffer/coverage.svg?branch=master)](https://codecov.io/github/r-prof/proffer?branch=master)

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
#> http://localhost:64610
```

When we navigate to <http://localhost:64610> and look at the flame
graph, we see `[<-.data.frame()` (i.e. `x[i, ] <- x[i, ] + 1`) is taking
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
#>   0.038   0.000   0.039
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
#> http://localhost:50195

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
2.  `pprof`: \<<https://github.com/google/pprof>)
3.  Graphviz: <https://www.graphviz.org/download>

You can install these components directly from R:

``` r
library(proffer)
install_go() # Also installs pprof.
install_graphviz()
```

### Configuration

Open your your `.Renviron` file and register the installed executables
in the environment variables of `proffer`. The
[`edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html)
function in the [`usethis`](https://usethis.r-lib.org) package can help
you.

    # .Renviron file, opened with usethis::edit_r_environ().
    # Example values for Linux:
    PROFFER_PPROF_BIN=/home/landau/go/pkg/tool/linux_amd64/pprof
    PROFFER_BIN_BIN=/home/landau/go/bin/go
    # The Graphviz path is not necessary on Linux.
    # On Windows, it will look something like this:
    PROFFER_GRAPHVIZ_BIN="C:\Program Files (x86)\Graphviz2.38\bin\dot.exe"

Remarks on configuration:

  - `PROFFER_GRAPHVIZ_BIN` is only necessary on some platforms. For
    Windows, [this
    post](https://stackoverflow.com/questions/35064304/runtimeerror-make-sure-the-graphviz-executables-are-on-your-systems-path-aft/47031762#47031762)
    has an example path you can supply directly to
    `PROFFER_GRAPHVIZ_BIN`.
  - As an alternative to the environment variables above, you can set
    your [`PATH`](https://en.wikipedia.org/wiki/PATH_\(variable\)) and
    [`GOPATH`](https://github.com/golang/go/wiki/GOPATH) yourself if you
    know what you are doing.

### Verification

Run `pprof_sitrep()` to verify that everything is installed and
configured correctly.

``` r
library(proffer)
pprof_sitrep()
#> ● Call test_pprof() to test
#>   installation.
#> 
#> ── Requirements ──────────────────────────
#> ✓ pprof /home/landau/go/pkg/tool/linux_amd64/pprof
#> ✓ Go folder /home/landau/go
#> ✓ Go binary /home/landau/go/bin/go
#> ✓ Graphviz /usr/bin/dot
#> 
#> ── Custom ────────────────────────────────
#> ✓ `PROFFER_PPROF_BIN` /home/landau/go/pkg/tool/linux_amd64/pprof
#> ✓ `PROFFER_GO_BIN` /home/landau/go/bin/go
#> ✓ `PROFFER_GRAPHVIZ_BIN` /usr/bin/dot
#> 
#> ── System ────────────────────────────────
#> ℹ pprof system path missing /home/landau/go/bin/pprof
#> ● See <https://github.com/google/pprof>
#>   to install pprof.
#> ✓ Go binary system path /home/landau/go/bin/go
#> ✓ Graphviz system path /usr/bin/dot
#> 
#> ── Deprecated ────────────────────────────
#> ✓ `pprof_path` env variable omitted.
```

If no dependencies are missing, `proffer` should work. Test it out with
`test_pprof()`. On a local machine, it should launch a browser window
showing an instance of `pprof`.

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
alternatives to
    try.

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
respond to mouse
clicks](https://github.com/rstudio/profvis/issues/104).

<center>

<a href="https://r-prof.github.io/proffer/reference/figures/profvis.png">
<img src="https://r-prof.github.io/proffer/reference/figures/profvis.png" alt="top" align="center" style = "border: none; float: center;">
</a>

</center>

`proffer` uses [`pprof`](https://github.com/google/pprof) to create
friendlier, faster visualizations.

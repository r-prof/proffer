
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

## How it works

This R code is slow.

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

What exactly is slowing it down? A common recommendation is to use
[`profvis`](https://github.com/rstudio/profvis) to find out.

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
friendly, fast visualizations.

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

When we navigate to <http://localhost:64610> and select the flame graph,
`[<-.data.frame()` jumps out at us immediately. Apparently, the line
`x[i, ] <- x[i, ] + 1` is the bottleneck.

<center>

<a href="https://r-prof.github.io/proffer/reference/figures/flame.png">
<img src="https://r-prof.github.io/proffer/reference/figures/flame.png" alt="top" align="center" style = "border: none; float: center;">
</a>

</center>

Indeed, a look at “Top” shows we spend most of the runtime on `x[i, ] <-
x[i, ] + 1`. The other operations are fast by comparison.

<center>

<a href="https://r-prof.github.io/proffer/reference/figures/top.png">
<img src="https://r-prof.github.io/proffer/reference/figures/top.png" alt="top" align="center" style = "border: none; float: center;">
</a>

</center>

<br><br>

So we return to our R code and avoid data frame row assignment. Much
faster\!

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
#>   0.049   0.002   0.051
```

## Managing the pprof server

Sometimes, your `pprof` server may not work right away. If that happens,
take a look at the error logs.

``` r
px <- pprof({
  n <- 1e4
  x <- data.frame(x = rnorm(n), y = rnorm(n))
  for (i in seq_len(n)) {
    x[i, ] <- x[i, ] + 1
  }
  x
})
#> http://localhost:50195

px # How is my background process doing?
#> PROCESS 'R', finished.
px$is_alive()
# [1] FALSE

px$read_error() # Why did it quit soon?
#> [1] "sh: /user/local/bin/pprof: No such file or directory\nWarning message:\nIn system2(Sys.getenv(\"pprof_path\"), args) : error in running command\n"

# Oh, I must have set the wrong path to the pprof executable.
# Let me find out where I actually installed pprof.
system("which", "pprof")
#> "/home/landau/go/bin/pprof"

# I can put a line in my .Rprofile or .Renviron file
# to automatically tell new sessions where pprof lives.
Sys.setenv(pprof_path = "/home/landau/go/bin/pprof")

# Now, pprof should work.
px <- pprof({
  n <- 1e4
  x <- data.frame(x = rnorm(n), y = rnorm(n))
  for (i in seq_len(n)) {
    x[i, ] <- x[i, ] + 1
  }
  x
})
#> http://localhost:64610

px
#> PROCESS 'R', running, pid 12361.
px$is_alive()
# [1] TRUE

# Now a web browser should be able to open http://localhost:64610.
```

It is best to take down the `pprof` server when you are done with it.

``` r
px$kill()
```

`px` is the handle of a [`callr`](https://github.com/r-lib/callr)
background process. To learn more about how to manage the process, have
a look at the [`callr`](https://callr.r-lib.org/) documentation,
particularly the function
[`r_bg()`](https://callr.r-lib.org/reference/r_bg.html).

## Installation

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

To use functions `pprof()` and `serve_pprof()`, you need to install
[`pprof`](https://github.com/google/pprof). Installing `pprof` is hard,
so if you have trouble, please do not hesitate to [open an
issue](https://github.com/r-prof/proffer/issues) and ask for help. And
if you cannot install `pprof`, then
[`profvis`](https://rstudio.github.io/profvis/) is an excellent
alternative.

1.  [Install the Go programming
    language](https://golang.org/doc/install).
2.  Ensure your system can find the Go binaries. Open your command line
    interface of choice (e.g. Terminal or Command Prompt) and type `go
    version`. If you get an error, you may need to set the `PATH`
    environment variable as described [here for
    Linux](https://www.callicoder.com/golang-installation-setup-gopath-workspace/#linux)
    and [here for
    Windows](http://www.wadewegner.com/2014/12/easy-go-programming-setup-for-windows/)
3.  Follow [these
    instructions](https://github.com/golang/go/wiki/SettingGOPATH) to
    set the `GOPATH` environment variables on your system. Type `go env
    GOPATH` in in a new terminal session verify that you set it
    correctly.
4.  Enter `go get -u github.com/google/pprof` in your terminal to
    install `pprof`
5.  Find the path to the `pprof` executable. It is usually in the `bin`
    subdirectory of `GOPATH`, e.g. `/home/landau/go/bin/pprof`.
6.  Add a line to your `.Renviron` file to set the `pprof_path`
    environment variable, e.g. `pprof_path=/home/landau/go/bin/pprof`.
    This variable tells `proffer` how to find `pprof`.
7.  Open a new R session check that pprof installed correctly.

<!-- end list -->

``` r
Sys.getenv("pprof_path")
#> /home/landau/go/bin/pprof
file.exists(Sys.getenv("pprof_path"))
#> TRUE
system2(Sys.getenv("pprof_path")) # Shows the pprof help menu on Unix systems.
shell(Sys.getenv("pprof_path")) # Analogous for Windows.
```

## Contributing

We encourage participation through
[issues](https://github.com/r-prof/proffer/issues) and [pull
requests](https://github.com/r-prof/proffer/pulls). `proffer` has a
[Contributor Code of
Conduct](https://github.com/r-prof/CODE_OF_CONDUCT.md). By contributing
to this project, you agree to abide by its terms.

# proffer 0.2.1

* Use `path.expand()` on path to profiling samples.

# proffer 0.2.0

* Deprecate `install_go()`. Visit <https://go.dev/dl/> to download the appropriate build of Go for your platform.
* Use the copy of `pprof` that comes with Go.
* Disable Go telemetry to comply with CRAN policies.

# proffer 0.1.6

* Fix `path.expand()` error when printing the port number (#30, @HenrikBengtsson).
* Use `parallelly::freePort()` to drive `random_port()` (#31, @HenrikBengtsson).
* Add the `-no_browser` flag to the `pprof` call to avoid redundant browsers.
* Update go link and go version (1.19.5).

# proffer 0.1.5

* Skip all tests on CRAN. When I submitted version 0.1.4, in the CRAN incoming pretests on 64-bit Windows R-devel (2021-07-25 r80663), the unit tests took 24 minutes to run. This length of time is certainly egregious, but I do no have access to the precise configuration of CRAN's machines, and I cannot reproduce the issue on R hub, Win Builder, or GitHub Actions. In all these latter services, the total check time is 1-2 minutes.

# proffer 0.1.4

* Choose the flame graph as the default view.

# proffer 0.1.3

* Reduce check time of examples.

# proffer 0.1.2

* Remove superfluous operator `%||%`.
* Skip Go installation tests on CRAN.

# proffer 0.1.1

* Address a CRAN check error for R-devel on Windows: lengthen the time of a test to avoid empty protocol buffers.
* Build site with GitHub Actions and use flatly theme (#26, @krlmlr).
* Ping port until `pprof` is initialized (#28).
* Improve console messages of host and port.
* Forward error message if `pprof` process quits early.

# proffer 0.1.0

* `pprof()` passes `...` to `record_pprof()` (#12, @krlmlr).
* In the `DESCRIPTION`, unquote function names and add parentheses afterwards. (CRAN comments for next submission.)
* Motivate profilers more in the README.
* Increase font size in logo.
* Search systems for `pprof` if the `pprof_path` env var is not set (#14, @krlmlr).
* Use `PROFFER_PPROF_BIN` env var instead of `pprof_path` (#11, @krlmlr). `pprof_path` is still back-compatibly supported.
* Introduce new environment variables `PROFFER_GO_BIN` and `PROFFER_GRAPHVIZ_BIN` to allow the user to set the paths to the respective binaries (#11, @krlmlr).
* Add a new `pprof_sitrep()` function to give a situation report of the `pprof` installation, its dependencies, and their environment variables (#17, @krlmlr).
* Add new function `test_pprof()`.

# proffer 0.0.2

* Respond to CRAN feedback on version 0.0.1. Software and API names in the `DESCRIPTION` now appear in single quotes, the grammatical errors are gone, and new links reference the methodological background and context of `proffer`.
* Use `processx` instead of `callr` (#5, @gaborcsardi).
* Add Graphviz installation instructions.
* Add pprof and Graphviz as system requirements.

# proffer 0.0.1

* First version.

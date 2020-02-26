# proffer 0.0.2.9000

* `pprof()` passes `...` to `record_pprof()` (#12, @krlmlr).
* In the `DESCRIPTION`, unquote function names and add parentheses afterwards. (CRAN comments for next submission.)
* Motivate profilers more in the README.
* Increase font size in logo.
* Search systems for `pprof` if the `pprof_path` env var is not set (#14, @krlmlr).
* Export `assert_pprof()` (#13, @krlmlr).
* Use `PROFFER_PPROF_PATH` env var instead of `pprof_path` (#11, @krlmlr). `pprof_path` is still back-compatibly supported.
* Introduce new environment variables `PROFFER_GO_BIN_PATH` and `PROFFER_GRAPHVIZ_PATH` to allow the user to set the paths to the respective binaries (#11, @krlmlr).

# proffer 0.0.2

* Respond to CRAN feedback on version 0.0.1. Software and API names in the `DESCRIPTION` now appear in single quotes, the grammatical errors are gone, and new links reference the methodological background and context of `proffer` (<https://github.com/google/pprof>, <https://developers.google.com/protocol-buffers>, and <https://github.com/r-prof/profile>).
* Use `processx` instead of `callr` (#5, @gaborcsardi).
* Add Graphviz installation instructions.
* Add pprof and Graphviz as system requirements.

# proffer 0.0.1

* First version.

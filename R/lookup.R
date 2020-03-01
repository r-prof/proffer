#' @title Show the path to the pprof executable.
#' @export
#' @description Defaults to the `PROFFER_PPROF_PATH` environment variable.
#'   Otherwise, it searches your Go lang installation for `pprof`.
#' @details See <https://github.com/r-prof/proffer#installation>
#'   for setup instructions.
#' @return Character, path to `pprof` it exists and `""` otherwise.
#' @examples
#' \dontrun{
#' pprof_path()
#' }
pprof_path <- function() {
  pprof_env_new() %fl% pprof_env_old() %fl% pprof_sys()
}

# Should match logic in pprof_path()
sitrep_pprof_anywhere <- function() {
  if (sitrep_pprof_env_new()) {
    return(TRUE)
  }

  if (sitrep_pprof_env_old()) {
    sitrep_pprof_old_deprecate()
    return(TRUE)
  }

  if (sitrep_pprof_sys()) {
    return(TRUE)
  }

  return(FALSE)
}

pprof_sys <- function() {
  path <- go_path()

  if (!file.exists(path)) return("")
  paste0(file.path(path, "bin", "pprof"), go_ext_sys())
}

go_path <- function() {
  path <- go_bin_path()

  if (!file.exists(path)) return("")
  with_safe_path(
    path,
    system2("go", c("env", "GOPATH"), stdout = TRUE)
  )
}

# Should match logic in
sitrep_pprof_sys <- function() {
  if (!sitrep_go_bin_anywhere()) {
    return(FALSE)
  }

  if (!sitrep_go_path()) {
    sitrep_go_path_notfound()
    return(FALSE)
  }

  if (!sitrep_pprof_go_path()) {
    sitrep_pprop_notfound()
    return(FALSE)
  }

  # Suggest adding anyway, because pprof on $PATH
  # might have different semantics
  sitrep_pprop_found_add()
  return(TRUE)
}

go_bin_path <- function() {
  go_bin_env() %fl% go_bin_sys() %fl% go_bin_win()
}

# Should match logic in go_bin_path()
sitrep_go_bin_anywhere <- function() {
  if (sitrep_go_bin_env()) {
    return(TRUE)
  }

  if (sitrep_go_bin_sys()) {
    return(TRUE)
  }

  if (sitrep_go_bin_win()) {
    return(TRUE)
  }

  sitrep_go_notfound()
  return(FALSE)
}

graphviz_path <- function() {
  graphviz_env() %fl% graphviz_sys()
}

# Should match logic in graphviz_path()
sitrep_graphviz_anywhere <- function() {
  if (sitrep_graphviz_env()) {
    return(TRUE)
  }

  if (sitrep_graphviz_sys()) {
    return(TRUE)
  }

  sitrep_graphviz_notfound()
  return(FALSE)
}

`%fl%` <- function(x, y) {
  if (!all(file.exists(x))) {
    y
  } else {
    x
  }
}

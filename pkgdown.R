pkgdown::build_site(preview = FALSE)
lines <- readLines("docs/index.html")
index <- grep("og.*/logo.png", lines)
lines[index] <- gsub(
  "/logo.png",
  "https://r-prof.github.io/proffer/reference/figures/logo.png",
  lines[index]
)
writeLines(lines, "docs/index.html")

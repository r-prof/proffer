---
name: Bottleneck
about: proffer is too slow or consumes too many resources.
title: ''
labels: 'topic: performance'
assignees: wlandau

---

## Prework

- [ ] Read and abide by `proffer`'s [code of conduct](https://github.com/wlandau/proffer/blob/master/CODE_OF_CONDUCT.md).
- [ ] Search for duplicates among the [existing issues](https://github.com/wlandau/proffer/issues), both open and closed.
- [ ] Advanced users: verify that the bottleneck still persists in the current development version (i.e. `remotes::install_github("wlandau/proffer")`) and mention the [SHA-1 hash](https://git-scm.com/book/en/v1/Getting-Started-Git-Basics#Git-Has-Integrity) of the [Git commit you install](https://github.com/wlandau/proffer/commits/master).

## Description

Describe the bottleneck clearly and concisely. 

## Reproducible example

Provide a minimal reproducible example with code and output that demonstrates the problem. The `reprex()` function from the [`reprex`](https://github.com/tidyverse/reprex) package is extremely helpful for this.

To help us read your code, please try to follow the [tidyverse style guide](https://style.tidyverse.org/). The `style_text()` and `style_file()` functions from the [`styler`](https://github.com/r-lib/styler) package make it easier.

## Benchmarks

How poorly does `proffer` perform? Feel free to use `proffer` itself to show us.

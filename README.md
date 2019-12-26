
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!--[![CRAN status](https://www.r-pkg.org/badges/version/tidySEM)](https://cran.r-project.org/package=tidySEM)
[![](https://cranlogs.r-pkg.org/badges/tidySEM)](https://cran.r-project.org/package=tidySEM)-->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/cjvanlissa/tidySEM.svg?branch=master)](https://travis-ci.org/cjvanlissa/tidySEM)
[![Codecov test
coverage](https://codecov.io/gh/cjvanlissa/tidySEM/branch/master/graph/badge.svg)](https://codecov.io/gh/cjvanlissa/tidySEM?branch=master)
<!--[![DOI](http://joss.theoj.org/papers/10.21105/joss.00978/status.svg)](https://doi.org/10.21105/joss.00978)-->

## tidySEM

tidySEM provides functionality to conduct and report structural equation
modeling analyses with existing packages, such as `lavaan` and
`MplusAutomation`. Its aim is to provide three specific functions:

1.  To generate model syntax in a top-down, tidy way,
2.  To tabulate model output in a publication-ready, uniform manner,
3.  To make easily customizable graphs for SEM-models.

These functions are designed with the [*tidy tools manifesto* (Wickham,
last updated
23-11-2019)](https://tidyverse.tidyverse.org/articles/manifesto.html) in
mind, and interface with the existing suite of packages in the
[`tidyverse`](https://tidyverse.tidyverse.org/).

## Installation

<!--You can install tidySEM from CRAN with:


```r
install.packages("tidySEM")
```
-->

You can install the development version of tidySEM from GitHub with:

``` r
install.packages("devtools")
devtools::install_github("cjvanlissa/tidySEM")
```

## Documentation

Every user-facing function in the package is documented, and the
documentation can be accessed by running `?function_name` in the R
console, e.g., `?graph`.

<!--* *Read the Introduction to tidySEM* [vignette](https://data-edu.github.io/tidySEM/articles/Introduction_to_tidySEM.html), which has much more information on the models that can be specified with tidySEM and on additional functionality-->

## Citing tidySEM

You can cite the R-package with the following citation:

> Van Lissa, C. J., (2019). tidySEM: A tidy workflow for running,
> reporting, and plotting structural equation models in lavaan or Mplus.
> \[R package\]. <https://github.com/cjvanlissa/tidySEM/>

## Contributing and Contact Information

If you have ideas, please get involved. I am currently looking for a
major contributor on this project, and smaller contributions are also
welcome. You can contribute by opening an issue on GitHub, or sending a
pull request with proposed features.

  - File a GitHub issue [here](https://github.com/cjvanlissa/tidySEM)
  - Make a pull request
    [here](https://github.com/cjvanlissa/tidySEM/pulls)

By participating in this project, you agree to abide by the [Contributor
Code of Conduct v2.0](https://www.contributor-covenant.org/).

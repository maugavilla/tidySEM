#' @title Lo-Mendell-Rubin Likelihood Ratio Test
#' @description Implements the ad-hoc adjusted likelihood ratio test (LRT)
#' described in Formula 15 of Lo, Mendell, & Rubin (2001), or LMR LRT.
#' @param x An object for which a method exists.
#' @param ... Additional arguments.
#' @return A numeric vector containing the likelihood ratio LR, the ad-hoc
#' corrected LMR, degrees of freedom, and the LMR p-value.
#' @references Lo Y, Mendell NR, Rubin DB. Testing the number of components in a
#' normal mixture. Biometrika. 2001;88(3):767–778.
#' \doi{10.1093/biomet/88.3.767}
#' @references Vuong, Q. H. (1989). Likelihood ratio tests for model selection
#' and non-nested hypotheses. Econometrica, 57, 307-333. \doi{10.2307/1912557}
#' @references Merkle, E. C., You, D., & Preacher, K. (2016). Testing non-nested
#' structural equation models. Psychological Methods, 21, 151-163.
#' \doi{10.1037/met0000038}
#' @examples
#' lr_lmr(
#'  x = list("-2LL" = -741.02,
#'    "parameters" = 8,
#'    "n" = 150,
#'    "classes" = 1),
#'  y = list("-2LL" = -488.91,
#'    "parameters" = 13,
#'    "n" = 150,
#'    "classes" = 2))
#' @rdname lr_lmr
#' @export
lr_lmr <- function(x, ...){
  UseMethod("lr_lmr", x)
}

#' @method lr_lmr tidy_fit
#' @export
lr_lmr.tidy_fit <- function(x, ...){
  numclass <- x$Classes
  if(is.null(x[["Classes"]])){
    stop("Could not determine number of classes from fit table. Make sure the column 'Classes' is included.")
  }
  if(!any(diff(numclass) > 0)){
    stop("Lo-Mendell-Rubin likelihood ratio test requires a strictly increasing number of classes. None of the rows in the fit table are in order of increasing number of classes.")
  }
  # if(!length(unique(x$n)) == 1){
  #   stop("Number of participants is not identical across latent class analyses.")
  # }
  if(!any(c("LL", "Minus2LogLikelihood", "-2LL") %in% names(x))){
    stop("Lo-Mendell-Rubin likelihood ratio test requires a column containing the log-likelihood.")
  }
  if(is.null(x[["LL"]])){
    if(!is.null(x[["Minus2LogLikelihood"]])){
      x$LL <- x[["Minus2LogLikelihood"]]/-2
    }
    if(!is.null(x[["-2LL"]])){
      x$LL <- x[["-2LL"]]/-2
    }
  }
  out <- data.frame(do.call(rbind, lapply(2:length(numclass), function(i){
    tryCatch(calc_lrt_internal(
      null = c(x$LL[i-1],
               x$Parameters[i-1],
               x$n[1],
               numclass[i-1]),
      alt  = c(x$LL[i],
               x$Parameters[i],
               x$n[1],
               numclass[i])
    ), error = function(e){NA})

  })))
  out <- rbind(rep(NA, ncol(out)), out)
  out
}

if(FALSE){
lr_lmr.mixture_list <- function(x, ...){
  mixmods <- sapply(x, function(i){
    isTRUE(inherits(i@expectation, "MxExpectationMixture") | attr(i, "tidySEM")[1] == "mixture")
  })
  if(!all(mixmods)) stop("Lo-Mendell-Rubin likelihood ratio test is only suitable for latent class analyses.")
  numclass <- sapply(x, function(i){
    max(c(1, length(names(i@submodels))))
  })
  if(!all(diff(numclass) > 0)){
    stop("Lo-Mendell-Rubin likelihood ratio test requires a strictly increasing number of classes.")
  }
}
}

#' @param y A list with elements
#' `c("-2LL", "parameters", "n", "classes")`. Note that,
#' if this argument is used, `x` must also be a list with the
#' same elements.
#' @rdname lr_lmr
#' @method lr_lmr list
#' @export
lr_lmr.list <- function(x, y, ...){
  calc_lrt_internal(unlist(x), unlist(y))
}

#' @importFrom stats pchisq
calc_lrt_internal <- function(null, alt){
  # c(ll, parameters, n, class)
  if(!alt[3] == null[3]){
    warning("Null and alt models estimated on different number of cases, and might not be nested. Used lowest number of cases.")
  }
  n <- min(c(alt[3], null[3]))
  if(!alt[4]>null[4]){
    stop("Alternative model does not have more classes than null model.")
  }
  lr_test_stat = 2 * (alt[1] - null[1])
  modlr_test_stat <- lr_test_stat / (1 + (((3 * alt[4] - 1) - (3 * null[4] - 1)) * log(n))^-1)
  df <- (alt[2] - null[2])
  lmrt_p <- pchisq(q = modlr_test_stat, df = df, lower.tail = FALSE)
  out <- c(lr = lr_test_stat, lmr_lr = modlr_test_stat, df = df, lmr_p = lmrt_p)
  names(out) <- c("lr", "lmr_lr", "df", "lmr_p")
  class(out) <- c("LRT", class(out))
  out
}

#' @method print LRT
#' @export
print.LRT <- function(x,
                      digits = 3,
                      na.print = "",
                      ...) {
  cat("Lo-Mendell-Rubin ad-hoc adjusted likelihood ratio rest:\n\n")
  cat(
    "LR = ",
    formatC(x[["lr"]], digits = digits, format = "f"),
    ", LMR LR (df = ",
    as.integer(x[["df"]]),
    ") = ",
    formatC(x[["lmr_lr"]], digits = digits, format = "f"),
    ", p ",
    ifelse(x[["lmr_p"]] < 1/10^digits,
           paste0("< ", 1/10^digits),
           paste0("= ", formatC(x[["lmr_p"]], digits = digits, format = "f")))
    , sep = "")
}


#' @method lr_lmr MxModel
#' @export
lr_lmr.MxModel <- function(x, ...){
  dots <- list(...)
  object1 <- x
  object2 <- dots[[which(sapply(dots, inherits, what = "MxModel"))]]
  vuongtest(object1, object2,
            score1 = function(x)imxRowGradients(x) * -.5,
            score2 = function(x)imxRowGradients(x) * -.5,
            dots)
}

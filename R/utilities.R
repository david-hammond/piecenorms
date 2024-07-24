#' Classified observed data into a distribution class.
#'
#' Based on a series of statistical tests, uses bootstrapping to classify
#' observed data into one of the following distributions: Binary, Uniform,
#' Normal, Lognormal, Weibull, Pareto, Exponential and Power.
#' @param x A numeric vector of observations
#' @returns character
#' @keywords internal
#'

.classify_distribution <- function(x,
                                   potential_distrs) {

  # Step 0: Check for binary data
  if (length(unique(x)) == 2) {
    return("Binary")
  } else {
    return(.classify_sample(x, potential_distrs))
  }

}


#' Helper function to classify a single sample
#'
#' @param sample sample observations
#' @param potential_distrs The types of distributions to fit
#' @returns character
#' @keywords internal

.classify_sample <- function(sample, potential_distrs) {
  tmp <- model_select(sample, potential_distrs)
  tmp <- sub(".*::d", "", attributes(tmp)$density)
  return(tmp)
}

#' Helper function to check for outliers
#'
#' @param data Observed data
#' @importFrom stats quantile
#' @returns numeric()
#' @keywords internal
.check_for_outliers <- function(data) {
  q <- quantile(data, c(0.25, 0.75))
  iqr <- diff(q)
  lower_fence <- q[1] - 1.5 * iqr
  upper_fence <- q[2] + 1.5 * iqr
  outliers <- data < lower_fence | data > upper_fence
  return(outliers)
}

#' Helper function to check for recommendations
#' @param x The observations
#' @param distr The likely distribution
#' @param outliers Does the data have IQR outliers
#' @param classint_pref The preferred classInt style
#' @param nclasses The number of desired classes for classInt
#' @param potential_distrs The types of distributions to fit
#' @importFrom classInt classIntervals
#' @importFrom univariateML model_select
#' @returns list with the following description:
#' \itemize{
#' \item norm: character() the recommended normalisation technique
#' \item breaks: numeric The recommended breaks
#' \item mdl: the `univariateML` model
#' }
#' @keywords internal
.recommend <- function(x,
                       distr,
                       outliers,
                       classint_pref,
                       nclasses,
                       potential_distrs) {
  if (is.integer(x)) {
    n <- length(unique(x)) - 1
  } else {
    n <- nclasses
  }
  if (distr == "Binary") {
    tmp <- list(norm = "minmax", brks = unique(range(x)),
                mdl = model_select(jitter(x), potential_distrs))
  } else {
    if (distr %in%
          c("unif", "norm")) {
      if (sum(outliers) == 0) {
        tmp <- list(norm = "minmax", brks = unique(range(x)),
                    mdl = model_select(x, distr))
      }
      if (sum(outliers) > 0) {
        tmp <- list(norm = "goalpost", brks = unique(range(x[!outliers])),
                    mdl = model_select(x[!outliers], distr))
      }
    } else {
      if (!is.null(n)) {
        tmp <- list(norm = classint_pref,
                    brks = unique(classIntervals(x, n = n,
                                                 style = classint_pref)$brks),
                    mdl = model_select(x, distr))
      } else {
        tmp <- list(norm = classint_pref,
                    brks = unique(classIntervals(x,
                                                 style = classint_pref)$brks),
                    mdl = model_select(x, distr))
      }
    }
  }

  return(tmp)
}

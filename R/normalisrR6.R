#' Creates a recommended classInt based on the type of distribution.
#'
#' Creates a normalisr R6 class for recommending a classInt based on the shape
#' of the distribution of the observed data
#' @importFrom R6 R6Class
#' @importFrom COINr n_prank
#' @importFrom vdiffr expect_doppelganger
#'
#' @examples
#' set.seed(12345)
#'
#' # Binary distribution test
#' x <- sample(c(0,1), 100, replace = TRUE)
#' y <- sample(c(0,1), 100, replace = TRUE)
#' mdl <- normalisr$new(x)
#' print(mdl)
#' mdl$plot()
#' mdl$hist()
#' head(mdl$as.data.frame())
#' mdl$applyto(y)
#'
#' # Uniform distribution test
#' x <- runif(100)
#' y <- runif(100)
#' mdl <- normalisr$new(x)
#' print(mdl)
#' mdl$plot()
#' mdl$hist()
#' head(mdl$as.data.frame())
#' mdl$applyto(y)
#'
#'
#' # Normal distribution tests
#' x <- rnorm(100)
#' y <- rnorm(100)
#' mdl <- normalisr$new(x)
#' print(mdl)
#' mdl$plot()
#' mdl$hist()
#' head(mdl$as.data.frame())
#' mdl$applyto(y)
#'
#' # Lognormal distribution tests
#' x <- rlnorm(100)
#' y <- rlnorm(100)
#' mdl <- normalisr$new(x)
#' print(mdl)
#' mdl$plot()
#' mdl$hist()
#' head(mdl$as.data.frame())
#' mdl$applyto(y)
#'
#' # Lognormal distribution tests with 5 classes
#' x <- rlnorm(100)
#' y <- rlnorm(100)
#' mdl <- normalisr$new(x, num_classes = 5)
#' print(mdl)
#' mdl$plot()
#' mdl$hist()
#' head(mdl$as.data.frame())
#' mdl$applyto(y)
#'
#' # Exponential distribution test
#' x <- exp(1:100)
#' y <- exp(1:100)
#' mdl <- normalisr$new(x)
#' print(mdl)
#' mdl$plot()
#' mdl$hist()
#' head(mdl$as.data.frame())
#' mdl$applyto(y)
#'
#' # Poisson distribution test
#' x <- rpois(100, lambda = 0.5)
#' y <- rpois(100, lambda = 0.5)
#' mdl <- normalisr$new(x)
#' print(mdl)
#' mdl$plot()
#' mdl$hist()
#' head(mdl$as.data.frame())
#' mdl$applyto(y)
#'
#' # Weibull distribution test
#' x <- rweibull(100, shape = 0.5)
#' y <- rweibull(100, shape = 0.5)
#' mdl <- normalisr$new(x)
#' print(mdl)
#' mdl$plot()
#' mdl$hist()
#' head(mdl$as.data.frame())
#' mdl$applyto(y)
#'
#' # Set user defined breaks
#' mdl$setManualBreaks(c(5,10))
#' print(mdl)
#' mdl$plot()
#' mdl$hist()
#' head(mdl$as.data.frame())
#' mdl$applyto(y)
#'
#' @export
#'

normalisr <- R6::R6Class("normalisr",
  #' @description
  #' Creates a new instance of this [R6][R6::R6Class]
  #' class.
  lock_objects = FALSE,
  public = list(
    #' @field data (`numeric()`)\cr
    #'   Original observations
    data = NULL,
    #' @field outliers (`logical()`)\cr
    #'   Logical vector indicating is observations are
    #'   outliers
    quantiles = NULL,
    #' @field quantiles (`numeric()`)\cr
    #'   Vector of quantiles
    outliers = NULL,
    #' @field fitted_distribution (`character()`)\cr
    #'   Suggested distribution
    fitted_distribution = NULL,
    #' @field normalisation (`character()`)\cr
    #'   Recommended class interval style based on
    #'   distribution
    normalisation = NULL,
    #' @field breaks (`numeric()`)\cr
    #'   Recommended breaks for classes
    breaks = NULL,
    #' @field number_of_classes (`numeric()`)\cr
    #'   Number of classes identified
    number_of_classes = NULL,
    #' @field normalised_data (`numeric()`)\cr
    #'   Normalised values based on recommendations
    normalised_data = NULL,
    #' @field polarity (`numeric(1)`)\cr
    #'   Which direction should the normalisation occur
    polarity = NULL,
    #' @field percentiles (`numeric()`)\cr
    #'   Observation percentiles
    percentiles = NULL,
    #' @field fittedmodel (`character()`)\cr
    #'   Fitted univariate model
    fittedmodel = NULL,
    #' @field model (`univariateML()`)\cr
    #'   Fitted univariate model parameters
    model = NULL,
    #' @description
    #' Create a new normalisr object.
    #' @param x A numeric vector of observations
    #' @param polarity Which direction should the normalisation occur, defaults
    #' to 1 but can either be:
    #' \itemize{
    #' \item \strong{1:}: Lowest value is normalised to 0, highest value is
    #' normalised to 1
    #' \item \strong{-1:} Highest value is normalised to 0, lowest value is
    #' normalised to 1
    #' }
    #' @param classint_preference Preference for classInt breaks
    #' (see `?classInt::classIntervals`)
    #' @param num_classes Preference for number of classInt breaks,
    #' defaults to Sturges number (see \cr
    #' `?grDevices::nclass.Sturges`)
    #' @param potential_distrs The types of distributions to fit,
    #' defaults to `c("unif", "power", "norm", "lnorm", "weibull",
    #' "pareto", "exp")`
    #'
    #' @return A new `normalisr` object.
    initialize = function(x,
                          polarity = 1,
                          classint_preference = "jenks",
                          num_classes = NULL,
                          potential_distrs = c("unif",
                                               "power",
                                               "norm",
                                               "lnorm",
                                               "weibull",
                                               "pareto",
                                               "exp")) {
      stopifnot("The data has no variance, execution halted." =
                  sd(x) != 0)
      self$data <- x
      self$quantiles <- quantile(x)
      self$outliers <- .check_for_outliers(x)
      self$polarity <- polarity
      tmp <-
        .classify_distribution(x, potential_distrs)
      tmp <- .recommend(x, tmp,
                        self$outliers,
                        classint_preference,
                        num_classes,
                        potential_distrs)
      self$normalisation <- tmp$norm
      self$breaks <- tmp$brks
      self$fitted_distribution <- attributes(tmp$mdl)$model
      self$distrmodel <- tmp$mdl
      self$number_of_classes <- length(tmp$brks) - 1
      self$normalised_data <-
        piecenorm(x, self$breaks, self$polarity)
      self$percentiles <- n_prank(self$normalised_data)
    },
    #' @description Prints the normalisr
    print = function() {
      cat("Likely Distribution: \n")
      print(self$fitted_distribution)
      cat("Suggested Normalisation: \n")
      print(self$normalisation)
      cat("Suggested Breaks: \n")
      print(self$breaks)
    },
    #' @description Plots the normalised values against the original
    plot = function() {
      y <- data.frame(x = self$data, y = self$normalised_data)
      y <- y[order(y$x), ]
      plot(y,
           xlab = "Original",
           ylab = "Normalised",
           type = "l")
      points(self$data, self$normalised_data)
    },
    #' @description Histogram of normalised values against the
    #' original
    hist = function() {
      # Set up the plotting area to have 2 rows and 1 column
      par(mfrow = c(2, 1))

      # Plot the original data histogram
      hist(self$data,
           main = "Original Distribution",
           xlab = "Original")

      # Plot the normalised data histogram
      hist(self$normalised_data,
           main = "Normalised Distribution",
           xlab = "Normalised")

      # Reset the plotting area to the default single plot layout
      par(mfrow = c(1, 1))
    },
    #' @description Allows user to set manual breaks
    #' @param brks User Defined Breaks
    setManualBreaks = function(brks) {
      stopifnot("Length of breaks needs to be > 1" =
                  length(brks) > 1)
      self$breaks <- brks
      self$normalisation <- "Manual Breaks"
      self$number_of_classes <- length(brks) - 1
      self$normalised_data <-
        piecenorm(self$data, brks, self$polarity)
    },
    #' @description Applies the normalisation model to new data
    #' @param x A numeric vector of observations
    applyto = function(x) {
      y <- self$clone()
      y$data <- x
      y$outliers <- .check_for_outliers(x)
      y$normalised_data <-
        piecenorm(x, y$breaks, y$polarity)
      y$percentiles <- n_prank(x)
      return(y)
    },
    #' @description Returns a data frame of the normalisation
    as.data.frame = function() {
      tmp <- data.frame(value = self$data,
                        percentile = self$percentiles)
      brks <- c(-Inf, self$breaks, Inf)
      int <- cut(self$data, breaks = brks,
                 include.lowest = TRUE)
      tmp$bins <- as.numeric(int)
      tmp$int <- int
      tmp$normalised <- self$normalised_data
      return(tmp)

    }
  )

)

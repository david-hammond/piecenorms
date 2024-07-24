#' piecenorms: Calculate a Piecewise Normalised Score Using Class Intervals
#'
#' \code{piecenorms} has been built to calculate normalised data piecewise
#' using class intervals. This is useful in communication of highly skewed data.
#'
#' For highly skewed data, the package `classInt` provides a series of options
#' for selecting class intervals. The `classInts` can be used as the breaks for
#' calculating the piecewise normalisation function `piecenorm`. The function
#' also allows the user to select their own breaks manually.
#'
#' For any call to `piecenorm`, the user provides a vector of observations,
#' a vector of breaks and a direction for the normalisation. The data is then
#' cut into classes and normalised within its class.
#'
#' Number of Bins:
#' \deqn{ n = \text{length}(\text{brks}) - 1}
#' Normalisation Class Intervals:
#' \deqn{\left(\frac{i-1}{n}, \frac{i}{n}\right] \forall i \in \{1:n\}}
#'
#' \code{piecenorms} also provide a `normalisr` R6 class that
#' \itemize{
#' \item Classifies data into a likely distribution family
#' \item Provides a recommendation of an appropriate normalisation technique
#' \item Provides functionality to apply this normalisation technique to a
#' new data set
#' }
#'
#' This is useful when the user would like to analyse how distributions have
#' changed over time.
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

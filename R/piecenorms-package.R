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
#' \strong{In cases where there is only one bin defined as `c(min(obs), max(obs))`,
#' the function `piecenorm` resolves to standard minmax normalisation}.
#'
#' The \code{piecenorms} package also provides a `normalisr` R6 class that
#' \itemize{
#' \item Classifies data into a likely distribution family
#' \item Provides a recommendation of an appropriate normalisation technique
#' \item Provides functionality to apply this normalisation technique to a
#' new data set
#' }
#'
#' This is useful when the user would like to analyse how distributions have
#' changed over time.
#'
#' @note
#' As with any non-linear transformation, piecewise normalization
#' preserves \emph{ordinal invariance} within each class but does not preserve
#' \emph{global relative magnitudes}. However, it does maintain \emph{relative
#' magnitudes within each class}. On the other hand, more standard techniques
#' like \emph{min-max} normalization preserves both \emph{ordinal invariance}
#' and \emph{global relative magnitudes}.
#'
#' Definitions of each are as follows:
#' \itemize{
#' \item \strong{Ordinal Invariance:} The property that the order of the data
#' points is preserved. If one normalized value is larger than another,
#' it reflects the same order as in the original data.
#' \item \strong{Non-Preservation of Relative Magnitudes (Global):} This refers
#' to the loss of the proportionality of the original data values when
#' normalized. If one value is twice as large as another in the original data,
#' this relationship might not be preserved in the normalized data.
#' \item \strong{Ordinal Invariance:} The property that the order of the data
#' points is preserved. If one normalized value is larger than another,
#' it reflects the same order as in the original data.
#' }
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

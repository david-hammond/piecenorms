#' Get piecewse normalised values from a vector of observations
#'
#' @param obs A vector of observations.
#' @param breaks The breaks to normalise to.
#' @param polarity Which direction should the normalisation occur.
#'
#' @importFrom dplyr group_by ungroup left_join mutate
#' @importFrom scales rescale
#' @importFrom rlang .data
#'
#' @examples
#' obs <- exp(1:10)
#' breaks <- c(min(obs), 8, 20, 100, 1000, 25000)
#' y <- piecenorm(obs, breaks)
#' plot(obs, y, type = 'l',
#' xlab = "Original Values",
#' ylab = "Normalised Values")
#'
#' @returns Vector of normalised observations
#'
#' @export

piecenorm <- function(obs, breaks, polarity = 1) {

  stopifnot("Polarity needs to be either 1 or -1." = polarity %in% c(1,-1))

  ### Calculate nbins
  nbins <- length(breaks) - 1

  ### Explain breaks and obs relations
  if (min(breaks) < min(obs)) {
    message("Note: Minimum of the breaks is lower than the
            minimum of the observations.")
    message("Proceeding with calculation, normalised
            values will have a minimum > 0")
  }
  if (max(breaks) > max(obs)) {
    message("Note: Maximum of the breaks is greater than
            the maximum of the observations.")
    message("Proceeding with calculation, normalised values
            will have a maximum < 1")
  }
  ### Do calculatation

  tmp <- obs

  ### Truncate if need be
  test1 <- obs < min(breaks)
  tmp[test1] <- min(breaks)
  test2 <- obs > max(breaks)
  tmp[test2] <- max(breaks)
  if (sum(test1) > 0 || sum(test2) > 0) {
    message("Note: Truncating observations outside of the breaks.")
  }

  ### Calculate intervals
  tmp <- data.frame(value = tmp,
                    bins = findInterval(tmp,
                                        vec = breaks,
                                        all.inside = TRUE)) |>
    ### Find upper and lower intervals
    mutate(lower = breaks[.data$bins],
           upper = breaks[.data$bins + 1]) |>
    ### Calculate class normalised equivalents
    mutate(bin_min_threshold = (.data$bins - 1) / nbins,
           bin_max_threshold = (.data$bins / nbins)) |>
    ### group_by the bin number
    group_by(.data$bins) |>
    ### rescale
    mutate(rescaled =
             rescale(.data$value,
                     from = c(unique(.data$lower),
                              unique(.data$upper)),
                     to = c(unique(.data$bin_min_threshold),
                            unique(.data$bin_max_threshold)))) |>
    ### ungroup
    ungroup()
  ### Switch polarity if needed
  if (polarity != 1) {
    tmp$rescaled <- 1 - tmp$rescaled
  }
  return(tmp$rescaled)
}

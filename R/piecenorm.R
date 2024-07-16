#' Get piecewse normalised values from a vector of observations
#'
#' @param obs A vector of observations.
#' @param breaks The breaks to normalise to.
#' @param polarity Which direction should the normalisation occur.
#'
#' @importFrom dplyr mutate
#'
#' @examples
#' obs <- exp(1:10)
#' breaks <- c(min(obs), 8, 20, 100, 1000, 25000)
#' y <- piecenorm(obs, breaks)
#' plot(obs, y, type = 'l',
#' xlab = "Original Values",
#' ylab = "Normalised Values")
#'
#' @export

piecenorm <- function(obs, breaks, polarity = 1) {
  if(min(breaks) < min(obs)) {
    message("Note: Minimum of the breaks is lower than the minimum of the observations.")
    message("Proceeding with calculation, normalised values will have a minimum > 0")
  }
  if(max(breaks) > max(obs)) {
    message("Note: Maximum of the breaks is greater than the maximum of the observations.")
    message("Proceeding with calculation, normalised values will have a maximum < 1")
  }
  tmp <- obs
  test1 <- obs < min(breaks)
  tmp[test1] <- min(breaks)
  test2 <- obs > max(breaks)
  tmp[test2] <- max(breaks)
  if (sum(test1) > 0 || sum(test2) > 0) {
    message("Note: Truncating observations outside of the breaks.")
  }
  tmp <- data.frame(value = tmp, bins = findInterval(tmp, vec = breaks, all.inside = T)) |>
    mutate(lower = breaks[.data$bins],
           upper = breaks[.data$bins+1]) |>
    left_join(.get_scaled_bins(length(breaks) - 1), by = "bins") |>
    .calculate_rescaled()
  if (polarity == -1) {
    tmp$rescaled <- 1 - tmp$rescaled
  }
  return(tmp$rescaled)
}

#' Get values goal cuts
#'
#' @param obs A vector of observations
#' @param breaks The breaks to normalise to
#'
#' @importFrom COINr n_goalposts
#'
#' @keywords internal
.get_normalisation <- function(obs, breaks) {
  if (length(breaks) == 2) {
    tmp <- n_goalposts(obs, gposts = c(breaks, 1))
  }else {
    tmp <- .calculate_rescaled(obs)
  }
  return(tmp)

}

#' Get scaled bins
#'
#' @param nbins Number of bins
#'
#' @keywords internal
#'
.get_scaled_bins <- function(nbins) {
  nbins <- data.frame(bins = seq(1:nbins)) |>
    mutate(bin_min_threshold = (.data$bins - 1) / nbins,
           bin_max_threshold = (.data$bins / nbins))
}



#' Calculate the rescaling
#'
#' @param tmp A preprocessed data frame
#' @importFrom dplyr group_by ungroup left_join
#' @importFrom scales rescale
#' @importFrom rlang .data
#'
#' @keywords internal
.calculate_rescaled <- function(tmp) {
  tmp <- tmp |>
    group_by(.data$bins) |>
    mutate(rescaled =
             rescale(.data$value,
                      from = c(unique(.data$lower),
                                            unique(.data$upper)),
                      to = c(unique(.data$bin_min_threshold),
                                          unique(.data$bin_max_threshold)))) |>
    ungroup()
  return(tmp)
}



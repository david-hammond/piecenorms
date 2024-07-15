#' Get values goal cuts
#'
#' @param x A vector of values
#' @param brks The breaks to normalise to
#' @param polarity Which direction should the normalisation occur.
#' @importFrom COINr n_goalposts
#'
#' @keywords internal
.get_normalisation <- function(x, brks, polarity) {
  if(length(brks) == 2){
    tmp = n_goalposts(x, gposts = c(goals, 1), direction = polarity)
  }else{
    tmp = .get_rescaled(x, brks, polarity)
  }

}

#' Get scaled bins
#'
#' @param nbins Number of bins
#'
#' @keywords internal
.get_scaled_bins <- function(nbins) {
  nbins <- data.frame(bins = seq(1:nbins)) |>
    mutate(bin_min_threshold = (.data$bins - 1) / nbins,
           bin_max_threshold = (.data$bins / nbins))
}

#' Get values bins
#'
#' @param x A vector of values
#' @param method The scaling method to use
#'
#' @importFrom tidyr separate
#'
#' @export

piecewise_normalisation <- function(x, brks, polarity = 1) {
  tmp <- x
  tmp[x < min(brks)] = min(brks)
  tmp[x > max(brks)] = max(brks)
  tmp <- data.frame(value = tmp, levels = cut(tmp,
                                              breaks = brks,
                                              include.lowest = T)) |>
    .extract_bins() |>
    mutate(bins = as.numeric(levels)) |>
    left_join(.get_scaled_bins(length(brks) - 1), by = "bins") |>
    .calculate_rescaled(polarity)
  return(tmp$rescaled)
}

#' Extract values bins
#'
#' @param b A preprocess data frame
#'
#' @importFrom dplyr mutate_all
#' @importFrom readr parse_number
#'
#' @keywords internal
.extract_bins <- function(b) {
  b |>
    separate(levels, c("lower", "upper"), sep = ",", remove = FALSE) |>
    mutate_at(c("lower", "upper"), parse_number)
}

#' Calculate the rescaling
#'
#' @param tmp A preprocessed data frame
#' @param polarity Which direction should the normalisation occur.
#' @importFrom dplyr group_by ungroup mutate left_join mutate_at
#' @importFrom scales rescale
#' @importFrom rlang .data
#'
#' @keywords internal
.calculate_rescaled <- function(tmp, polarity) {
  tmp <- tmp |>
    group_by(.data$bins) |>
    mutate(rescaled =
             round(scales::rescale(.data$value,
                                   from = c(unique(.data$lower),
                                            unique(.data$upper)),
                                   to = c(unique(.data$bin_min_threshold),
                                          unique(.data$bin_max_threshold))),
                   3)) |>
    ungroup()
  if (polarity == -1) {
    tmp$rescaled <- 1 - tmp$rescaled
  }
  return(tmp)
}

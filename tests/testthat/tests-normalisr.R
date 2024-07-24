test_that("returns data.frame", {
  x <- runif(100)
  mdl <- normalisr$new(x)
  expect_s3_class(mdl$as.data.frame(), "data.frame")
})

test_that("returns data.frame on new data", {
  x <- runif(100)
  y <- runif(1000)
  mdl <- normalisr$new(x)
  mdl <- mdl$applyto(y)
  test <- length(mdl$normalised_data) == length(y)
  expect_true(test)
})

test_that("check polarity positive", {
  x <- 1:100
  mdl <- normalisr$new(x, polarity = -1)
  mdl$setManualBreaks(c(1,100))
  test <- mdl$normalised_data[1] == 1 &&
    mdl$normalised_data[100] == 0
  expect_true(test)
})

test_that("check polarity negative", {
  x <- 1:100
  mdl <- normalisr$new(x, polarity = 1)
  mdl$setManualBreaks(c(1,100))
  test <- mdl$normalised_data[1] == 0 &&
    mdl$normalised_data[100] == 1
  expect_true(test)
})

test_that("returns Binary", {
  x <- sample(c(0, 1), 100, replace = TRUE)
  potential_distrs <- c("unif",
                        "power",
                        "norm",
                        "lnorm",
                        "weibull",
                        "pareto",
                        "exp")
  test <- .classify_distribution(x, potential_distrs)
  test <- test %in% c("Binary")
  expect_true(test)
})

test_that("returns string of dist", {
  x <- runif(100)
  potential_distrs <- c("unif",
                        "power",
                        "norm",
                        "lnorm",
                        "weibull",
                        "pareto",
                        "exp")
  test <- .classify_sample(x, potential_distrs)
  test <- test %in% c("unif",
                      "power",
                      "norm",
                      "lnorm",
                      "weibull",
                      "pareto",
                      "exp")
  expect_true(test)
})

test_that("returns string of dist", {
  x <- runif(100)
  potential_distrs <- c("unif",
                        "power",
                        "norm",
                        "lnorm",
                        "weibull",
                        "pareto",
                        "exp")
  test <- .classify_sample(x, potential_distrs)
  test <- test %in% c("unif",
                      "power",
                      "norm",
                      "lnorm",
                      "weibull",
                      "pareto",
                      "exp")
  expect_true(test)
})

test_that("returns logical", {
  x <- runif(100)
  test <- .check_for_outliers(x)
  expect_true(is.logical(test))
})

test_that("returns recommendation 1", {
  x <- runif(100)
  classint_pref <- "jenks"
  nclasses <- NULL
  potential_distrs <- c("unif",
                        "power",
                        "norm",
                        "lnorm",
                        "weibull",
                        "pareto",
                        "exp")
  test <- .recommend(x,
                     .classify_distribution(x, potential_distrs),
                     .check_for_outliers(x),
                     classint_pref,
                     nclasses,
                     potential_distrs)
  test <- test[[1]] %in% c("minmax", "goalposts", classint_pref)
  expect_true(test)
})

test_that("returns recommendation 2", {
  x <- runif(100)
  classint_pref <- "jenks"
  nclasses <- NULL
  potential_distrs <- c("unif",
                        "power",
                        "norm",
                        "lnorm",
                        "weibull",
                        "pareto",
                        "exp")
  test <- .recommend(x,
                     .classify_distribution(x, potential_distrs),
                     .check_for_outliers(x),
                     classint_pref,
                     nclasses,
                     potential_distrs)
  test <- is.numeric(test[[2]])
  expect_true(test)
})

test_that("returns recommendation 3", {
  x <- runif(100)
  classint_pref <- "jenks"
  nclasses <- NULL
  potential_distrs <- c("unif",
                        "power",
                        "norm",
                        "lnorm",
                        "weibull",
                        "pareto",
                        "exp")
  test <- .recommend(x,
                     .classify_distribution(x, potential_distrs),
                     .check_for_outliers(x),
                     classint_pref,
                     nclasses,
                     potential_distrs)
  test <- is.numeric(test[[3]])
  expect_true(test)
})

test_that("returns recommendation 4", {
  x <- sample(c(0, 1), 100, replace = TRUE)
  classint_pref <- "jenks"
  nclasses <- NULL
  potential_distrs <- c("unif",
                        "power",
                        "norm",
                        "lnorm",
                        "weibull",
                        "pareto",
                        "exp")
  test <- .recommend(x,
                     .classify_distribution(x, potential_distrs),
                     .check_for_outliers(x),
                     classint_pref,
                     nclasses,
                     potential_distrs)
  test <- identical(test[[2]], c(0,1))
  expect_true(test)
})

test_that("returns recommendation 5", {
  set.seed(12345)
  x <- rlnorm(100)
  classint_pref <- "jenks"
  nclasses <- NULL
  potential_distrs <- c("unif",
                        "power",
                        "norm",
                        "lnorm",
                        "weibull",
                        "pareto",
                        "exp")
  test <- .recommend(x,
                     .classify_distribution(x, potential_distrs),
                     .check_for_outliers(x),
                     classint_pref,
                     nclasses,
                     potential_distrs)
  expect_output(print(test$mdl), "Lognormal")
})

test_that("expect output", {
  x <- runif(100)
  mdl <- normalisr$new(x)
  expect_output(mdl$print(), "Likely")
})

test_that("expect plot", {
  require(vdiffr)
  set.seed(12345)
  x <- runif(100)
  mdl <- normalisr$new(x)
  expect_doppelganger("Base graphics plot", mdl$plot())
})

test_that("expect hist", {
  require(vdiffr)
  set.seed(12345)
  x <- runif(100)
  mdl <- normalisr$new(x)
  expect_doppelganger("Base graphics histogram", mdl$hist())
})

test_that("expect Manual Breaks", {
  x <- runif(100)
  mdl <- normalisr$new(x)
  mdl$setManualBreaks(c(0, 100))
  expect_output(mdl$print(), "Manual Breaks")
})

test_that("expect Manual Breaks error", {
  x <- runif(100)
  mdl <- normalisr$new(x)
  expect_error(mdl$setManualBreaks(c(100)))
})

test_that("check poisson", {
  set.seed(12345)
  x <- rpois(100, lambda = 0.5)
  mdl <- normalisr$new(x)
  test <- length(unique(x)) > length(mdl$breaks)
  expect_true(test)
})

test_that("check goalpost", {
  set.seed(12345)
  x <- c(rnorm(100),5)
  mdl <- normalisr$new(x)
  test <- mdl$normalisation == "goalpost"
  expect_true(test)
})

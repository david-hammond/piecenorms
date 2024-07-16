test_that("returns correct min", {
  x <- exp(1:10)
  brks <- c(min(x), 8, 20, 100, 1000, max(x))
  y <- piecenorm(x, brks)
  test <- min(y) == 0
  expect_true(test)
})

test_that("returns correct max", {
  x <- exp(1:10)
  brks <- c(min(x), 8, 20, 100, 1000, max(x))
  y <- piecenorm(x, brks)
  test <- max(y) == 1
  expect_true(test)
})

test_that("returns correct min greater than 0", {
  x <- exp(1:10)
  brks <- c(min(x) - 1, 8, 20, 100, 1000, max(x))
  y <- piecenorm(x, brks)
  test <- min(y) > 0
  expect_true(test)
})

test_that("returns correct max less than 1", {
  x <- exp(1:10)
  brks <- c(min(x) - 1, 8, 20, 100, 1000, max(x)+100)
  y <- piecenorm(x, brks)
  test <- max(y) < 1
  expect_true(test)
})

test_that("equals minmax", {
  x <- exp(1:10)
  brks <- c(min(x), max(x))
  y <- piecenorm(x, brks)
  z <- rescale(x)
  test <- identical(y, z)
  expect_true(test)
})

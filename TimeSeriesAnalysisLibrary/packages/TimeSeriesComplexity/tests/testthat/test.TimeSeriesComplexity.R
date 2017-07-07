context("Testing TimeSeriesComplexity")

test_that("initialize method not work correctly", {
  data <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeries$new(data, "test")
  tsc <- TimeSeriesComplexity$new(t)
  expect_is(tsc, "TimeSeriesComplexity")
  expect_error(tsc$initialize())
  expect_error(tsc$initialize(1))
})

test_that("addMeasure method not work correctly", {
  data <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeries$new(data, "test")
  tsc <- TimeSeriesComplexity$new(t)
  expect_error(tsc$addMeasure())
  expect_error(tsc$addMeasure(1))
  m <- Kolmogorov$new()
  tsc$addMeasure(m)
  expect_true(tsc$getMeasures()$size() == 1)
})

test_that("applyAll method not work correctly", {
  data <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeries$new(data, "test")
  tsc <- TimeSeriesComplexity$new(t)
  expect_error(tsc$applyAll())
  m <- Kolmogorov$new()
  tsc$addMeasure(m)
  tsc$applyAll(parallel = FALSE)
  expect_true(tsc$getComplexity()$size() == 1)
})

test_that("getComplexity method not work correctly", {
  data <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeries$new(data, "test")
  tsc <- TimeSeriesComplexity$new(t)
  expect_error(tsc$getComplexity())
})

test_that("getTimeSeries method not work correctly", {
  data <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeries$new(data, "test")
  tsc <- TimeSeriesComplexity$new(t)
  expect_is(tsc$getTimeSeries(), "TimeSeries")
})

test_that("getMeasures method not work correctly", {
  data <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeries$new(data, "test")
  tsc <- TimeSeriesComplexity$new(t)
  expect_error(tsc$getMeasures())
  m <- Kolmogorov$new()
  tsc$addMeasure(m)
  expect_is(tsc$getMeasures()$get(1), "Kolmogorov")
})



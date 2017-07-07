context("Testing TimeSeriesData")

test_that("initialize method not work correctly", {
  d <- matrix(1:40, nrow = 20, ncol = 20)
  expect_is(TimeSeriesData$new(d), "TimeSeriesData")
  expect_error(TimeSeriesData$new())
  t <- TimeSeriesData$new(d)
  expect_true(t$rows() == nrow(d))
  expect_true(all(t$toBasicCollection() == d))
})

test_that("getDates method not work correctly", {
  d <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeriesData$new(d)
  expect_error(t$getDates())
  t <- TimeSeriesData$new(d, TRUE)
  expect_true(all(t$getDates() == d[,1]))
})

test_that("getValues method not work correctly", {
  d <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeriesData$new(d, TRUE)
  expect_error(t$getValues())
  expect_error(t$getValues(-1))
  expect_error(t$getValues(0))
  expect_error(t$getValues(21))
  expect_true(all(t$getValues(1) == d[,2]))
})

test_that("getAllValues method not work correctly", {
  d <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeriesData$new(d, TRUE)
  expect_true(all(t$getAllValues() == d[,2:20]))
  t <- TimeSeriesData$new(d, FALSE)
  expect_true(all(t$getAllValues() == d))
})

test_that("getNVars method not work correctly", {
  d <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeriesData$new(d, TRUE)
  expect_true(t$getNVars() == 19)
  d <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeriesData$new(d)
  expect_true(t$getNVars() == 20)
})

test_that("getNValues method not work correctly", {
  d <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeriesData$new(d, TRUE)
  expect_true(t$getNValues() == 20)
})

test_that("withDates method not work correctly", {
  d <- matrix(1:40, nrow = 20, ncol = 20)
  t <- TimeSeriesData$new(d, TRUE)
  expect_true(t$withDates())
  t$clear()
})

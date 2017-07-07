context("Testing SineTransformation")

sineTransformation <- SineTransformation$new()

test_that("Initialize", {
  expect_is(sineTransformation, "SineTransformation")
})

test_that("apply", {
  data <- TimeSeries::TimeSeriesData$new(c(34, 25, 46))
  transformationResult <- sineTransformation$apply(data)
  
  expect_equal(transformationResult$get()$toBasicCollection(), sin(data$toBasicCollection()))
})
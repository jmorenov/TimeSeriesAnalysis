context("Testing ApplyComplexityMeasures")

applyComplexityMeasures <- ApplyComplexityMeasures$new("user", "password", c("timeSeriesId"))

test_that("Initialize", {
  expect_is(applyComplexityMeasures, "ApplyComplexityMeasures")
})
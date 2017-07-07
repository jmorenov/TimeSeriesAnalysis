context("Testing DataForecast")

test_that("DataForecast with list of methods and timeseries as argument", {
  mc <- TimeSeriesForecast::getForecastMethods(0.8)
  dc <- DataForecast$new(mc)
  expect_true(dc$nmethods() == mc$size())
  expect_true(dc$cols() == dc$nmethods())

  file <- "data/datasets_test.csv"
  fr <- DataUtils::FileReader$new(file)
  data <- fr$read()
  tt <- TimeSeries::TimeSeriesCollection$new(data = data)
  expect_is(tt$get(1), "TimeSeries")
  dc <- DataForecast$new(mc, tt)
  dc$run(FALSE)
})

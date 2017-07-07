context("Testing TimeSeriesCollection")

test_that("TimeSeriesCollection build from csv file", {
  file <- "data/datasets_test.csv"
  fr <- DataUtils::FileReader$new(file)
  data <- fr$read()
  tt <- TimeSeriesCollection$new(data = data)
})

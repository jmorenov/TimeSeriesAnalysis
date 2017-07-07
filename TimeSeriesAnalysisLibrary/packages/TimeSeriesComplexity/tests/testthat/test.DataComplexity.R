context("Testing DataComplexity")

test_that("DataComplexity with list of measures and timeseries as argument", {
  mc <- getComplexityMeasures()
  dc <- DataComplexity$new(mc)
  expect_true(dc$nmeasures() == mc$size())
  expect_true(dc$cols() == dc$nmeasures())

  file <- "data/datasets_test.csv"
  fr <- DataUtils::FileReader$new(file)
  data <- fr$read()
  tt <- TimeSeries::TimeSeriesCollection$new(data = data)
  expect_is(tt$get(1), "TimeSeries")
  dc <- DataComplexity$new(mc, tt)
  time1 <- system.time({dc$run(parallel = FALSE)})
  dcpar <- DataComplexity$new(mc, tt)
  time2 <- system.time({dcpar$run(parallel = TRUE, n_cores = 1)})
  expect_true(all(dc$toBasicCollection() == dcpar$toBasicCollection(), na.rm = T))
  dcpar <- DataComplexity$new(mc, tt)
  if (Sys.info()['sysname'] != "Windows") {
    time3 <- system.time({dcpar$run(parallel = TRUE, n_cores = 2)})
    expect_true(all(dc$toBasicCollection() == dcpar$toBasicCollection(), na.rm = T))
  }
})



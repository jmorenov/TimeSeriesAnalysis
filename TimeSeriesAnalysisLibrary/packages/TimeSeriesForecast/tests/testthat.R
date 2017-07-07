if (require(testthat)) {
  library(TimeSeriesForecast)

  testthat::test_check("TimeSeriesForecast", reporter = "Teamcity")
}

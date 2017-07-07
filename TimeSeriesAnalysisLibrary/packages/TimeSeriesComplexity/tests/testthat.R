if (require(testthat)) {
  library(TimeSeriesComplexity)

  testthat::test_check("TimeSeriesComplexity", reporter="Teamcity")
}

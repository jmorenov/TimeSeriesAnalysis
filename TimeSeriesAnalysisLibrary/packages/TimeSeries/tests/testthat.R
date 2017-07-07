if (require(testthat)) {
  library(TimeSeries)

  testthat::test_check("TimeSeries", reporter="Teamcity")
}

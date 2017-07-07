if (require(testthat)) {
  library(TimeSeriesDatabase)
  
  testthat::test_check("TimeSeriesDatabase", reporter="Teamcity")
}
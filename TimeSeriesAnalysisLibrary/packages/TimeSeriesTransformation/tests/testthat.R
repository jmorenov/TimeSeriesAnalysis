if (require(testthat)) {
  library(TimeSeriesTransformation)
  
  testthat::test_check("TimeSeriesTransformation", reporter="Teamcity")
}
if (require(testthat)) {
  library(TimeSeriesAnalysis)
  
  testthat::test_check("TimeSeriesAnalysis", reporter="Teamcity")
}
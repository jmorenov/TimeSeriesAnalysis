if (require(testthat)) {
  library(RLog)
  
  testthat::test_check("RLog", reporter="Teamcity")
}
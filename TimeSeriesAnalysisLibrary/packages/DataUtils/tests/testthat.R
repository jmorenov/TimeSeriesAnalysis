if (require(testthat)) {
  library(DataUtils)

  testthat::test_check("DataUtils", reporter = "Teamcity")
}

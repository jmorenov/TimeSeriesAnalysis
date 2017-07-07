if (require(testthat)) {
  library(Clustering)
  
  testthat::test_check("Clustering", reporter="Teamcity")
}
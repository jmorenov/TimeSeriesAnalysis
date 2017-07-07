packagesDependencies <- c("R6", "futile.logger", "testthat",  "devtools", 
                          "roxygen2", "combinat", "entropy", "e1071", 
                          "fclust", "mclust", "pracma", "rjson", "forecast", 
                          "Rcpp", "RcppArmadillo", "bigmemory", "BH", 
                          "RcppParallel", "xts", "curl", "RCurl", "openssl", 
                          "httr", "git2r", "xtable", "knitr", "formatR")
						  
for (package in packagesDependencies) {
	install.packages(package, lib = .libPaths()[[1]], repos = "http://cran.r-project.org")
	library(package, character.only = T)
}

devtools::install_github("dleutnant/influxdbr")
if (require(devtools)) {
  packages <- c("RLog", "DataUtils", "Clustering", "TimeSeries", 
                "TimeSeriesForecast", "TimeSeriesTransformation", 
                "TimeSeriesComplexity", "TimeSeriesDatabase", "TimeSeriesAnalysis")
  
  for (package in packages) {
    packageFolder <- paste0("./packages/", package)
    devtools::install(packageFolder)
    library(package, character.only = T)
  }
}
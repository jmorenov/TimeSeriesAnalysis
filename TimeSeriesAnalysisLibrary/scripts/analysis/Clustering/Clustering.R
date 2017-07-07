RLog::rlog$setLevel("DEBUG")
maxTimeSeries <- 1000
percent_train <- 0.8

RLog::rlog$debug("START clustering")

timeSeriesCollection <- TimeSeries::TimeSeriesCollection$new()
timeSeriesService <- TimeSeriesDatabase::TimeSeriesService$new("user", "password")
timeSeriesIds <- timeSeriesService$getIds(maxNValues = 600)
complexityMeasuresService <- TimeSeriesDatabase::ComplexityMeasuresService$new("user", "password")
complexityMeasuresResults <- DataUtils::DataCollection$new(ncols = 11)

RLog::rlog$debug("Getting timeseries...")
progressBar <- txtProgressBar(min = 0, max = maxTimeSeries, style = 3)

i <- 1
while (i <= maxTimeSeries) {
  complexityMeasuresResult <- complexityMeasuresService$get(timeSeriesIds[i], asDataCollection = TRUE)$getRow(1)
  
  if (anyNA(complexityMeasuresResult) || !all(is.infinite(complexityMeasuresResult) == FALSE)) {
    timeSeriesIds[i] <- NA
    timeSeriesIds <- na.omit(timeSeriesIds)
  } else {
    timeSeries <- timeSeriesService$get(timeSeriesIds[i])
    timeSeriesCollection$add(timeSeries)
    complexityMeasuresResults$addRow(complexityMeasuresResult)
    i <- i + 1
    setTxtProgressBar(progressBar, i)
  }
}
close(progressBar)

RLog::rlog$debug("Normalizing data...")
complexityMeasuresResults$normalize(-1, 1)

RLog::rlog$debug("Aplying clustering to all data...")
kmeansMethod <- Clustering::KMeans$new()
clusteringResult <- kmeansMethod$apply(complexityMeasuresResults, withCenters = TRUE)$get()
centers <- clusteringResult$centers
groups <- clusteringResult$groups

RLog::rlog$debug("Aplying forecasting...")
source("Forecasting.R")
forecastingResults <- forecasting(percent_train, timeSeriesCollection, groups)

RLog::rlog$debug("Inserting results...")
clusteringService <- TimeSeriesDatabase::ClusteringService$new("user", "password")
clusteringService$insert(list(centers = centers, methods = forecastingResults$methods))
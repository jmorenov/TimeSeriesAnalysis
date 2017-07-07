#' Compute the classification for a time series.
#'
#' @export
#'
#' @param timeseries_complexity A timeSeries id
#' @return The class of the time serie.
#' @examples
#' \dontrun{
#'   getTimeSeriesClass("ID")
#' } 
#'
#' @author Javier Moreno <javmorenov@@gmail.com>
getTimeSeriesClass <- function(timeSeriesId) {
  clusteringService <- TimeSeriesDatabase::ClusteringService$new("jmorenov", "Series,2017")
  clusteringResult <- clusteringService$get()
  centers <- clusteringResult$centers
  methods <- clusteringResult$methods
  
  applyComplexityMeasures <- TimeSeriesAnalysis::ApplyComplexityMeasures$new(c(timeSeriesId), "jmorenov", "Series,2017")
  complexityMeasuresResults <- applyComplexityMeasures$apply(insert = FALSE)
  
  # compute squared euclidean distance from each sample to each cluster center
  tmp <- sapply(seq_len(nrow(complexityMeasuresResults$toBasicCollection())),
                function(i) apply(centers, 1,
                                  function(v) sum((complexityMeasuresResults$toBasicCollection()[i, ]-v)^2)))
  center <- max.col(-t(tmp))  # find index of min distance
  
  return(list(center = center, method = methods[center]))
}
#' ApplyComplexityMeasures
#'
#' Clase que implementa los métodos para aplicar todas las medidas de complejidad
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A HttpService Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
ApplyComplexityMeasures <- R6::R6Class("ApplyComplexityMeasures",
  private = list(
    username = NA,
    password = NA,
    timeSeriesIds = NA,
  
    applyToTimeSeriesCollection = function(timeSeriesCollection, n_cores) {
      complexityMeasures <- TimeSeriesComplexity::getComplexityMeasures()
      complexityMeasuresResult <- TimeSeriesComplexity::DataComplexity$new(complexityMeasures, timeSeriesCollection)
   
      complexityMeasuresResult$run(n_cores = n_cores)
   
      return(complexityMeasuresResult)
    }
  ),
  public = list(
    initialize = function(timeSeriesIds, username, password) {
      private$username <<- username
      private$password <<- password
      private$timeSeriesIds <<- timeSeriesIds
    },
  
    apply = function(insert = TRUE, n_cores, withProgressBar = FALSE) {
      complexityMeasuresService <- TimeSeriesDatabase::ComplexityMeasuresService$new(private$username, private$password)
       
      timeSeriesService <- TimeSeriesDatabase::TimeSeriesService$new(private$username, private$password)
      timeSeriesCollection <- TimeSeries::TimeSeriesCollection$new()
       
      RLog::rlog$debug("Getting timeseries...")
      
      if (withProgressBar) {
        progressBar <- txtProgressBar(min = 0, max = length(private$timeSeriesIds), style = 3)
      }
   
      for (id in private$timeSeriesIds) {
        timeSeries <- timeSeriesService$get(id)
     
        timeSeriesCollection$add(timeSeries)
     
        if (withProgressBar) {
          setTxtProgressBar(progressBar, timeSeriesCollection$size())
        }
      }
   
      if (withProgressBar) {
        close(progressBar)
      }
   
      RLog::rlog$debug("Aplying complexity measures...")
      complexityMeasuresResult <- private$applyToTimeSeriesCollection(timeSeriesCollection, n_cores)
   
      if (insert) {
        RLog::rlog$debug("Inserting complexity measures results...")
        complexityMeasuresService$insert(complexityMeasuresResult)
      }
   
      return(complexityMeasuresResult)
    }
  )
)
#' ComplexityMeasuresService
#'
#' Clase que implementa metodos basicos para aplicar y obtener medidas de complejidad
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ComplexityMeasuresService Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
ComplexityMeasuresService <- R6::R6Class("ComplexityMeasuresService", 
  private = list(
   httpService = NA,
   baseUrl = NA,
   username = NA,
   password = NA,
   
   asDataCollection = function(dataResults) {
     complexityMeasuresNames <- dataResults[[1]]$timeSeriesComplexityMeasureType
     
     dataCollection <- DataUtils::DataCollection$new(ncols = length(complexityMeasuresNames))
     dataCollection$setColNames(complexityMeasuresNames)
     
     for (result in dataResults) {
       dataCollection$addRow(as.numeric(result$complexity), name = result$id[1])
     }
     
     return(dataCollection)
   }
  ),
  public = list(
   initialize = function(username, password) {
     private$httpService <<- HttpService$new()
     private$baseUrl <<- paste0(Config$API_HOST, "/analysis/complexitymeasure")
     private$username <<- username
     private$password <<- password
   },
   get = function(timeSeriesId, asDataCollection = FALSE) {
     complexityMeasures <- private$httpService$get(paste0(private$baseUrl, "results/", timeSeriesId))
     
     RLog::assert(!self$notFound(complexityMeasures), "Complexity measures not found")
     
     if (asDataCollection) {
       complexityMeasures <- private$asDataCollection(complexityMeasures)
     }
     
     return(complexityMeasures)
   },
   
   getInterval = function(from, to, asDataCollection = FALSE) {
     complexityMeasures <- private$httpService$get(paste0(private$baseUrl, "results/?from=", from, "&to=", to))
     
     RLog::assert(!self$notFound(complexityMeasures), "Complexity measures not found")
     
     if (asDataCollection) {
       complexityMeasures <- private$asDataCollection(complexityMeasures)
     }
     
     return(complexityMeasures)
   },
   
   notFound = function(complexityMeasures) {
     return(is.logical(complexityMeasures) && complexityMeasures == FALSE)
   },
   
   insert = function(complexityMeasures) {
     assert(!missing(complexityMeasures), 
            "Error inserting complexity measures: missing fields")
     assert("DataComplexity" %in% class(complexityMeasures), CRITICAL_ERROR)
     
     params <- list(username = private$username, 
                    password = private$password,
                    complexityMeasures = jsonlite::toJSON(complexityMeasures$getColNames()),
                    timeSeries = jsonlite::toJSON(complexityMeasures$getRowNames()),
                    results = jsonlite::toJSON(complexityMeasures$toBasicCollection()))
     
     complexityMeasures <- private$httpService$post(paste0(private$baseUrl, "insert"), params)
     
     return(complexityMeasures)
   }
  )
)
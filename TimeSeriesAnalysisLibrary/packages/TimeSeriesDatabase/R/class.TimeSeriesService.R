#' TimeSeriesService
#'
#' Clase que implementa metodos basicos para obtener series temporales 
#' de la base de datos.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export 
#' @format A TimeSeriesService Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
TimeSeriesService <- R6::R6Class("TimeSeriesService", 
  private = list(
    httpService = NA,
    baseUrl = NA,
    username = NA,
    password = NA
  ),
  public = list(
    initialize = function(username, password) {
      private$httpService <<- HttpService$new()
      private$baseUrl <<- paste0(Config$API_HOST, "/timeseries")
      private$username <<- username
      private$password <<- password
    },
    get = function(id) {
      timeSeries <- private$httpService$get(paste0(private$baseUrl, "/", id))
      
      RLog::assert(!self$notFound(timeSeries) && !self$hasError(timeSeries), "TimeSeries not found")
      
      nvalues <- length(timeSeries$data$values)
      nvars <- strtoi(timeSeries$numberOfVars)
      dates <- timeSeries$data$dates[,1]
      dataCollection <- DataUtils::DataCollection$new(nrows = nvalues, ncols = nvars + 1)
      
      dataCollection$setCol(dates, 1)
      
      for (i in 1:nvars) {
        values <- timeSeries$data$values[,i]
        dataCollection$setCol(values, i + 1)
      }
      
      timeSeriesObject <- TimeSeries::TimeSeries$new(dataCollection, timeSeries$id, haveDates = TRUE, frequency = 12)
      
      return(timeSeriesObject)
    },
    
    notFound = function(timeSeries) {
      return(is.logical(timeSeries) && timeSeries == FALSE)
    },
    
    hasError = function(timeSeries) {
      return(!is.null(timeSeries$error))
    },
    
    upload = function(timeSeriesUpload, timeSeriesFile) {
      timeSeriesUpload <- jsonlite::toJSON(timeSeriesUpload)
      params <- list(timeseries = timeSeriesUpload, username = private$username, password = private$password)
      file <- list(name = "timeseriesfile", path = timeSeriesFile)
      files <- list(file)
      
      timeSeries <- private$httpService$post(paste0(private$baseUrl), params, files)
      
      return(timeSeries)
    },
    
    getIds = function(withNValues = FALSE, maxNValues = 0) {
      timeSeriesIds <- private$httpService$get(paste0(private$baseUrl, 
                                                      "ids/?withNValues=", as.character(withNValues), 
                                                      "&maxNValues=", as.character(maxNValues)))
      
      return(timeSeriesIds)
    }
  )
)
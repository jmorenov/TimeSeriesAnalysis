#' TimeSeriesComplexity
#'
#' Clase que define la complejidad de una serie temporal mediante medidas de complejidad.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A TimeSeriesComplexity Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
TimeSeriesComplexity <- R6Class("TimeSeriesComplexity",
                                   private = list(
                                     timeSeries = NULL,
                                     measures = NULL,
                                     results = NULL
                                   ),
                                   public = list(
                                     initialize = function(timeSeries) {
                                       assert(!missing(timeSeries), CRITICAL_ERROR)
                                       assert("TimeSeries" %in% class(timeSeries), CRITICAL_ERROR)
                                       private$timeSeries <<- timeSeries$clone(deep = TRUE)
                                       private$measures <<- MethodCollection$new()
                                       private$results <<- ResultCollection$new()
                                     },
                                     addMeasure = function(cm) {
                                       private$measures$add(cm)
                                     },
                                     applyAll = function(parallel = TRUE) {
                                       private$results <<- private$measures$applyAll(private$timeSeries$data, parallel = parallel)
                                     },
                                     getComplexity = function() {
                                       assert(private$results$size() > 0, CRITICAL_ERROR)
                                       private$results
                                     },
                                     getTimeSeries = function() {
                                       assert(!is.null(private$timeSeries), CRITICAL_ERROR)
                                       private$timeSeries
                                     },
                                     getMeasures = function() {
                                       assert(private$measures$size() > 0, CRITICAL_ERROR)
                                       private$measures
                                     }
                                   ))

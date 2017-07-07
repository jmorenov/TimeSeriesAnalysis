#' ForecastResult
#'
#' Clase que define el resultado de un metodo de prediccion.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ClusteringResult Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{MethodResult}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
ForecastResult <- R6Class("ForecastResult", inherit = MethodResult,
                            private = list(
                              error = NA
                            ),
                            public = list(
                              initialize = function(name) {
                                super$initialize(name)
                              },
                              set = function(future.timeseries, error) {
                                assert(!missing(future.timeseries), CRITICAL_ERROR)
                                assert(!missing(error), CRITICAL_ERROR)
                                assert("TimeSeries" %in% class(future.timeseries) || is.na(future.timeseries), CRITICAL_ERROR)
                                private$error <<- error
                                super$set(future.timeseries)
                              },
                              getError = function() {
                                return(private$error)
                              }
                            ))

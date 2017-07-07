#' ExponentialTransformation
#'
#' Clase que sobreescribe la clase \code{\link{Transformation}} implementando
#' la transformacion exponencial
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ExponentialTransformation Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Transformation}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
ExponentialTransformation <- R6::R6Class("ExponentialTransformation", inherit = Transformation,
                                              private = list(),
                                              public = list(
                                                initialize = function() {
                                                  super$initialize("ExponentialTransformation", "Exponential transformation")
                                                },
                                                apply = function(data) {
                                                  result <- super$apply(data)

                                                  transformationResult <- exp(data$getAllValues())
                                                  newTimeSeriesData <- TimeSeriesData$new(transformationResult)
                                                  result$set(newTimeSeriesData)

                                                  result
                                                }
                                              ))

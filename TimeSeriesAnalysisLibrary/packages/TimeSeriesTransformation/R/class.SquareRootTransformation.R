#' SquareRootTransformation
#'
#' Clase que sobreescribe la clase \code{\link{Transformation}} implementando
#' la transformacion raiz cuadrada
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A SquareRootTransformation Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Transformation}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
SquareRootTransformation <- R6::R6Class("SquareRootTransformation", inherit = Transformation,
                                               private = list(),
                                               public = list(
                                                 initialize = function() {
                                                   super$initialize("SquareRootTransformation", "Square Root Transformation")
                                                 },
                                                 apply = function(data) {
                                                   result <- super$apply(data)

                                                   transformationResult <- sqrt(data$getAllValues())
                                                   newTimeSeriesData <- TimeSeriesData$new(transformationResult)
                                                   result$set(newTimeSeriesData)

                                                   result
                                                 }
                                               ))

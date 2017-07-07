#' CubicTransformation
#'
#' Clase que sobreescribe la clase \code{\link{Transformation}} implementando
#' la transformacion cubica
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A CubicTransformation Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Transformation}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
CubicTransformation <- R6::R6Class("CubicTransformation", inherit = Transformation,
                               private = list(),
                               public = list(
                                 initialize = function() {
                                   super$initialize("CubicTransformation", "Cubic transformation")
                                 },
                                 apply = function(data) {
                                   result <- super$apply(data)

                                   cubicResult <- (data$getAllValues())^3
                                   newTimeSeriesData <- TimeSeriesData$new(cubicResult)
                                   result$set(newTimeSeriesData)

                                   result
                                 }
                               ))

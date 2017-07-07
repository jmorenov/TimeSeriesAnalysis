#' AbsoluteValueTransformation
#'
#' Clase que sobreescribe la clase \code{\link{Transformation}} implementando
#' la transformacion valor absoluto
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A AbsoluteValueTransformation Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Transformation}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
AbsoluteValueTransformation <- R6::R6Class("AbsoluteValueTransformation", inherit = Transformation,
                                         private = list(),
                                         public = list(
                                           initialize = function() {
                                             super$initialize("AbsoluteValueTransformation", "Absolute Value transformation")
                                           },
                                           apply = function(data) {
                                             result <- super$apply(data)

                                             transformationResult <- abs(data$getAllValues())
                                             newTimeSeriesData <- TimeSeriesData$new(transformationResult)
                                             result$set(newTimeSeriesData)

                                             result
                                           }
                                         ))

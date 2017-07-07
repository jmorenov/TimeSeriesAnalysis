#' LogarithmicBase2Transformation
#'
#' Clase que sobreescribe la clase \code{\link{Transformation}} implementando
#' la transformacion logaritmo base 2
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A LogarithmicBase2Transformation Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Transformation}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
LogarithmicBase2Transformation <- R6::R6Class("LogarithmicBase2Transformation", inherit = Transformation,
                                               private = list(),
                                               public = list(
                                                 initialize = function() {
                                                   super$initialize("LogarithmicBase2Transformation", "Logarithmic base 2 Transformation")
                                                 },
                                                 apply = function(data) {
                                                   result <- super$apply(data)

                                                   transformationResult <- log2(data$getAllValues())
                                                   newTimeSeriesData <- TimeSeriesData$new(transformationResult)
                                                   result$set(newTimeSeriesData)

                                                   result
                                                 }
                                               ))

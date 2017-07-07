#' LempelZiv
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad Lempel-Ziv.
#' Based on https://github.com/benjaminfrot/LZ76/blob/master/C/LZ76.c
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A LempelZiv Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
LempelZiv <- R6Class("LempelZiv", inherit = ComplexityMeasure,
                     private = list(),
                     public = list(
                       initialize = function() {
                         super$initialize("LempelZiv", "Lempel-Ziv complexity measure.")
                       },
                       apply = function(data) {
                         result <- super$apply(data)
                         n <- data$getNValues()
                         b = n/log2(n)
                         k <- Kolmogorov$new()
                         result$set(k$apply(data)$get()/b)
                         return(result)
                       }
                     ))

#' AproximationEntropy
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad Aproximation Entropy del paquete pracma
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format An AproximationEntropy Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
AproximationEntropy <- R6Class("AproximationEntropy", inherit = ComplexityMeasure,
                               private = list(),
                               public = list(
                                 initialize = function() {
                                   super$initialize("AproximationEntropy",
                                                    "Aproximation Entropy complexity measure of package pracma.")
                                 },
                                 apply = function(data, edim = 2, r = 0.2*data$sd()) {
                                   result <- super$apply(data)
                                   assert(requireNamespace("pracma", quietly = TRUE), CRITICAL_ERROR)
                                   result$set(pracma::approx_entropy(data$getAllValues(), edim = edim, r = r))
                                   return(result)
                                 }
                               ))

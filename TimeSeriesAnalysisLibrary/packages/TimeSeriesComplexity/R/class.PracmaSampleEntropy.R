#' PracmaSampleEntropy
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad Sample Entropy del paquete pracma.
#'
#' Input
#' y input data
#' M maximum template length
#' r matching tolerance
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A PracmaSampleEntropy Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
PracmaSampleEntropy <- R6Class("PracmaSampleEntropy", inherit = ComplexityMeasure,
                               private = list(),
                               public = list(
                                 initialize = function() {
                                   super$initialize("PracmaSampleEntropy",
                                                    "Sample Entropy complexity measure of package Pracma.")
                                 },
                                 apply = function(data, M=2, r=0.2*data$sd()) {
                                   result <- super$apply(data)
                                   nvars <- data$getNVars()
                                   assert(requireNamespace("pracma", quietly = TRUE), CRITICAL_ERROR)
                                   for (nval in 1:nvars) {
                                     y <- data$getValues(nval)
                                     result$set(result$get() + pracma::sample_entropy(y, edim = M, r = r))
                                   }
                                   result$set(result$get()/nvars)
                                   return(result)
                                 }
                               ))

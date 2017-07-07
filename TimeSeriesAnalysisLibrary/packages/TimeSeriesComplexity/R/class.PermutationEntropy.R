#' PermutationEntropy
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad Permutation Entropy del paquete tsExpKit.
#' Using package tsExpKit (https://github.com/cbergmeir/tsExpKit).
#' Using package combinat.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A PermutationEntropy Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
PermutationEntropy <- R6Class("PermutationEntropy", inherit = ComplexityMeasure,
                              private = list(),
                              public = list(
                                initialize = function() {
                                  super$initialize("PermutationEntropy",
                                                   "Permutation Entropy complexity measure of package tsExpKit")
                                },
                                apply = function(data, order = 4) {
                                  result <- super$apply(data)
                                  result$set(tsExpKit_permutationEntropy(data$getAllValues(), order))
                                  return(result)
                                }
                              ))

#' Calculates the permutation entropy of the given order for the given series.
#'
#' Funcion obtenida de (https://github.com/cbergmeir/tsExpKit/blob/master/R/dataComplexity.R)
#' y modificada debido a un error en el codigo.
#'
#' @title calculate the permutation entropy of a given time series
#' @param ts the time series to which to apply the function
#' @param ord the order of the permutation entropy
#'
tsExpKit_permutationEntropy <- function(ts, ord=4) {
  assert(requireNamespace("combinat", quietly = TRUE), CRITICAL_ERROR)
  y <- ts
  ly <- length(ts)
  permlist <- combinat::permn(1:ord);
  vec <- seq(0,0,length = length(permlist))

  for (j in 1:(ly - ord)) {
    sort.res <- sort.int(y[j:(j + ord - 1)], index.return = TRUE);
    iv <- sort.res$ix

    for (jj in 1:length(permlist)) {
      if (sum(abs(permlist[[jj]] - iv)) == 0) {
        vec[jj] <- vec[jj] + 1 ;
      }
    }
  }

  p <- base::apply(X = as.matrix(vec / (ly - ord)),
             MARGIN = 1,
             FUN = function(x) { max(1 / ly, x) })
  e <- -sum(p * log(p))/(ord - 1)
  e

}


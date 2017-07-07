#' Devuelve una lista con todas las medidas de complejidad.
#'
#' @export
#'
#'
#' @return A MethodCollection object with all Complexity Measures.
#'
#'@examples
#' getComplexityMeasures()
#'
getComplexityMeasures <- function() {
  mc <- DataUtils::MethodCollection$new()
  mc$add(Kolmogorov$new())
  mc$add(LempelZiv$new())
  mc$add(AproximationEntropy$new())
  mc$add(PermutationEntropy$new())
  mc$add(PracmaSampleEntropy$new())
  mc$add(SampleEntropy$new())
  mc$add(ShannonEntropy$new())
  mc$add(ChaoShenEntropy$new())
  mc$add(DirichletEntropy$new())
  mc$add(MillerMadowEntropy$new())
  mc$add(ShrinkEntropy$new())
  return(mc)
}

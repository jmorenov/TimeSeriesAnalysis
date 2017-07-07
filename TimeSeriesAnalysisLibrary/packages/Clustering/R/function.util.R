#' Devuelve una lista con todos los metodos de clustering.
#'
#' @export
#'
#'
#' @return A MethodCollection object with all clustering methods.
#'
#'@examples
#' getClusteringMethods()
#'
getClusteringMethods <- function() {
  m <- DataUtils::MethodCollection$new()

  m$add(MClust$new())
  m$add(KMeans$new())
  m$add(CMeans$new())
  m$add(HClust$new())
  m$add(FuzzyClustering$new())
  m$add(FuzzyClusteringGK$new())
  m$add(FuzzyClusteringENT$new())
  m$add(FuzzyClusteringGKENT$new())
  m$add(FuzzyClusteringMED$new())
  m$add(FuzzyClusteringNOISE$new())
  m$add(FuzzyClusteringGKNOISE$new())
  m$add(FuzzyClusteringENTNOISE$new())
  m$add(FuzzyClusteringGKENTNOISE$new())
  m$add(FuzzyClusteringPF$new())
  m$add(FuzzyClusteringPFNOISE$new())

  return(m)
}

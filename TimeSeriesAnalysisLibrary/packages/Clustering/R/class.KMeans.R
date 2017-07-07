#' KMeans
#'
#' Clase abstracta que define el metodo KMeans.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A KMeans Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{NHierarchical}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
KMeans <- R6Class("KMeans", inherit = NHierarchical,
                  private = list(
                  ),
                  public = list(
                    initialize = function() {
                      super$initialize("KMeans", "KMeans method of clustering.")
                    },
                    apply = function(data, withCenters = FALSE, ...) {
                      result <- super$apply(data, ...)
                      assert(requireNamespace("stats", quietly = TRUE), CRITICAL_ERROR)
                      clusteringResult <- stats::kmeans(data$toBasicCollection(),
                                              result$getCenters()$toBasicCollection(), iter.max = 1000, algorithm = "MacQueen")
                      
                      if (withCenters) {
                        groups <- self$computeGroups(clusteringResult$cluster, result)
                        groups <- groups$get()
                        
                        result$set(list(centers = clusteringResult$centers, groups = groups))
                      } else {
                        result <- self$computeGroups(clusteringResult$cluster, result)
                      }
                      
                      return(result)
                    }
                  ))
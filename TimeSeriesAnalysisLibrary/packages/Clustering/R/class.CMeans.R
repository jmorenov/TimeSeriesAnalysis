#' CMeans
#'
#' Clase abstracta que define el metodo CMeans
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A CMeans Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{NHierarchical}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
CMeans <- R6Class("CMeans", inherit = NHierarchical,
                  private = list(
                  ),
                  public = list(
                    initialize = function() {
                      super$initialize("CMeans", "CMeans method of clustering.")
                    },
                    apply = function(data, withCenters = FALSE,  ...) {
                      result <- super$apply(data, ...)
                      assert(requireNamespace("e1071", quietly = TRUE), CRITICAL_ERROR)
                      clusteringResult <- e1071::cmeans(data$toBasicCollection(),
                                              result$getCenters()$toBasicCollection())
                      
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
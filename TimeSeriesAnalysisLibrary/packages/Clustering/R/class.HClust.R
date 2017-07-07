#' HClust
#'
#' Clase abstracta que define el metodo HClust
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A HClust Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{NHierarchical}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
HClust <- R6Class("HClust", inherit = NHierarchical,
                  private = list(
                  ),
                  public = list(
                    initialize = function() {
                      super$initialize("HClust", "HClust method of clustering.")
                    },
                    apply = function(data, ...) {
                      result <- super$apply(data, ...)
                      if (requireNamespace("fastcluster", quietly = TRUE))
                        h <- fastcluster::hclust(data$distance())
                      else {
                        assert(requireNamespace("stats", quietly = TRUE), CRITICAL_ERROR)
                        h <- stats::hclust(data$distance())
                      }
                      groups <- stats::cutree(h, k = result$getCenters()$rows())
                      return(self$computeGroups(groups, result))
                    }
                  ))
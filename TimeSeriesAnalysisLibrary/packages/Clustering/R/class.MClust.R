#' MClust
#'
#' Clase abstracta que define el metodo MClust
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A MClust Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Hierarchical}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
MClust <- R6Class("MClust", inherit = Hierarchical,
                        private = list(
                        ),
                        public = list(
                          initialize = function() {
                            super$initialize("MClust", "MClust method of clustering.")
                          },
                          apply = function(data, ...) {
                            result <- super$apply(data, ...)
                            assert(requireNamespace("mclust", quietly = TRUE), CRITICAL_ERROR)
                            groups <- mclust::Mclust(data$toBasicCollection())$classification
                            return(self$computeGroups(groups, result))
                          }
                        ))

#' Function to call mclustBIC.
#'
#' @param ... arguments for the call of the function mclustBIC.
#'
#' @return mclustBIC object.
#' @export
#'
mclustBIC <- function(...) {
  mclust::mclustBIC(...)
}


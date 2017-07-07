#' NHierarchical
#'
#' Clase abstracta que define metodos de tipo no jerarquico.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A NHierarchical Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ClusteringMethod}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
NHierarchical <- R6Class("NHierarchical", inherit = ClusteringMethod,
                        private = list(
                          methodCenters = NULL
                        ),
                        public = list(
                          initialize = function(name, description = "", methodCenters = NULL){
                            super$initialize(name, description)
                            self$setMethodCenters(methodCenters)
                          },
                          setMethodCenters = function(methodCenters) {
                            assert(!missing(methodCenters), CRITICAL_ERROR)
                             if (!is.null(methodCenters)) {
                              assert("CentersMethod" %in% class(methodCenters), CRITICAL_ERROR)
                              private$methodCenters <<- methodCenters$clone(deep = TRUE)
                            }
                          },
                          calculateCenters = function(data) {
                            assert(!missing(data), CRITICAL_ERROR)
                            assert("DataCollection" %in% class(data), CRITICAL_ERROR)
                            if (is.null(private$methodCenters)) private$methodCenters <<- Chiu$new()
                            return(private$methodCenters$apply(data))
                          },
                          apply = function(data, ...) {
                            assert(!missing(data), CRITICAL_ERROR)
                            result <- NHierarchicalClusteringResult$new(self$getName())
                            params <- list(...)
                            centers <- params$centers
                            if (is.null(centers))
                              result$setCenters(self$calculateCenters(data))
                            else {
                              assert("CentersResult" %in% class(centers), CRITICAL_ERROR)
                              result$setCenters(centers)
                            }
                            return(result)
                          }
                        ))

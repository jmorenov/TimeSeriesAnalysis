#' NHierarchicalClusteringResult
#'
#' Clase que define el resultado de un metodo de clustering no jerarquico.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A NHierarchicalClusteringResult Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ClusteringResult}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
NHierarchicalClusteringResult <- R6Class("NHierarchicalClusteringResult", inherit = ClusteringResult,
                            private = list(
                              centers = NULL
                            ),
                            public = list(
                              initialize = function(name) {
                                super$initialize(name)
                              },
                              setCenters = function(centers) {
                                assert(!missing(centers), CRITICAL_ERROR)
                                assert("CentersResult" %in% class(centers), CRITICAL_ERROR)
                                private$centers <<- centers$clone(deep = TRUE)
                              },
                              getCenters = function() {
                                assert(!is.null(private$centers), CRITICAL_ERROR)
                                return(private$centers$get())
                              },
                              ncenters = function() {
                                assert(!is.null(private$centers), CRITICAL_ERROR)
                                return(private$centers$ncenters())
                              }
                            ))

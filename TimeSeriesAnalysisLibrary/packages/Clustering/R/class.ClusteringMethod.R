#' ClusteringMethod
#'
#' Clase abstracta que define metodos generales para implementar un metodo de clustering.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ClusteringMethod Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Method}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
ClusteringMethod <- R6Class("ClusteringMethod", inherit = Method,
                                private = list(
                                ),
                                public = list(
                                  initialize = function(name, description = ""){
                                    super$initialize(name, description)
                                  },
                                  apply = function(data, ...) {
                                    assert("DataCollection" %in% class(data), CRITICAL_ERROR)
                                    result <- ClusteringResult$new(self$getName())
                                    return(result)
                                  },
                                  computeGroups = function(groups, result) {
                                    r <- Collection$new(type = "integer")
                                    for (i in 1:length(groups)) r$add(groups[[i]])
                                    result$set(r)
                                    return(result)
                                  }
                                ))

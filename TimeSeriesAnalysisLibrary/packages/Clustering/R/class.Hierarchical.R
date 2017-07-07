#' Hierarchical
#'
#' Clase abstracta que define metodos de tipo jerarquico.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Hierarchical Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ClusteringMethod}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
Hierarchical <- R6Class("Hierarchical", inherit = ClusteringMethod,
                            private = list(
                            ),
                            public = list(
                              initialize = function(name, description = ""){
                                super$initialize(name, description)
                              }
                            ))

#' ClusteringResult
#'
#' Clase que define el resultado de un metodo de clustering.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ClusteringResult Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{MethodResult}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
ClusteringResult <- R6Class("ClusteringResult", inherit = MethodResult,
                        private = list(
                        ),
                        public = list(
                          initialize = function(name) {
                            super$initialize(name)
                          },
                          set = function(groups) {
                            assert(!missing(groups), CRITICAL_ERROR)
                            super$set(groups)
                          },
                          ncenters = function() {
                            return(max(super$get()$toBasicCollection()))
                          },
                          timeseries.centers = function() {
                            return(timeseries_in_centers(super$get()$toBasicCollection(), self$ncenters()))
                          }
                        ))

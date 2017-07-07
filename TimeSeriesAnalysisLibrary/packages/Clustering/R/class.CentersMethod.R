#' CentersMethod
#'
#' Clase abstracta que define metodos para el calculo de centros para clustering.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A CentersMethod Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Method}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
CentersMethod <- R6Class("CentersMethod", inherit = Method,
                            private = list(
                            ),
                            public = list(
                              initialize = function(name, description = ""){
                                super$initialize(name, description)
                              },
                              apply = function(data) {
                                assert("DataCollection" %in% class(data), CRITICAL_ERROR)
                                result <- CentersResult$new(self$getName())
                                return(result)
                              }
                            ))

#' CentersResult
#'
#' Clase que define el resultado de un metodo de calculo de centros para clustering.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A CentersResult Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{MethodResult}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
CentersResult <- R6Class("CentersResult", inherit = MethodResult,
                            private = list(
                            ),
                            public = list(
                              initialize = function(name) {
                                super$initialize(name)
                              },
                              set = function(centers) {
                                assert(!missing(centers), CRITICAL_ERROR)
                                assert("DataCollection" %in% class(centers), CRITICAL_ERROR)
                                centers_unique <- DataCollection$new(data = unique(centers$toBasicCollection()))
                                super$set(centers_unique)
                              },
                              ncenters = function() {
                                assert(!is.null(self$get()), CRITICAL_ERROR)
                                self$get()$rows()
                              }
                            ))

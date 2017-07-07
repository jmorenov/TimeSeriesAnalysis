#' MethodResult
#'
#' Clase que define un resultado de un metodo.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A MethodResult Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Result}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
MethodResult <- R6Class("MethodResult", inherit = Result,
                        private = list(
                          methodName = NA
                        ),
                        public = list(
                          initialize = function(name) {
                            assert(!missing(name), CRITICAL_ERROR)
                            assert(is.character(name), CRITICAL_ERROR)
                            super$initialize()
                            private$methodName <<- name
                          },
                          getMethod = function() {
                            private$methodName
                          }
                        ))

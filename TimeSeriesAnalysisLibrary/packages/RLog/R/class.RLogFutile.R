#' RLogFutile
#'
#' Clase que sobreescribe los metodos definidos por la clase abstracta \code{\link{RLogBase}}
#' y usa como logger el paquete futile.logger
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A RLogFutile Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{RLogBase}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
RLogFutile <- R6Class("RLogFutile",inherit = RLogBase,
                      public = list(
                        initialize = function(..., level = "ERROR") {
                          super$initialize(...)
                          self$setLevel(level)
                        },
                        setLevel = function(level) {
                          super$setLevel(level)
                          invisible(futile.logger::flog.threshold(super$getLevel()))
                        },
                        info = function(...) {
                          futile.logger::flog.info(as.character(...))
                        },
                        error = function(...) {
                          futile.logger::flog.error(as.character(...))
                        },
                        warn = function(...) {
                          futile.logger::flog.warn(as.character(...))
                        },
                        debug = function(...) {
                          futile.logger::flog.debug(as.character(...))
                        }
                      ))

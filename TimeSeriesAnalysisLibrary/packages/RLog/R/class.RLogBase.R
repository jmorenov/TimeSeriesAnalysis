#' RLogBase
#'
#' Clase que implementa metodos basicos para definir mensajes de log.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A RLogBase Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
RLogBase <- R6Class("RLogBase",
                    private = list(
                      level = "ERROR"
                    ),
                    public = list(
                      initialize = function(..., level = "ERROR") {
                        private$level <<- level
                      },
                      setLevel = function(level) {
                        private$level <<- level
                      },
                      getLevel = function() {
                        private$level
                      },
                      info = function(...) {
                        message("INFO: ", as.character(...))
                      },
                      error = function(..., call = FALSE) {
                        stop(as.character(...), call. = call)
                      },
                      warn = function(..., call = FALSE) {
                        warning(as.character(...), call. = call)
                      },
                      debug = function(...) {
                        message("DEBUG: ", as.character(...))
                      }
                    ))

# trycatch <- function(..., stopiferror=F) {
#   result <- tryCatch(...,
#            error = function(e) {
#              if (stopiferror)
#                 stop(e)
#              else
#                 rlog.error(e)
#              },
#            warning = function(w) {rlog.warn(w)})
#   return (result)
# }

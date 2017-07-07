#' Result
#'
#' Clase que define un resultado.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Result Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
Result <- R6Class("Result",
                  private = list(
                    value = NA
                  ),
                  public = list(
                    initialize = function(value) {
                      if (!missing(value)) private$value <<- value
                    },
                    set = function(value) {
                      assert(!missing(value), CRITICAL_ERROR)
                      private$value <<- value
                    },
                    get = function() {
                      private$value
                    }
                  ))

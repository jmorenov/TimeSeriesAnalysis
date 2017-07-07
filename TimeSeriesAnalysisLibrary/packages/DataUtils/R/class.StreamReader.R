#' StreamReader
#'
#' Clase almacena resultados de complejidad sobre series temporales en
#' forma de matrix usando la clase \code{\link{DataCollection}}
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A StreamReader Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
StreamReader <- R6Class("StreamReader",
                        private = list(
                          stream = NA
                        ),
                        public = list(
                          initialize = function(stream) {
                            private$stream <<- stream
                          },
                          read = function() {

                          },
                          getStreamName = function() {
                            return(private$stream)
                          }
                        ))

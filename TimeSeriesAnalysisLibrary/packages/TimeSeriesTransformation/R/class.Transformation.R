#' Transformation
#'
#' Clase abstracta que define los metodos para implementar una transformacion.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Transformation Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Method}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
Transformation <- R6::R6Class("Transformation", inherit = Method,
                             private = list(),
                             public = list(
                               initialize = function(name, description = ""){
                                 super$initialize(name, description)
                               },
                               apply = function(data) {
                                 assert("TimeSeriesData" %in% class(data), CRITICAL_ERROR)
                                 result <- super$apply(data)
                                 return(result)
                               }
                             ))

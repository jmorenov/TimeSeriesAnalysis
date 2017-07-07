# *------------------------------------------------------------------
# | PROGRAM NAME:
# | DATE:
# | CREATED BY:
# | PROJECT FILE:
# *----------------------------------------------------------------
# | PURPOSE:
# |
# *------------------------------------------------------------------
# | COMMENTS:
# |
# |  1:
# |  2:
# |  3:
# |*------------------------------------------------------------------
# | DATA USED:
# |
# |
# |*------------------------------------------------------------------
# | CONTENTS:
# |
# |  PART 1:
# |  PART 2:
# |  PART 3:
# *-----------------------------------------------------------------
# | UPDATES:
# |
# |
# *------------------------------------------------------------------
#' ComplexityMeasure
#'
#' Clase abstracta que define los metodos para implementar una medida de complejidad.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ComplexityMeasure Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Method}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
ComplexityMeasure <- R6Class("ComplexityMeasure", inherit = Method,
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

#' Method
#'
#' Clase que define un metodo a aplicar.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Method Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
Method <- R6Class("Method",
                     private = list(
                       name = NA,
                       description = NA
                     ),
                     public = list(
                       initialize = function(name, description) {
                         assert(!missing(name), CRITICAL_ERROR)
                         assert(is.character(name), CRITICAL_ERROR)
                         private$name <<- name
                         if (!missing(description)) private$description <<- description
                       },
                       apply = function(data) {
                         assert("DataCollection" %in% class(data), CRITICAL_ERROR)
                         result <- MethodResult$new(self$getName())
                         result$set(0)
                         return(result)
                       },
                       getName = function() {
                         private$name
                       },
                       getDescription = function() {
                         private$description
                       }
                     ))

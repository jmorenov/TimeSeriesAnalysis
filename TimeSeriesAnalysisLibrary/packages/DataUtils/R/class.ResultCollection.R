#' ResultCollection
#'
#' Clase que sobreescribe la clase \code{\link{Collection}} implementando
#' una coleccion de resultados.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ResultCollection Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Collection}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
ResultCollection <- R6Class("ResultCollection", inherit = Collection,
                            private = list(),
                            public = list(
                              initialize = function(n = 0) {
                                super$initialize(n, Result)
                              },
                              toBasicCollection = function() {
                                assert(self$size() > 0, CRITICAL_ERROR)
                                results <- list()
                                for (i in 1:self$size()) {
                                  if (!is.null(self$get(i)))
                                    results[[i]] <- self$get(i)$get()
                                }
                                return(results)
                              }
                            ))

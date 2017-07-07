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
#' MethodCollection
#'
#' Clase que sobreescribe la clase \code{\link{Collection}} implementando
#' una coleccion de metodos a aplicar.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A MethodCollection Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Collection}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
MethodCollection <- R6Class("MethodCollection", inherit = Collection,
                            private = list(
                            ),
                            public = list(
                              initialize = function(n = 0) {
                                super$initialize(n, Method)
                              },
                              applyAll = function(data, parallel = TRUE, n_cores, ...) {
                                assert(self$size() > 0, CRITICAL_ERROR)
                                # assert("DataCollection" %in% class(data), CRITICAL_ERROR)
                                results <- ResultCollection$new()
                                apply_i <- function(i) {
                                  result <- tryCatch({
                                    # rlog$debug(self$get(i)$getName())
                                    self$get(i)$apply(data, ...)
                                  },
                                  error = function(cond) {
                                    rlog$error(paste("Method: ", self$get(i)$getName(), cond))
                                    r <- MethodResult$new(self$get(i)$getName())
                                    r$set(NA)
                                    r
                                  },
                                  warning = function(cond) {
                                    rlog$warn(paste("Method: ", self$get(i)$getName(), cond))
                                    r <- MethodResult$new(self$get(i)$getName())
                                    r$set(NA)
                                    r
                                  })
                                  return(result)
                                }

                                if (parallel && requireNamespace("parallel", quietly = TRUE)) {
                                  if (missing(n_cores) || is.null(n_cores)) n_cores <- parallel::detectCores()
                                  resultspar <- parallel::mclapply(1:self$size(), apply_i, mc.cores = n_cores, mc.silent = FALSE)
                                  for (i in 1:length(resultspar))
                                    results$add(resultspar[[i]])
                                } else {
                                  for (i in 1:self$size()) {
                                    results$add(apply_i(i))
                                  }
                                }
                                return(results)
                              }
                            ))

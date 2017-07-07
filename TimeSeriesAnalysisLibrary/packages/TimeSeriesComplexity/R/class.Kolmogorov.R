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
#' Kolmogorov
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad Kolmogorov.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Kolmogorov Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
Kolmogorov <- R6Class("Kolmogorov", inherit = ComplexityMeasure,
                      private = list(),
                      public = list(
                        initialize = function() {
                          super$initialize("Kolmogorov", "Kolmogorov complexity measure.")
                        },
                        apply = function(data) {
                          result <- super$apply(data)
                          nvalues <- data$getNValues()
                          nvars <- data$getNVars()
                          for (nval in 1:nvars) {
                            threshold <- data$mean(nval)
                            values <- data$getValues(nval)
                            s <- vector()
                            for (i in 1:nvalues) {
                              if (values[i] < threshold) s[i] <- 0
                              else s[i] <- 1
                            }
                            n = length(s)
                            c = l = k = kmax = 1
                            i = end = 0
                            while (end == 0) {
                              if (s[i + k] != s[l + k]) {
                                if (k > kmax) {
                                  kmax = k
                                }
                                i = i + 1
                                if (i == l) {
                                  c = c + 1
                                  l = l + kmax
                                  if (l + 1 > n) end = 1
                                  else {
                                    i = 0
                                    k = kmax = 1
                                  }
                                } else {
                                  k = 1
                                }
                              } else {
                                k = k + 1
                                if (l + k > n) {
                                  c = c + 1
                                  end = 1
                                }
                              }
                            }
                            result$set(result$get() + c)
                          }
                          result$set(result$get()/nvars)
                          result
                        }
                      ))

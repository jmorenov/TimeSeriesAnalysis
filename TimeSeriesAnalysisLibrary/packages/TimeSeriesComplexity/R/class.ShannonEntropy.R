#' ShannonEntropy
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad ShannonEntropy del paquete entropy
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ShannonEntropy Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
ShannonEntropy <- R6Class("ShannonEntropy", inherit = ComplexityMeasure,
                          private = list(),
                          public = list(
                            initialize = function() {
                              super$initialize("ShannonEntropy",
                                               "Shannon Entropy complexity measure of package entropy.")
                            },
                            apply = function(data) {
                              result <- super$apply(data)
                              assert(require(entropy, quietly = T, warn.conflicts = F), CRITICAL_ERROR)
                              result$set(entropy::entropy(data$getAllValues(), method = "ML", verbose = F))
                              return(result)
                            }
                          ))

#' ChaoShenEntropy
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad ChaoShenEntropy del paquete entropy
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ChaoShenEntropy Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
ChaoShenEntropy <- R6Class("ChaoShenEntropy", inherit = ComplexityMeasure,
                          private = list(),
                          public = list(
                            initialize = function() {
                              super$initialize("ChaoShenEntropy",
                                               "ChaoShen Entropy complexity measure of package entropy.")
                            },
                            apply = function(data) {
                              result <- super$apply(data)
                              assert(require(entropy, quietly = T, warn.conflicts = F), CRITICAL_ERROR)
                              result$set(entropy::entropy(data$getAllValues(), method = "CS", verbose = F))
                              return(result)
                            }
                          ))

#' DirichletEntropy
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad DirichletEntropy del paquete entropy
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A DirichletEntropy Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
DirichletEntropy <- R6Class("DirichletEntropy", inherit = ComplexityMeasure,
                           private = list(
                             method = NA
                           ),
                           public = list(
                             initialize = function(method = "SG") {
                               assert(method %in% c("Jeffreys", "Laplace", "SG", "minimax"), CRITICAL_ERROR)
                               private$method <<- method
                               super$initialize("DirichletEntropy",
                                                "Dirichlet Entropy complexity measure of package entropy.")
                             },
                             apply = function(data) {
                               result <- super$apply(data)
                               assert(require(entropy, quietly = T, warn.conflicts = F), CRITICAL_ERROR)
                               result$set(entropy::entropy(data$getAllValues(), method = private$method, verbose = F))
                               return(result)
                             }
                           ))

#' MillerMadowEntropy
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad MillerMadowEntropy del paquete entropy
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A MillerMadowEntropy Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
MillerMadowEntropy <- R6Class("MillerMadowEntropy", inherit = ComplexityMeasure,
                           private = list(),
                           public = list(
                             initialize = function() {
                               super$initialize("MillerMadowEntropy",
                                                "MillerMadow Entropy complexity measure of package entropy.")
                             },
                             apply = function(data) {
                               result <- super$apply(data)
                               assert(require(entropy, quietly = T, warn.conflicts = F), CRITICAL_ERROR)
                               result$set(entropy::entropy(data$getAllValues(), method = "MM", verbose = F))
                               return(result)
                             }
                           ))

#' ShrinkEntropy
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad ShrinkEntropy del paquete entropy
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ShrinkEntropy Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
ShrinkEntropy <- R6Class("ShrinkEntropy", inherit = ComplexityMeasure,
                              private = list(),
                              public = list(
                                initialize = function() {
                                  super$initialize("ShrinkEntropy",
                                                   "Shrink Entropy complexity measure of package entropy.")
                                },
                                apply = function(data) {
                                  result <- super$apply(data)
                                  assert(require(entropy, quietly = T, warn.conflicts = F), CRITICAL_ERROR)
                                  result$set(entropy::entropy(data$getAllValues(), method = "shrink", verbose = F))
                                  return(result)
                                }
                              ))


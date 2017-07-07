#' SampleEntropy
#'
#' Clase que sobreescribe la clase \code{\link{ComplexityMeasure}} implementando
#' la medida de complejidad Sample Entropy.
#' Based on: http://www.physionet.org/physiotools/sampen/matlab/1.1/sampenc.m
#'
#' Input
#' y input data
#' M maximum template length
#' r matching tolerance
#
#' Output
#' e sample entropy estimates for m<-0,1,...,M-1
#' A number of matches for m<-1,...,M
#' B number of matches for m<-0,...,M-1 excluding last point
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A SampleEntropy Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ComplexityMeasure}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
SampleEntropy <- R6Class("SampleEntropy", inherit = ComplexityMeasure,
                         private = list(
                         ),
                         public = list(
                           initialize = function() {
                             super$initialize("SampleEntropy", "Sample Entropy complexity measure.")
                           },
                           apply = function(data, M=2, r=0.2*data$sd()) {
                             result <- super$apply(data)
                             # nvalues <- data$getNValues()
                             nvars <- data$getNVars()
                             for (nval in 1:nvars) {
                               y <- data$getValues(nval)
                               n <- length(y)
                               lastrun <- matrix(0,1,n)
                               run <- matrix(0,1,n)
                               A <- matrix(0,M,1)
                               B <- matrix(0,M,1)
                               p <- matrix(0,M,1)
                               # e <- matrix(0,M,1)
                               for (i in 1:(n - 1)) {
                                 nj <- n - i
                                 y1 <- y[i]
                                 for (jj in 1:nj) {
                                   j <- jj + i
                                   if (abs(y[j] - y1) < r) {
                                     run[jj] <- lastrun[jj] + 1
                                     M1 <- min(M, run[jj])
                                     for (m in 1:M1) {
                                       A[m] <- A[m] + 1
                                       if (j < n)
                                         B[m] <- B[m] + 1
                                     }
                                   }
                                   else
                                     run[jj] <- 0
                                 }
                                 for (j in 1:nj) {
                                   lastrun[j] <- run[j]
                                 }
                               }
                               N <- n * (n - 1)/2
                               p <- c(A[1]/N)
                               for (m in 2:M) {
                                 p1 <- A[m] / B[m - 1]
                                 if (!is.nan(p1) && p1 != 0)
                                   p <- c(p, p1)
                               }
                               result$set(result$get() + sum(-p*log(p)))
                             }
                             result$set(result$get()/nvars)
                             return(result)
                           }
                         ))

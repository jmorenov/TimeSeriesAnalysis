#' Chiu
#'
#' Clase abstracta que define el metodo de calculo de centros Chiu para clustering.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Chiu Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{CentersMethod}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
Chiu <- R6Class("Chiu", inherit = CentersMethod,
                         private = list(
                         ),
                         public = list(
                           initialize = function(){
                             super$initialize("Chiu", "Chiu method for centers of clustering calculation.")
                           },
                           apply = function(data, r.a = 0.5, eps.high = 0.5, eps.low = 0.15, big_matrix = TRUE) {
                             assert(!missing(data), CRITICAL_ERROR)
                             result <- super$apply(data)

                             alpha <- 4 / ((r.a) ^ 2)
                             beta <- 4 / (1.5 * r.a) ^ 2
                             data <- data$toBasicCollection()
                             n <- nrow(data)

                             if (n >= 10000 || big_matrix) {
                               assert(requireNamespace("bigmemory", quietly = TRUE), CRITICAL_ERROR)
                               exponential <- DataCollection$new(nrows = n, ncols = n, init = 1, big_matrix = TRUE)
                               potential <- DataCollection$new(nrows = n, ncols = 1, init = 1, big_matrix = TRUE)
                               if (bigmemory::is.big.matrix(data))
                                 BigExpPot(data@address,
                                           exponential$toBasicCollection()@address,
                                           potential$toBasicCollection()@address, alpha)
                               else
                                 BigExpPot(bigmemory::as.big.matrix(data)@address,
                                           exponential$toBasicCollection()@address,
                                           potential$toBasicCollection()@address, alpha)
                               exponential <- exponential$toBasicCollection()
                               potential <- potential$toBasicCollection()
                               potential <- potential[,]
                             } else {
                               exponential <- base::apply(data, 1, FUN = function(x) exp(sqrt(colSums((x - t(data)) ^ 2)) ^ 2))
                               potential <- base::apply(exponential, 1, FUN = function(x) sum(x ^ -alpha))
                             }
                             centers.index <- c(which.max(potential))
                             k1 <- centers.index[1]
                             pot_k1 <- potential[k1]
                             for (i in 2:n) {
                               potential <- potential - (potential[k1]*(exponential[,k1] ^ -beta))
                               k <-  which.max(potential)
                               pot_k <- potential[k]

                               if (pot_k > eps.high * pot_k1) {
                                 centers.index <- c(centers.index, k)
                                 k1 <- k
                                 pot_k1 <- pot_k
                               } else if (pot_k < eps.low * pot_k1) break
                               else {
                                 # CHECK DMIN!!!!!
                                 dmin <- min(mapply(centers.index, FUN = function(x) dist(rbind(data[k,], data[x,]))))
                                 if ((dmin/r.a) + (pot_k/pot_k1) >= 1) {
                                   centers.index <- c(centers.index, k)
                                   k1 <- k
                                   pot_k1 <- pot_k
                                 }
                                 else potential[k] <- 0
                               }
                             }
                             data <- DataCollection$new(data)
                             r <- DataCollection$new(ncols = data$cols())
                             for (i in centers.index)
                               r$addRow(data$getRow(i))
                             result$set(r)
                             return(result)
                           },
                           fastApply = function(data, r.a = 0.5, eps.high = 0.5, eps.low = 0.15, big_matrix = TRUE) {
                             assert(!missing(data), CRITICAL_ERROR)
                             assert(requireNamespace("bigmemory", quietly = TRUE), CRITICAL_ERROR)
                             result <- super$apply(data)
                             n <- data$rows()
                             data <- data$toBasicCollection()
                             exponential <- DataCollection$new(nrows = n, ncols = n, init = 1, big_matrix = TRUE)
                             potential <- DataCollection$new(nrows = n, ncols = 1, init = 1, big_matrix = TRUE)
                             centers <- ChiuMethod(bigmemory::as.big.matrix(data)@address,
                                             exponential$toBasicCollection()@address,
                                             potential$toBasicCollection()@address,
                                             r.a, eps.high, eps.low)
                             # centers <- c(1, 2, 3)
                             r <- DataCollection$new(centers)
                             result$set(r)
                             return(result)
                           }
                         ))

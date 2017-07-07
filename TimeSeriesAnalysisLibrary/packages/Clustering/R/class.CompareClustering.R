#' CompareClustering
#'
#' Clase que compara dos resultados de clustering.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A CompareClustering Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#'
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
CompareClustering <- R6Class("CompareClustering",
                             private = list(
                               cluster_1 = NULL,
                               cluster_2 = NULL,
                               similarility_matrix = NULL,
                               similarility_matrix_order = NULL,
                               max_diff = NULL,
                               centers_1 = NULL,
                               centers_2 = NULL,
                               clust.diff = function(ki, kj) {
                                 c <- intersect(ki, kj)
                                 (length(c)/max(length(ki), length(kj)))*100
                               }
                             ),
                             public = list(
                               initialize = function(cluster_1, cluster_2) {
                                 assert(!missing(cluster_1) && !missing(cluster_2), CRITICAL_ERROR)
#                                  assert("NHierarchicalClusteringResult" %in% class(cluster_1) &&
#                                           "NHierarchicalClusteringResult" %in% class(cluster_2), CRITICAL_ERROR)
                                 # assert(cluster_1$get()$size() <= cluster_2$get()$size(), CRITICAL_ERROR)
                                 private$cluster_1 <<- cluster_1$clone(deep = T)
                                 private$cluster_2 <<- cluster_2$clone(deep = T)
                               },
                               compare = function() {
                                 comp <- compareParallelClustering(private$cluster_1$get()$toBasicCollection(), private$cluster_1$ncenters(),
                                                                   private$cluster_2$get()$toBasicCollection(), private$cluster_2$ncenters())
                                 private$similarility_matrix <<- DataCollection$new(comp[[1]])
                                 private$max_diff <<- DataCollection$new(comp[[2]])
                                 private$centers_1 <<- comp[[3]]
                                 private$centers_2 <<- comp[[4]]
                               },
                               getSimilarilityMatrix = function() {
                                 assert(!is.null(private$similarility_matrix), CRITICAL_ERROR)
                                 private$similarility_matrix
                               },
                               getSimilarilityMatrixOrder = function() {
                                 assert(!is.null(private$similarility_matrix_order), CRITICAL_ERROR)
                                 private$similarility_matrix_order
                               },
                               getMaxDiff = function() {
                                 assert(!is.null(private$max_diff), CRITICAL_ERROR)
                                 private$max_diff
                               },
                               getCenters = function() {
                                 return(list(centers_1 = private$centers_1, centers_2 = private$centers_2))
                               }
                             ))

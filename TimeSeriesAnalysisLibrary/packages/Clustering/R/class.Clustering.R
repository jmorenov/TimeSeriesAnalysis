#' Clustering
#'
#' Clase que realiza clustering sobre un conjunto de datos con determinados metodos.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Clustering Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
Clustering <- R6Class("Clustering",
                          private = list(
                            data = NULL,
                            clusteringMethods = NULL,
                            clusteringResults = NULL,
                            centers = NULL
                          ),
                          public = list(
                            initialize = function(methods, data) {
                              if (!missing(data)) {
                                assert("DataCollection" %in% class(data), CRITICAL_ERROR)
                                private$data <<- data$clone(deep = T)
                              }
                              private$clusteringMethods <<- MethodCollection$new()
                              if (!missing(methods)) self$addMethods(methods)
                            },
                            setData = function(data) {
                              assert("DataCollection" %in% class(data), CRITICAL_ERROR)
                              private$data <<- data$clone(deep = TRUE)
                            },
                            addMethods = function(mm) {
                              assert("MethodCollection" %in% class(mm), CRITICAL_ERROR)
                              assert(mm$size() > 0, CRITICAL_ERROR)
                              for (i in 1:mm$size()) {
                                self$addMethod(mm$get(i))
                              }
                            },
                            addMethod = function(m) {
                              assert("ClusteringMethod" %in% class(m), CRITICAL_ERROR)
                              private$clusteringMethods$add(m)
                            },
                            run = function(n_cores = NULL, centers = NULL) {
                              assert(!is.null(private$data) && !is.null(private$clusteringMethods), CRITICAL_ERROR)
                              private$clusteringResults <<- private$clusteringMethods$applyAll(private$data, n_cores = n_cores, centers = centers)
                              private$centers <<- centers
                            },
                            getResults = function() {
                              assert(!is.null(private$clusteringResults), CRITICAL_ERROR)
                              return(private$clusteringResults)
                            },
                            export = function(file_name_groups, file_name_centers) {
                              assert(!is.null(private$centers), CRITICAL_ERROR)
                              assert(!is.null(private$clusteringResults), CRITICAL_ERROR)
                              private$centers$get()$export(file_name_centers)
                              groups <- DataCollection$new(ncols = private$clusteringResults$size(), nrows = private$data$rows())
                              col_names <- c()
                              for (i in 1:private$clusteringResults$size()) {
                                col_names <- c(col_names, private$clusteringResults$get(i)$getMethod())
                                groups$setCol(private$clusteringResults$get(i)$get()$toBasicCollection(), i)
                              }
                              groups$setColNames(col_names)
                              groups$setRowNames(private$data$getRowNames())
                              groups$export(file_name_groups)
                            },
                            import = function(file_name_groups, file_name_centers, algorithm_center = "Chiu") {
                              data_groups <- DataCollection$new(file_name_groups)
                              data_centers <- DataCollection$new(file_name_centers)
                              private$centers <<- CentersResult$new(algorithm_center)
                              private$centers$set(data_centers)
                              private$clusteringResults <<- ResultCollection$new()
                              for (i in 1:data_groups$cols()) {
                                group_collection_i <- Collection$new(type = "integer")
                                for (j in 1:length(data_groups$getCol(i))) {
                                  group_collection_i$add(data_groups$getCol(i)[j])
                                }
                                clustResult <- ClusteringResult$new(data_groups$getColName(i))
                                clustResult$set(group_collection_i)
                                private$clusteringResults$add(clustResult)
                              }
                            }
                          ))

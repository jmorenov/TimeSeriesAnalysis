#' DataForecast
#'
#' Clase almacena resultados de metodos de prediccion sobre series temporales en
#' forma de matrix usando la clase \code{\link{DataCollection}}
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A DataForecast Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{DataCollection}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
DataForecast <- R6Class("DataForecast", inherit = DataCollection,
                          private = list(
                            methods = NULL,
                            timeseriesList = NULL,
                            predictions = list()
                          ),
                          public = list(
                            initialize = function(methods, timeseriesList) {
                              super$initialize()
                              private$methods <<- MethodCollection$new()
                              private$timeseriesList <<- TimeSeriesCollection$new()
                              if (!missing(methods)) self$addMethods(methods)
                              if (!missing(timeseriesList)) self$addTimeSeriesList(timeseriesList)
                            },
                            addMethod = function(m) {
                              assert(!missing(m), CRITICAL_ERROR)
                              assert("Method" %in% class(m), CRITICAL_ERROR)
                              private$methods$add(m)
                              self$addCol(name = m$getName())
                            },
                            addMethods = function(mm) {
                              assert(!missing(mm), CRITICAL_ERROR)
                              assert("MethodCollection" %in% class(mm), CRITICAL_ERROR)
                              assert(mm$size() > 0, CRITICAL_ERROR)
                              for (i in 1:mm$size()) self$addMethod(mm$get(i))
                            },
                            addTimeSeries = function(t) {
                              assert(!missing(t), CRITICAL_ERROR)
                              assert("TimeSeries" %in% class(t), CRITICAL_ERROR)
                              private$timeseriesList$add(t)
                            },
                            addTimeSeriesList = function(tt) {
                              assert(!missing(tt), CRITICAL_ERROR)
                              assert("TimeSeriesCollection" %in% class(tt), CRITICAL_ERROR)
                              assert(tt$size() > 0, CRITICAL_ERROR)
                              for (i in 1:tt$size()) self$addTimeSeries(tt$get(i))
                            },
                            run = function(parallel = TRUE, n_cores) {
                              assert(self$nmethods() > 0, CRITICAL_ERROR)
                              assert(self$ntimeseries() > 0, CRITICAL_ERROR)
                              if (parallel && requireNamespace("parallel", quietly = TRUE)) {
                                if (missing(n_cores)) n_cores <- parallel::detectCores()
                                rlog$debug(paste0("Iniciando ejecucion en paralelo con: ", n_cores, " procesos."))
                                runi = function(i) {
                                  t <- private$timeseriesList$get(i)
                                  rlog$debug(paste0("START: ", t$getID(), "N: ",  i, " with PID: ", Sys.getpid()))
                                  r <- private$methods$applyAll(t, parallel = TRUE, n_cores = n_cores)
                                  rlog$debug(paste0("END: ", t$getID(), "N: ",  i, " with PID: ", Sys.getpid()))
                                  row <- c()
                                  for (j in 1:r$size()) {
                                    if ("TimeSeries" %in% class(r$get(j)$get())) {
                                      row <- c(row, r$get(j)$getError())
                                    } else {
                                      row <- c(row, NA)
                                    }
                                  }
                                  return(list(row, as.character(t$getID())))
                                }
                                resultspar <- parallel::mclapply(1:self$ntimeseries(),
                                                                 runi,
                                                                 mc.cores = n_cores)
                                for (i in 1:length(resultspar)) {
                                  self$addRow(resultspar[[i]][[1]], name = resultspar[[i]][[2]])
                                }
                              } else {
                                for (i in 1:self$ntimeseries()) {
                                  t <- private$timeseriesList$get(i)
                                  r <- private$methods$applyAll(t, parallel = FALSE)
                                  row <- c()
                                  for (j in 1:r$size()) {
                                    if ("TimeSeries" %in% class(r$get(j)$get())) {
                                      row <- c(row, r$get(j)$getError())
                                    } else {
                                      row <- c(row, NA)
                                    }
                                  }
                                  # private$predictions[t$getID()] <- r$toBasicCollection()
                                  self$addRow(row, name = as.character(t$getID()))
                                }
                              }
                            },
                            getResult = function(index) {
                              as.numeric(self$getRow(index))
                            },
                            nmethods = function() {
                              private$methods$size()
                            },
                            ntimeseries = function() {
                              private$timeseriesList$size()
                            },
                            getPredictions = function() {
                              private$predictions
                            },
                            getErrors = function() {
                              self$toBasicCollection()
                            }
                          ))

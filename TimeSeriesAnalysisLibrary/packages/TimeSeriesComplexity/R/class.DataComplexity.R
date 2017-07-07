#' DataComplexity
#'
#' Clase almacena resultados de complejidad sobre series temporales en
#' forma de matrix usando la clase \code{\link{DataCollection}}
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A DataComplexity Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{DataCollection}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
DataComplexity <- R6Class("DataComplexity", inherit = DataCollection, 
                          private = list(
                            measures = NULL,
                            timeseries = NULL
                          ),
                          public = list(
                            initialize = function(measures, timeseries) {
                              super$initialize()
                              private$measures <<- MethodCollection$new()
                              private$timeseries <<- TimeSeriesCollection$new()
                              if (!missing(measures)) self$addMeasures(measures)
                              if (!missing(timeseries)) self$addTimeSeries(timeseries)
                            },
                            addMeasure = function(m) {
                              assert(!missing(m), CRITICAL_ERROR)
                              assert("Method" %in% class(m), CRITICAL_ERROR)
                              private$measures$add(m)
                              self$addCol(name = m$getName())
                            },
                            addMeasures = function(mm) {
                              assert(!missing(mm), CRITICAL_ERROR)
                              assert("MethodCollection" %in% class(mm), CRITICAL_ERROR)
                              assert(mm$size() > 0, CRITICAL_ERROR)
                              for (i in 1:mm$size()) self$addMeasure(mm$get(i))
                            },
                            addTimeSerie = function(t) {
                              assert(!missing(t), CRITICAL_ERROR)
                              assert("TimeSeries" %in% class(t), CRITICAL_ERROR)
                              private$timeseries$add(t)
                            },
                            addTimeSeries = function(tt) {
                              assert(!missing(tt), CRITICAL_ERROR)
                              assert("TimeSeriesCollection" %in% class(tt), CRITICAL_ERROR)
                              assert(tt$size() > 0, CRITICAL_ERROR)
                              for (i in 1:tt$size()) self$addTimeSerie(tt$get(i))
                            },
                            run = function(parallel = TRUE, n_cores) {
                              assert(self$nmeasures() > 0, CRITICAL_ERROR)
                              assert(self$ntimeseries() > 0, CRITICAL_ERROR)
                              if (parallel && requireNamespace("parallel", quietly = TRUE)) {
                                if (missing(n_cores)) n_cores <- parallel::detectCores()
                                rlog$debug(paste0("Starting in parallel with: ", n_cores, " cores"))
                                runi = function(i) {
                                  t <- private$timeseries$get(i)
                                  rlog$debug(paste0("START: ", t$getID(), " N: ",  i, " with PID: ", Sys.getpid()))
                                  r <- private$measures$applyAll(t$data, parallel = TRUE, n_cores = n_cores)
                                  t$data$invalidate()
                                  rlog$debug(paste0("END: ", t$getID(), " N: ",  i, " with PID: ", Sys.getpid()))
                                  return(list(as.numeric(r$toBasicCollection()), as.character(t$getID())))
                                }
                                resultspar <- parallel::mclapply(1:self$ntimeseries(),
                                                       runi,
                                                       mc.cores = n_cores)
                                for (i in 1:length(resultspar))
                                  self$addRow(resultspar[[i]][[1]], name = resultspar[[i]][[2]])
                              } else {
                                for (i in 1:self$ntimeseries()) {
                                  t <- private$timeseries$get(i)
                                  r <- private$measures$applyAll(t$data, parallel = FALSE)
                                  t$data$invalidate()
                                  self$addRow(as.numeric(r$toBasicCollection()), name = as.character(t$getID()))
                                }
                              }
                            },
                            getResult = function(index) {
                              as.numeric(self$getRow(index))
                            },
                            nmeasures = function() {
                              private$measures$size()
                            },
                            ntimeseries = function() {
                              private$timeseries$size()
                            }
                          ))

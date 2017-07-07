#' TimeSeriesCollection
#'
#' Clase almacena una lista de series temporales usando la clase \code{\link{Collection}}
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A TimeSeriesCollection Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Collection}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
TimeSeriesCollection <- R6Class("TimeSeriesCollection", inherit = Collection,
                               private = list(
                                 data_ts = NULL,
                                 read_data = function(data) {
                                   data_read <- DataCollection$new(data)
                                   for (i in 1:data_read$rows()) {
                                     row <- data_read$getRow(i)
                                     id <- data_read$getRowName(i)
                                     t <- TimeSeries$new(id = id, name = row[["name"]],
                                                        data = row[["file"]], start = row[["start"]],
                                                        end = row[["end"]], frequency = row[["frequency"]])
                                     self$add(t)
                                   }
                                   private$data_ts <<- data_read
                                   private$data_ts$invalidate()
                                 }
                               ),
                               public = list(
                                 initialize = function(n = 0, data) {
                                   super$initialize(n, type = TimeSeries)
                                   if (!missing(data)) private$read_data(data)
                                 },
                                 getData = function() {
                                   assert(!is.null(data), CRITICAL_ERROR)
                                   private$data_ts
                                 }
                               ))

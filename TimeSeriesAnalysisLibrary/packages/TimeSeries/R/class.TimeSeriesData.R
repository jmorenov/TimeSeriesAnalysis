#' TimeSeriesData
#'
#' Clase que almacena datos de una serie temporal e implementa metodos genericos para manejarlos.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A TimeSeriesData Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{DataCollection}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
TimeSeriesData <- R6Class("TimeSeriesData", inherit = DataCollection,
  private = list(
     haveDates = FALSE
  ),
  public = list(
    initialize = function(data, haveDates = FALSE) {
      assert(!missing(data) && is.logical(haveDates), CRITICAL_ERROR)
      
      super$initialize(data)
      private$haveDates <<- haveDates
    },
    
    getDates = function() {
      assert(private$haveDates, CRITICAL_ERROR)
      
      self$getCol(1)
    },
    
    getValues = function(nvar) {
      assert(nvar > 0, CRITICAL_ERROR)
      
      if (private$haveDates) as.numeric(self$getCol(nvar + 1))
      else as.numeric(self$getCol(nvar))
    },
    
    getAllValues = function() {
      if (private$haveDates) {
        as.numeric(self$subdata(1, self$rows(), 2, self$cols()))
      }
      else {
        as.numeric(self$subdata(1, self$rows(), 1, self$cols()))
      }
    },
    
    getNVars = function() {
      if (private$haveDates)  self$cols() - 1
      else self$cols()
    },
    
    getNValues = function() {
      self$rows()
    },
    
    withDates = function() {
      private$haveDates
    },
    
    mean = function(nvar) {
      mean(self$getValues(nvar))
    },
    
    sd = function() {
      sd(self$getAllValues())
    }
  )
)
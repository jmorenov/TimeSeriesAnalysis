#' TimeSeries
#'
#' Clase que define una serie temporal.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A TimeSeries Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
TimeSeries <- R6::R6Class("TimeSeries",
   private = list(
     id = NA,
     name = NA,
     start = NA,
     end = NA,
     frequency = 1
  ),
  public = list(
     data = NULL,
     initialize = function(data, id, name, start, end, frequency, haveDates = FALSE) {
       assert(!missing(data) && !missing(id), CRITICAL_ERROR)
       
       self$data <<- TimeSeriesData$new(data, haveDates)
       
       if (missing(name)) name <- id
       
       if (missing(start) || missing(end)) {
         start <- 1
         end <- self$data$getNValues()
       }
       
       if (missing(frequency)) frequency <- 1
       
       private$id <<- id
       private$name <<- name
       private$start <<- start
       private$end <<- end
       private$frequency <<- as.numeric(frequency)
       
       self$data$invalidate()
     },
     
     getID = function() { private$id },
     
     getName = function() { private$name },
     
     getStart = function() { private$start },
     
     getEnd = function() { private$end },
     
     getFrequency = function() { private$frequency },
     
     getNVars = function() { self$data$getNVars() },
     
     getNValues = function() { self$data$getNValues() },
     
     #'
     #' Deprecated 
     #'
     toTS = function() {
       return(ts(self$data$getAllValues(), start = 1, end = self$getNValues(), frequency = self$getFrequency()))
     },
     
     getTrainTest = function(percent_train) {
       assert(percent_train <= 1 && percent_train > 0, CRITICAL_ERROR)
       
       n <- as.integer(self$getNValues() * percent_train)
       data <- matrix(self$data$getAllValues(), nrow = self$getNValues(), ncol = self$getNVars())
       train <- ts(as.numeric(data[1:n, 1:self$getNVars()]), start = 1, end = n, frequency = self$getFrequency())
       test <- ts(as.numeric(data[(n + 1):self$getNValues(), 1:self$getNVars()]), start = n + 1, end = self$getNValues(), frequency = self$getFrequency())
       
       return(list("train" = train, "test" = test))
     }
  )
)
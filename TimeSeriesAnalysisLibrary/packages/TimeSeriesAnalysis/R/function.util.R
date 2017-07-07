#' Returns a list with the complexity measures
#'
#' @export
#'
#'
#' @return A MethodCollection object with all Complexity Measures.
#'
#'@examples
#' getComplexityMeasures()
#'
getComplexityMeasures <- function() {
  methods <- TimeSeriesComplexity::getComplexityMeasures()
  methodsNames <- list()
  
  for (i in 1:methods$size()) {
    methodsNames[[i]] <- list(id = methods$get(i)$getName(), parameters = c())
  }
  
  return(methodsNames)
}

#' Returns a list with the transformation
#'
#' @export
#'
#'
#' @return A MethodCollection object with all Transformation Methods.
#'
#'@examples
#' getTransformationMethods()
#'
getTransformationMethods <- function() {
  methods <- TimeSeriesTransformation::getTransformationMethods()
  methodsNames <- list()
  
  for (i in 1:methods$size()) {
    methodsNames[[i]] <- list(id = methods$get(i)$getName(), parameters = c())
  }
  
  return(methodsNames)
}

#' Returns a list with the forecasting methods
#'
#' @export
#'
#' @param percent_train Percent of the train set.
#' @return A MethodCollection object with all Forecast Methods.
#'
#'@examples
#' getForecastMethods(percent_train = 0.8)
#'
getForecastMethods <- function(percent_train) {
  methods <- TimeSeriesForecast::getForecastMethods(percent_train)
  methodsNames <- list()
  
  for (i in 1:methods$size()) {
    methodsNames[[i]] <- list(id = methods$get(i)$getName(), parameters = c())
  }
  
  return(methodsNames)
}

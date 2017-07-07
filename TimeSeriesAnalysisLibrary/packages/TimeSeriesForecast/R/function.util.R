#' Devuelve una lista con todos los metodos de prediccion
#'
#' @export
#'
#' @param percent_train Porcentaje para la division de train y test.
#'
#' @return A MethodCollection object with all forecast methods.
#'
#'@examples
#' getForecastMethods(0.8)
#'
getForecastMethods <- function(percent_train) {
  m <- DataUtils::MethodCollection$new()
  
  m$add(ArimaMethod$new(percent_train))
  m$add(Ets$new(percent_train))
  m$add(HoltWinters$new(percent_train))
  m$add(StructTS$new(percent_train))
  m$add(Bats$new(percent_train))
  m$add(Stl$new(percent_train))
  
  return(m)
}

#' Devuelve la media de error de prediccion.
#'
#' @export
#'
#' @param data_forecast A matrix with the errors.
#' @param centers The clustering centers.
#'
#' @return mean_error The mean of the errors.
#'
#' @examples
#' \dontrun{
#'  error.forecast(DataForecast$new(), list("1" = c(1,2,3), "2" = c(10,9,7)))
#' }
#'
error.forecast <- function(data_forecast, centers) {
  return(ErrorForecast(data_forecast$toBasicCollection(), centers))
}

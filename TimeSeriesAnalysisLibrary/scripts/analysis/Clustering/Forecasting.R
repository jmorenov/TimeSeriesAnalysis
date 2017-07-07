forecasting <- function (percent_train, timeSeriesCollection, groups) {
  forecastMethods <- TimeSeriesAnalysis::getForecastMethods(percent_train)
  dataforecast <- TimeSeriesForecast::DataForecast$new(forecastMethods, timeSeriesCollection)
  dataforecast$run()
  forecastingError <- DataUtils::DataCollection$new(TimeSeriesForecast::error.forecast(dataforecast, groups$toBasicCollection()))
  forecastingError$setColNames(dataforecast$getColNames())
  methods <- colnames(forecastingError$toBasicCollection())[apply(forecastingError$toBasicCollection(),1,which.max)]
  
  return(list(dataForecast = dataforecast, 
              forecastingError = forecastingError,
              methods = methods))
}
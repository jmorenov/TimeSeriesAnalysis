#' ForecastMethod
#'
#' Clase abstracta que define los metodos para implementar un metodo de prediccion.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ForecastMethod Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{Method}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
ForecastMethod <- R6Class("ForecastMethod", inherit = Method,
                             private = list(
                               percent_train = 1,
                               
                               calculateError = function(pred_mean, test) {
                                 error <- na.omit(sapply(forecast::accuracy(pred_mean, test), FUN = function(x) replace(x, is.infinite(x),NA)))
                                 return(mean(error))
                                }
                             ),
                             public = list(
                               initialize = function(percent_train, name, description = ""){
                                 private$percent_train <<- percent_train
                                 super$initialize(name, description)
                               },
                               apply = function(timeseries) {
                                 assert(requireNamespace("forecast", quietly = TRUE), CRITICAL_ERROR)
                                 assert("TimeSeries" %in% class(timeseries), CRITICAL_ERROR)
                                 result <- ForecastResult$new(self$getName())
                                 return(result)
                               }
                             ))

#' Arima
#'
#' Clase que sobreescribe la clase \code{\link{ForecastMethod}} implementando
#' el metodo de prediccion arima del paquete forecast.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Arima Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ForecastMethod}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
ArimaMethod <- R6Class("ArimaMethod", inherit = ForecastMethod,
                          private = list(),
                          public = list(
                            initialize = function(percent_train) {
                              super$initialize(percent_train, "Arima",
                                               "Arima forecast method of package forecast")
                            },
                            apply = function(timeseries, future_values = NULL) {
                              result <- super$apply(timeseries)
                              assert(requireNamespace("forecast", quietly = TRUE), CRITICAL_ERROR)
                              if (!is.null(future_values)) {
                                fit <- forecast::Arima(timeseries$toTS())
                                pred <- forecast::forecast.Arima(fit, future_values)
                                error <- 0
                              } else {
                                traintest <- timeseries$getTrainTest(private$percent_train)
                                train <- traintest$train
                                test <- traintest$test
                                fit <- forecast::Arima(train)
                                pred <- forecast::forecast.Arima(fit, length(test))
                                error <- private$calculateError(pred$mean, test)
                              }
                              timeseries_pred <- TimeSeries$new(pred$mean, paste0(timeseries$getID(), "_Prediction"))
                              result$set(timeseries_pred, error)
                              return(result)
                            }
                          ))
#' Ets
#'
#' Clase que sobreescribe la clase \code{\link{ForecastMethod}} implementando
#' el metodo de prediccion Ets del paquete forecast.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Ets Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ForecastMethod}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
Ets <- R6Class("Ets", inherit = ForecastMethod,
                 private = list(),
                 public = list(
                   initialize = function(percent_train) {
                     super$initialize(percent_train, "Ets",
                                      "Ets forecast method of package forecast")
                   },
                   apply = function(timeseries) {
                     result <- super$apply(timeseries)
                     assert(requireNamespace("forecast", quietly = TRUE), CRITICAL_ERROR)
                     traintest <- timeseries$getTrainTest(private$percent_train)
                     train <- traintest$train
                     test <- traintest$test
                     fit  <- forecast::ets(train)
                     pred <- forecast::forecast.ets(fit, length(test))
                     # error <- hydroGOF::rmse(pred$mean, test)
                     error <- private$calculateError(pred$mean, test)
                     timeseries_pred <- TimeSeries$new(pred$mean, paste0(timeseries$getID(), "_Prediction"))
                     result$set(timeseries_pred, error)
                     return(result)
                   }
                 ))

#' HoltWinters
#'
#' Clase que sobreescribe la clase \code{\link{ForecastMethod}} implementando
#' el metodo de prediccion HoltWinters del paquete stats
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A HoltWinters Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ForecastMethod}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
HoltWinters <- R6Class("HoltWinters", inherit = ForecastMethod,
               private = list(),
               public = list(
                 initialize = function(percent_train) {
                   super$initialize(percent_train, "HoltWinters",
                                    "HoltWinters forecast method of package stats")
                 },
                 apply = function(timeseries) {
                   result <- super$apply(timeseries)
                   assert(requireNamespace("forecast", quietly = TRUE), CRITICAL_ERROR)
                   assert(requireNamespace("stats", quietly = TRUE), CRITICAL_ERROR)
                   traintest <- timeseries$getTrainTest(private$percent_train)
                   train <- traintest$train
                   test <- traintest$test
                   if (timeseries$getFrequency() > 1) {
                     fit  <- stats::HoltWinters(train)
                   } else {
                     fit  <- stats::HoltWinters(train, gamma = F)
                   }
                   pred <- forecast::forecast.HoltWinters(fit, length(test))
                   # error <- hydroGOF::rmse(pred$mean, test)
                   error <- private$calculateError(pred$mean, test)
                   timeseries_pred <- TimeSeries$new(pred$mean, paste0(timeseries$getID(), "_Prediction"))
                   result$set(timeseries_pred, error)
                   return(result)
                 }
               ))

#' StructTS
#'
#' Clase que sobreescribe la clase \code{\link{ForecastMethod}} implementando
#' el metodo de prediccion StructTS del paquete stats
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A StructTS Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ForecastMethod}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
StructTS <- R6Class("StructTS", inherit = ForecastMethod,
                       private = list(),
                       public = list(
                         initialize = function(percent_train) {
                           super$initialize(percent_train, "StructTS",
                                            "StructTS forecast method of package stats")
                         },
                         apply = function(timeseries) {
                           result <- super$apply(timeseries)
                           assert(requireNamespace("forecast", quietly = TRUE), CRITICAL_ERROR)
                           assert(requireNamespace("stats", quietly = TRUE), CRITICAL_ERROR)
                           traintest <- timeseries$getTrainTest(private$percent_train)
                           train <- traintest$train
                           test <- traintest$test
                           suppressWarnings(fit  <- stats::StructTS(train))
                           pred <- forecast::forecast.StructTS(fit, length(test))
                           # error <- hydroGOF::rmse(pred$mean, test)
                           error <- private$calculateError(pred$mean, test)
                           timeseries_pred <- TimeSeries$new(pred$mean, paste0(timeseries$getID(), "_Prediction"))
                           result$set(timeseries_pred, error)
                           return(result)
                         }
                       ))

#' Bats
#'
#' Clase que sobreescribe la clase \code{\link{ForecastMethod}} implementando
#' el metodo de prediccion Bats del paquete forecast
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Bats Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ForecastMethod}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
Bats <- R6Class("Bats", inherit = ForecastMethod,
                    private = list(),
                    public = list(
                      initialize = function(percent_train) {
                        super$initialize(percent_train, "Bats",
                                         "Bats forecast method of package forecast")
                      },
                      apply = function(timeseries) {
                        result <- super$apply(timeseries)
                        assert(requireNamespace("forecast", quietly = TRUE), CRITICAL_ERROR)
                        traintest <- timeseries$getTrainTest(private$percent_train)
                        train <- traintest$train
                        test <- traintest$test
                        fit  <- forecast::bats(train, use.parallel = FALSE)
                        pred <- forecast::forecast.bats(fit, length(test))
                        predts <- ts(matrix(pred$mean, nrow = length(test), ncol = timeseries$getNVars()), start = start(test), end = end(test), frequency = frequency(test))
                        # error <- hydroGOF::rmse(predts, test)
                        error <- private$calculateError(pred$mean, test)
                        timeseries_pred <- TimeSeries$new(predts, paste0(timeseries$getID(), "_Prediction"))
                        result$set(timeseries_pred, error)
                        return(result)
                      }
                    ))

#' Stl
#'
#' Clase que sobreescribe la clase \code{\link{ForecastMethod}} implementando
#' el metodo de prediccion Stl del paquete forecast
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Stl Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Extend: \code{\link{ForecastMethod}}
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
Stl <- R6Class("Stl", inherit = ForecastMethod,
                private = list(),
                public = list(
                  initialize = function(percent_train) {
                    super$initialize(percent_train, "Stl",
                                     "Stl forecast method of package forecast")
                  },
                  apply = function(timeseries) {
                    result <- super$apply(timeseries)
                    assert(requireNamespace("forecast", quietly = TRUE), CRITICAL_ERROR)
                    if (timeseries$getFrequency() > 1) {
                      traintest <- timeseries$getTrainTest(private$percent_train)
                      train <- traintest$train
                      test <- traintest$test
                      fit  <- forecast::stlm(train)
                      pred <- forecast::forecast.stlm(fit, length(test))
                      # error <- hydroGOF::rmse(pred$mean, test)
                      error <- private$calculateError(pred$mean, test)
                      timeseries_pred <- TimeSeries$new(pred$mean, paste0(timeseries$getID(), "_Prediction"))
                    } else {
                      timeseries_pred <- NA
                      error <- NA
                    }
                    result$set(timeseries_pred, error)
                    return(result)
                  }
                ))
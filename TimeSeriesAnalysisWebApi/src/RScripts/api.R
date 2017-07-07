getTimeSeries <- function (id, frequency) {
    timeSeriesService <- TimeSeriesDatabase::TimeSeriesService$new("jmorenov", "Series,2017")
    timeSeries <- timeSeriesService$get(id)

    return(timeSeries)
}

getTransformations <- function () {
    transformations <- TimeSeriesAnalysis::getTransformationMethods()
    result <- jsonlite::toJSON(transformations)

    print(result)
}

getComplexityMeasures <- function () {
    cm <- TimeSeriesAnalysis::getComplexityMeasures()
    result <- jsonlite::toJSON(cm)

    print(result)
}

getForecastMethods <- function () {
    fm <- TimeSeriesAnalysis::getForecastMethods(0.8)
    result <- jsonlite::toJSON(fm)

    print(result)
}

applyTransformation <- function (id, transformation) {
    timeSeries <- getTimeSeries(id)

    if (transformation == "LogarithmicTransformation") {
        trans <- TimeSeriesTransformation::LogarithmicTransformation$new()
        transformation <- trans$apply(timeSeries$data)
    }

    l <- list()
    l$transformation <- transformation$get()$toBasicCollection()
    result <- jsonlite::toJSON(l)
    print(result)
}

applyComplexityMeasure <- function (id, complexityMeasure, transformation) {
    if (complexityMeasure == "Kolmogorov") {
        cm <- TimeSeriesComplexity::Kolmogorov$new()
    } else if (complexityMeasure == "LempelZiv") {
        cm <- TimeSeriesComplexity::LempelZiv$new()
    } else if (complexityMeasure == "AproximationEntropy") {
        cm <- TimeSeriesComplexity::AproximationEntropy$new()
    } else if (complexityMeasure == "PermutationEntropy") {
        cm <- TimeSeriesComplexity::PermutationEntropy$new()
    } else if (complexityMeasure == "PracmaSampleEntropy") {
        cm <- TimeSeriesComplexity::PracmaSampleEntropy$new()
    } else if (complexityMeasure == "SampleEntropy") {
        cm <- TimeSeriesComplexity::SampleEntropy$new()
    } else if (complexityMeasure == "ShannonEntropy") {
        cm <- TimeSeriesComplexity::ShannonEntropy$new()
    } else if (complexityMeasure == "ChaoShenEntropy") {
        cm <- TimeSeriesComplexity::ChaoShenEntropy$new()
    } else if (complexityMeasure == "DirichletEntropy") {
        cm <- TimeSeriesComplexity::DirichletEntropy$new()
    } else if (complexityMeasure == "MillerMadowEntropy") {
        cm <- TimeSeriesComplexity::MillerMadowEntropy$new()
    } else if (complexityMeasure == "ShrinkEntropy") {
        cm <- TimeSeriesComplexity::ShrinkEntropy$new()
    }

    timeSeries <- getTimeSeries(id)

    if (transformation == "LogarithmicTransformation") {
        trans <- TimeSeriesTransformation::LogarithmicTransformation$new()
        timeSeries$data <- trans$apply(timeSeries$data)$get()
    }

    result <- cm$apply(timeSeries$data)
    l <- list()
    l$complexityMeasureResult <- result$get()
    result <- jsonlite::toJSON(l)
    print(result)
}

applyForecast <- function (id, forecastMethod, transformation, percentTrain) {
    if (forecastMethod == "Arima") {
        fm <- TimeSeriesForecast::ArimaMethod$new(percentTrain)
    } else if (forecastMethod == "Ets") {
        fm <- TimeSeriesForecast::Ets$new(percentTrain)
    } else if (forecastMethod == "HoltWinters") {
        fm <- TimeSeriesForecast::HoltWinters$new(percentTrain)
    } else if (forecastMethod == "StructTS") {
        fm <- TimeSeriesForecast::StructTS$new(percentTrain)
    } else if (forecastMethod == "Bats") {
        fm <- TimeSeriesForecast::Bats$new(percentTrain)
    } else if (forecastMethod == "Stl") {
        fm <- TimeSeriesForecast::Stl$new(percentTrain)
    }

    timeSeries <- getTimeSeries(id)

    if (transformation == "LogarithmicTransformation") {
        trans <- TimeSeriesTransformation::LogarithmicTransformation$new()
        timeSeries$data <- trans$apply(timeSeries$data)$get()
    }

    result <- fm$apply(timeSeries)
    l <- list()
    l$forecastResult <- result$get()$data$toBasicCollection()
    result <- jsonlite::toJSON(l)

    print(result)
}

classification <- function(id, transformation) {
    timeSeries <- getTimeSeries(id)

    if (transformation == "LogarithmicTransformation") {
        trans <- TimeSeriesTransformation::LogarithmicTransformation$new()
        timeSeries$data <- trans$apply(timeSeries$data)$get()
    }

    result <- TimeSeriesAnalysis::getTimeSeriesClass(id)
    result <- jsonlite::toJSON(result)

    print(result)
}
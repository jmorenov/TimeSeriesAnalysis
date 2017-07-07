.libPaths(c( .libPaths(), r_lib) )

packages <- c("RLog", "DataUtils", "Clustering", "TimeSeries",
                "TimeSeriesForecast", "TimeSeriesComplexity",
                "TimeSeriesTransformation", "TimeSeriesAnalysis",
		"TimeSeriesDatabase",
		"jsonlite", "jsonlite")

for (package in packages) {
    suppressMessages(suppressWarnings(library(package, character.only = T,
                    warn.conflicts = F, quietly = T, verbose = F)))
}
args <- commandArgs(trailingOnly = TRUE)

initialize <- function() {
  RLog::assert(length(args) == 2, "Missing limits.")
  
  RLog::rlog$setLevel("debug")
  
  username <<- "user"
  password <<- "password"
  
  timeSeriesService <<- TimeSeriesDatabase::TimeSeriesService$new(username, password)
}

ApplyCMTimeSeries <- function() {
  firstTimeSeries <- as.numeric(args[1])
  lastTimeSeries <- as.numeric(args[2])
  
  timeSeriesIds <- timeSeriesService$getIds()
  
  if (firstTimeSeries < 0 || firstTimeSeries > lastTimeSeries) {
    RLog::rlog$error("Error on limits")
    stop()
  }
  
  if (lastTimeSeries > length(timeSeriesIds)) {
    RLog::rlog$error("Error on limits")
    stop()
  }
  
  timeSeriesIds <- timeSeriesIds[firstTimeSeries:lastTimeSeries]
  applyComplexityMeasures <<- TimeSeriesAnalysis::ApplyComplexityMeasures$new(timeSeriesIds, username, password)
  
  tryCatch({
    applyComplexityMeasures$apply()
  }, error = function(e) {
    RLog::rlog$error(e)
  })
}

initialize()
ApplyCMTimeSeries()
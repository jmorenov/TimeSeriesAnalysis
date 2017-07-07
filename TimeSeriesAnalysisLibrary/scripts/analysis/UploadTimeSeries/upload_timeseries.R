initialize <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  
  RLog::assert(length(args) == 2, "Missing files path.")

  RLog::rlog$setLevel("debug")
  
  filePath <<- args[1]
  fileResults <<- args[2]
  username <<- "user"
  password <<- "password"
  
  timeSeriesService <<- TimeSeriesDatabase::TimeSeriesService$new(username, password)
  uploadResults <<- DataUtils::DataCollection$new(ncols = 3)
  files <<- list.files(filePath, pattern = "*.csv")
}

uploadTimeSeries <- function() {
  firstFile <- 50000
  lastFile <- 60000
  
  for (i in 1:length(files)) {
    if (i >= firstFile && i <= lastFile) {
      file <- files[i]
      id <<- DataUtils::file_name(file)
      timeSeriesUpload <<- list(id = id, public = "1", withDates = "1")
      timeSeriesFile <<- paste0(filePath, file)
      
      RLog::rlog$debug(paste0("Uploading: ", id))
      
      tryCatch({
        result <<- timeSeriesService$upload(timeSeriesUpload, timeSeriesFile)
        
        if (!is.null(result$error)) {
          exportError(id, timeSeriesFile, result$error)
        }
      }, error = function(e) {
        exportError(id, timeSeriesFile, e)
      })
    }
  }
}

exportError <- function(id, file, error) {
  RLog::rlog$error(paste0(id, ": ", error))
  
  if (error == "Error creating timeseries: HTTP Code 500 {\"error\":\"timeout\"}\n") {
    stop()
  }
  
  uploadResult <- list(id = id, file = file, error = error)
  
  uploadResults$addRow(uploadResult)
}

exportFile <- function() {
  if (uploadResults$rows() != 0) {
    RLog::rlog$debug("Exporting errors file...")
    
    file.create(fileResults)
    fileReader <- DataUtils::FileReader$new(fileResults)
    fileReader$write(uploadResults$toBasicCollection(), override_file = T) 
  }
}

initialize()
uploadTimeSeries()
exportFile()
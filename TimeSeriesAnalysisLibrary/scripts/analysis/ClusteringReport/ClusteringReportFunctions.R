calculate_centers_density <- function(centers) {
  centers_density <- c()
  for (i in 1:length(centers)) {
    centers_density <- c(centers_density, length(centers[[i]]))
  }
  density <- list()
  density$max <- max(centers_density)
  density$min <- min(centers_density)
  density$sd <- sd(centers_density)
  return(density)
}

analysis_methods_clustering <- function(clust) {
  result <- list()
  for (i in 1:clust$getResults()$size()) {
    result[[i]] <- list()
    result[[i]]$ncenters <- clust$getResults()$get(i)$ncenters()
    result[[i]]$hist <- clust$getResults()$get(i)$get()$toBasicCollection()
  }
  return(result)
}

analysis_pair_clustering <- function(clust_1, clust_2) {
  result <- list()
  compare_clust <- Clustering::CompareClustering$new(clust_1, clust_2)
  compare_clust$compare()
  result$n_centers_equals <- length(compare_clust$getMaxDiff()$getCol(1)[as.integer(compare_clust$getMaxDiff()$getCol(1)) == 100])
  result$n_centers_non_equals <- length(compare_clust$getMaxDiff()$getCol(1)[as.integer(compare_clust$getMaxDiff()$getCol(1)) == 0])
  result$mean_similarility <- mean(compare_clust$getMaxDiff()$getCol(1))
  result$density <- list()
  result$density[[1]] <- calculate_centers_density(compare_clust$getCenters()[[1]])
  result$density[[2]] <- calculate_centers_density(compare_clust$getCenters()[[2]])
  result$centers <- compare_clust$getCenters()
  return(result)
}

analysis_clustering <- function(data) {
  clust <- Clustering::Clustering$new()
  m <- DataUtils::MethodCollection$new()
  m$add(Clustering::KMeans$new())
  m$add(Clustering::CMeans$new())
  m$add(Clustering::HClust$new())
  clust$addMethods(m)
  clust$setData(data)
  clust$run()

  analysis_methods <- analysis_methods_clustering(clust)
  compare_1_2 <- analysis_pair_clustering(clust$getResults()$get(1), clust$getResults()$get(2))
  compare_1_3 <- analysis_pair_clustering(clust$getResults()$get(1), clust$getResults()$get(3))
  compare_2_3 <- analysis_pair_clustering(clust$getResults()$get(2), clust$getResults()$get(3))

  result <- list()
  result$clust <- clust
  result$analysis <- analysis_methods
  result$compare <- list()
  result$compare[[1]] <- compare_1_2
  result$compare[[2]] <- compare_1_3
  result$compare[[3]] <- compare_2_3
  result$centers_1 <- compare_1_2$centers$centers_1
  result$centers_2 <- compare_1_2$centers$centers_2
  result$centers_3 <- compare_2_3$centers$centers_2

  return(result)
}

intersect_centers <- function(clust, interval) {
  new_clust <- clust$clone(deep = TRUE)
  for (i in 1:clust$getResults()$size()) {
    cl <- clust$getResults()$get(i)$get()$toBasicCollection()
    cl <- cl[interval]
    cl_new <- DataUtils::Collection$new(1, "integer")
    cl_new$set(cl[1], 1)
    for (j in 2:length(interval)) {
      cl_new$add(cl[j])
    }
    clust_result <- new_clust$getResults()$get(i)$clone(deep = TRUE)
    clust_result$set(cl_new)
    new_clust$getResults()$set(clust_result, i)
  }
  return(new_clust)
}

compare_blocks <- function(clust, clust_subset, interval) {
  clust <- intersect_centers(clust, interval)
  compare_1 <- analysis_pair_clustering(clust$getResults()$get(1), clust_subset$getResults()$get(1))
  compare_2 <- analysis_pair_clustering(clust$getResults()$get(1), clust_subset$getResults()$get(2))
  compare_3 <- analysis_pair_clustering(clust$getResults()$get(1), clust_subset$getResults()$get(3))
  compare_4 <- analysis_pair_clustering(clust$getResults()$get(2), clust_subset$getResults()$get(1))
  compare_5 <- analysis_pair_clustering(clust$getResults()$get(2), clust_subset$getResults()$get(2))
  compare_6 <- analysis_pair_clustering(clust$getResults()$get(2), clust_subset$getResults()$get(3))
  compare_7 <- analysis_pair_clustering(clust$getResults()$get(3), clust_subset$getResults()$get(1))
  compare_8 <- analysis_pair_clustering(clust$getResults()$get(3), clust_subset$getResults()$get(2))
  compare_9 <- analysis_pair_clustering(clust$getResults()$get(3), clust_subset$getResults()$get(3))

  result <- list(compare_1, compare_2, compare_3, compare_4,
                 compare_5, compare_6, compare_7, compare_8, compare_9)
  return(result)
}

analysis_get_automatic_forecasting_method <- function(forecast_result) {
  data <- forecast_result$toBasicCollection()
  
  return(colnames(data)[apply(data,1,which.max)])
}

analysis_forecast <- function(timeSeriesCollection, percent_train, cluster) {
  mc <- TimeSeriesAnalysis::getForecastMethods(percent_train)
  dataforecast <- TimeSeriesForecast::DataForecast$new(mc, timeSeriesCollection)
  
  dataforecast$run()
  
  result <- list()
  result$centers_1 <- DataUtils::DataCollection$new(TimeSeriesForecast::error.forecast(dataforecast, cluster$centers_1))
  result$centers_1$setColNames(dataforecast$getColNames())
  automaticMethod <- analysis_get_automatic_forecasting_method(result$centers_1)
  result$centers_1$addCol(automaticMethod, name = "Automatic Method")
  
  result$centers_2 <- DataUtils::DataCollection$new(TimeSeriesForecast::error.forecast(dataforecast, cluster$centers_2))
  result$centers_2$setColNames(dataforecast$getColNames())
  automaticMethod <- analysis_get_automatic_forecasting_method(result$centers_2)
  result$centers_2$addCol(automaticMethod, name = "Automatic Method")
  
  result$centers_3 <- DataUtils::DataCollection$new(TimeSeriesForecast::error.forecast(dataforecast, cluster$centers_3))
  result$centers_3$setColNames(dataforecast$getColNames())
  automaticMethod <- analysis_get_automatic_forecasting_method(result$centers_3)
  result$centers_3$addCol(automaticMethod, name = "Automatic Method")
  
  return(result)
}

add_complexity_measure_row <- function(data, dataToAdd) {
  for (i in 1:dataToAdd$rows()) {
    data$addRow(dataToAdd$getRow(i), name = dataToAdd$getRowName(i))
  }
  
  return(data)
}

analysis_blocks <- function(percent_train, n1, n2, norm.min, norm.max, intervalA, intervalB, intervalC) {
  RLog::rlog$debug("START clustering")
  
  timeSeriesService <- TimeSeriesDatabase::TimeSeriesService$new("user", "password")
  complexityMeasuresService <- TimeSeriesDatabase::ComplexityMeasuresService$new("user", "password")
  
  allTimeSeriesIds <- timeSeriesService$getIds(withNValues = TRUE)
  timeSeriesIds <- allTimeSeriesIds[n1:n2,]
  
  if (n2 > 3000 && n2 < 20000) {
    complexityMeasuresResults <- DataUtils::DataCollection$new(ncols = 11)
    
    complexityMeasuresResultsA <- complexityMeasuresService$getInterval(intervalA[1], intervalA[2], asDataCollection = T)
    complexityMeasuresResultsB <- complexityMeasuresService$getInterval(intervalB[1], intervalB[2], asDataCollection = T)
    complexityMeasuresResultsC <- complexityMeasuresService$getInterval(intervalC[1], intervalC[2], asDataCollection = T)
    
    complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResultsA)
    complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResultsB)
    complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResultsC)
  } else if (n2 == 48000) { 
	complexityMeasuresResults <- DataUtils::DataCollection$new(ncols = 11)
    
    complexityMeasuresResults1 <- complexityMeasuresService$getInterval(1, 6000, asDataCollection = T)
    complexityMeasuresResults2 <- complexityMeasuresService$getInterval(6001, 12000, asDataCollection = T)
    complexityMeasuresResults3 <- complexityMeasuresService$getInterval(12001, 18000, asDataCollection = T)
	complexityMeasuresResults4 <- complexityMeasuresService$getInterval(18001, 24000, asDataCollection = T)
    complexityMeasuresResults5 <- complexityMeasuresService$getInterval(24001, 30000, asDataCollection = T)
    complexityMeasuresResults6 <- complexityMeasuresService$getInterval(30001, 36000, asDataCollection = T)
	complexityMeasuresResults7 <- complexityMeasuresService$getInterval(36001, 42000, asDataCollection = T)
	complexityMeasuresResults8 <- complexityMeasuresService$getInterval(42001, 48000, asDataCollection = T)
	#complexityMeasuresResults9 <- complexityMeasuresService$getInterval(48001, 50000, asDataCollection = T)
    
    complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResults1)
    complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResults2)
    complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResults3)
	complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResults4)
    complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResults5)
    complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResults6)
	complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResults7)
    complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResults8)
    #complexityMeasuresResults <- add_complexity_measure_row(complexityMeasuresResults, complexityMeasuresResults9)
  } else {
    complexityMeasuresResults <- complexityMeasuresService$getInterval(n1, n2, asDataCollection = T)
  }

  timeSeriesCollection <- TimeSeries::TimeSeriesCollection$new()
  
  RLog::assert(all(complexityMeasuresResults$getRowNames() == timeSeriesIds[,1]), "Clustering error: The timeseries ids are not the same.")
  
  RLog::rlog$debug("Getting timeseries...")
  progressBar <- txtProgressBar(min = 0, max = complexityMeasuresResults$rows(), style = 3)
  i <- 1
  while (i <= complexityMeasuresResults$rows()) {
    rowName <- complexityMeasuresResults$getRowName(i)
    row <- complexityMeasuresResults$getRow(i)
    idIndex <- match(rowName, timeSeriesIds)
    
    if (anyNA(row) || !all(is.infinite(row) == FALSE) || as.numeric(timeSeriesIds[idIndex, 2]) > 1000) {
      timeSeriesIds[idIndex,] <- NA
      timeSeriesIds <- na.omit(timeSeriesIds)
      complexityMeasuresResults$removeRow(i)
      
      n2 <- n2 + 1
      complexityMeasuresResultsToAdd <- complexityMeasuresService$getInterval(n2, n2, asDataCollection = T)
      id <- complexityMeasuresResultsToAdd$getRowName(1)
      idIndex <- match(id, allTimeSeriesIds)
      timeSeriesIds <- rbind(timeSeriesIds, allTimeSeriesIds[idIndex,])
      complexityMeasuresResultsToAdd <- complexityMeasuresResultsToAdd$getRow(1)
      complexityMeasuresResults$addRow(as.numeric(complexityMeasuresResultsToAdd), name = id)
    } else {
      timeSeries <- timeSeriesService$get(rowName)
      timeSeriesCollection$add(timeSeries)
      i <- i + 1
      setTxtProgressBar(progressBar, i)
    }
  }
  close(progressBar)
  
  RLog::rlog$debug("Normalizing data...")
  complexityMeasuresResults$normalize(norm.min, norm.max)

  RLog::rlog$debug("Aplying clustering to all data...")
  clust_X <- analysis_clustering(complexityMeasuresResults)

  cmRows <- complexityMeasuresResults$rows()
  cmCols <- complexityMeasuresResults$cols()
  
  result <- list()
  result$data <- list()
  result$data$X <- list()
  result$data$X$rows <- cmRows
  result$data$X$cols <- cmCols

  RLog::rlog$debug("Aplying forecasting...")
  result$pred <- analysis_forecast(timeSeriesCollection, percent_train, clust_X)
  rm(timeSeriesCollection)
  
  sub_data <- complexityMeasuresResults$subdata(intervalA[1], intervalA[2], 1, cmCols)
  data_A <- DataUtils::DataCollection$new(sub_data)
  data_A$normalize(norm.min, norm.max)

  sub_data <- complexityMeasuresResults$subdata(intervalB[1], intervalB[2], 1, cmCols)
  data_B <- DataUtils::DataCollection$new(sub_data)
  data_B$normalize(norm.min, norm.max)

  sub_data <- complexityMeasuresResults$subdata(intervalC[1], intervalC[2], 1, cmCols)
  data_C <- DataUtils::DataCollection$new(sub_data)
  data_C$normalize(norm.min, norm.max)
  rm(sub_data)
  rm(complexityMeasuresResults)

  RLog::rlog$debug("Aplying clustering to the first subset...")
  clust_A <- analysis_clustering(data_A)
  rm(data_A)
  clust_X_A <- compare_blocks(clust_X$clust, clust_A$clust, intervalA)
  clust_A$clust <- NULL

  RLog::rlog$debug("Aplying clustering to the second subset...")
  clust_B <- analysis_clustering(data_B)
  rm(data_B)
  clust_X_B <- compare_blocks(clust_X$clust, clust_B$clust, intervalB)
  clust_B$clust <- NULL

  RLog::rlog$debug("Aplying clustering to the third subset...")
  clust_C <- analysis_clustering(data_C)
  rm(data_C)
  clust_X_C <- compare_blocks(clust_X$clust, clust_C$clust, intervalC)
  clust_C$clust <- NULL
  clust_X$clust <- NULL

  result$clust$clust_X <- clust_X
  result$clust$clust_A <- clust_A
  result$clust$clust_B <- clust_B
  result$clust$clust_C <- clust_C

  result$compare_blocks <- list()
  result$compare_blocks$X_A <- clust_X_A
  result$compare_blocks$X_B <- clust_X_B
  result$compare_blocks$X_C <- clust_X_C

  RLog::rlog$debug("END clustering")
  
  return(result)
}

table_compare_individual_clustering <- function(clust) {
  m <- matrix(nrow = 3, ncol = 4)
  m[1,1] <- clust$analysis[[1]]$ncenters
  m[2,1] <- clust$analysis[[2]]$ncenters
  m[3,1] <- clust$analysis[[3]]$ncenters

  m[1,2] <- clust$compare[[1]]$density[[1]]$max
  m[1,3] <- clust$compare[[1]]$density[[1]]$min
  m[1,4] <- clust$compare[[1]]$density[[1]]$sd

  m[2,2] <- clust$compare[[1]]$density[[2]]$max
  m[2,3] <- clust$compare[[1]]$density[[2]]$min
  m[2,4] <- clust$compare[[1]]$density[[2]]$sd

  m[3,2] <- clust$compare[[2]]$density[[2]]$max
  m[3,3] <- clust$compare[[2]]$density[[2]]$min
  m[3,4] <- clust$compare[[2]]$density[[2]]$sd

  colnames(m) <- c("ncenters", "max density", "min density", "standard desviation")
  rownames(m) <- c("KMeans", "CMeans", "HClust")
  table <- data.frame(m)
  return(table)
}

table_compare_pair_clustering <- function(clust) {
  m <- matrix(nrow = 3, ncol = 4)
  m[1,1] <- clust$compare[[1]]$n_centers_equals
  m[2,1] <- clust$compare[[2]]$n_centers_equals
  m[3,1] <- clust$compare[[3]]$n_centers_equals

  m[1,2] <- clust$compare[[1]]$n_centers_non_equals
  m[2,2] <- clust$compare[[2]]$n_centers_non_equals
  m[3,2] <- clust$compare[[3]]$n_centers_non_equals

  m[1,3] <- as.integer((clust$compare[[1]]$n_centers_equals/clust$analysis[[1]]$ncenters)*100)
  m[2,3] <- as.integer((clust$compare[[2]]$n_centers_equals/clust$analysis[[2]]$ncenters)*100)
  m[3,3] <- as.integer((clust$compare[[3]]$n_centers_equals/clust$analysis[[3]]$ncenters)*100)

  m[1,4] <- as.integer(clust$compare[[1]]$mean_similarility)
  m[2,4] <- as.integer(clust$compare[[2]]$mean_similarility)
  m[3,4] <- as.integer(clust$compare[[3]]$mean_similarility)

  colnames(m) <- c("centers identical", "centers different", "centers comun percent", "similarility mean")
  rownames(m) <- c("KMeans-CMeans", "KMeans-HClust", "CMeans-HClust")
  table <- data.frame(m)
  return(table)
}

table_compare_total_block_clustering <- function(comp_block, ncenters) {
  m <- matrix(nrow = 9, ncol = 4)

  for (i in 1:9) {
    m[i,1] <- comp_block[[i]]$n_centers_equals
    m[i,2] <- comp_block[[i]]$n_centers_non_equals
    m[i,3] <- as.integer((comp_block[[i]]$n_centers_equals/ncenters)*100)
    m[i,4] <- as.integer(comp_block[[i]]$mean_similarility)
  }

  colnames(m) <- c("centers identical", "centers different", "centers comun percent", "similarility mean")
  rownames(m) <- c("KMeans_X-KMeans_Subset", "KMeans_X-CMeans_Subset", "KMeans_X-HClust_Subset",
                   "CMeans_X-KMeans_Subset", "CMeans_X-CMeans_Subset", "CMeans_X-HClust_Subset",
                   "HClust_X-KMeans_Subset", "HClust_X-CMeans_Subset", "HClust_X-HClust_Subset")
  table <- data.frame(m)
  return(table)
}

table_forecast <- function(data) {
  m <- matrix(nrow = data$cols() - 1, ncol = 2)
  
  methods <- data$getColNames()
  
  for (i in 1:(data$cols() - 1)) {
    m[i, 1] <- c(methods[i])
    m[i, 2] <- paste(which(data$getCol(7) == methods[i]), collapse = ", ")
  }
  
  colnames(m) <- c("Methods", "Centers")
  
  table <- data.frame(m)
  
  return(table)
}

RLog::rlog$setLevel("DEBUG")
n1 <- 1
n2 <- 10
norm.min <- -1
norm.max <- 1
percent_train <- 0.8
intervalA <- c(1,3)
intervalB <- c(4,6)
intervalC <- c(7,10)
result <- analysis_blocks(percent_train, n1, n2, norm.min, norm.max, intervalA, intervalB, intervalC)
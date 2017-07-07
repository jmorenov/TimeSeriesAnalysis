context("Testing CompareClustering")

test_that("CompareClustering using clustering_test.csv", {
  file <- "data/clustering_test.csv"
  f <- FileReader$new(file)
  d <- f$read()
  d <- na.omit(apply(d, c(1,2), function(x) replace(x, is.infinite(x), NA)))
  data_clustering_2 <- DataCollection$new(d)
  data_clustering_2$normalize()
  data_clustering_1 <- DataCollection$new(data_clustering_2$subdata(1, 30, 1, 6))

  km <- KMeans$new()
  cluster_1 <- km$apply(data_clustering_1)
  cluster_2 <- km$apply(data_clustering_2)
  comp <- CompareClustering$new(cluster_1, cluster_2)
  comp$compare()
  sm <- comp$getSimilarilityMatrix()
  md <- comp$getMaxDiff()
  # sm_order <- comp$getSimilarilityMatrixOrder()
})

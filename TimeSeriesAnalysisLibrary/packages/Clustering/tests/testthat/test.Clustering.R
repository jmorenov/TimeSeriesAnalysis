context("Testing Clustering")

test_that("Clustering with MClust method and data readed from clustering_test.csv", {
  file <- "data/clustering_test.csv"
  data <- DataUtils::DataCollection$new(file)
  data$normalize()
  m <- getClusteringMethods()
  clust <- Clustering$new(m, data)
  clust$run(n_cores = 1)
  for (i in 1:m$size())
    expect_true(all(m$get(i)$apply(data)$get()$toBasicCollection() ==
                      clust$getResults()$get(i)$get()$toBasicCollection()))
  clust$run(n_cores = 2)
  for (i in 1:m$size())
    expect_true(all(m$get(i)$apply(data)$get()$toBasicCollection() ==
                      clust$getResults()$get(i)$get()$toBasicCollection()))
})

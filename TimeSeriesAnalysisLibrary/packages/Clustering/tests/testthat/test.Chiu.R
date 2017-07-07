context("Testing Chiu")

test_that("Apply method chiu over clustering_test.csv", {
file <- "data/clustering_test.csv"
data <- DataCollection$new(file)
data$normalize()
chiu <- Chiu$new()
centers <- chiu$apply(data)
})
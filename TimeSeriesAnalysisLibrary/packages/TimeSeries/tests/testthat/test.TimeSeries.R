context("Testing TimeSeries")

test_that("initialize method not work correctly", {
  file <- "data/datasets_test.csv"
  f <- FileReader$new(file)
  data <- f$read()
  d <- DataCollection$new(data)
  row <- d$getRow(1)
  id <- d$getRowName(1)
  t <- TimeSeries$new(id = id, name = row[["name"]],
                     data = row[["file"]], start = row[["start"]],
                     end = row[["end"]], frequency = row[["frequency"]])
  expect_is(t, "TimeSeries")
  expect_true(t$getID() == id)
  expect_true(t$getName() == row[["name"]])
  expect_true(t$getStart() == row[["start"]])
  expect_true(t$getEnd() == row[["end"]])
  # expect_true(t$getFrequency() == row[["frequency"]])

  dd <- matrix(1:10, nrow = 10, ncol = 1)
  data <- DataCollection$new(dd)
  t <- TimeSeries$new(data, "test", start = 1, end = 10, frequency = 1)

  tt <- t$toTS()
  expect_true(is.ts(tt))

  traintest <- t$getTrainTest(0.8)
  expect_true(is.ts(traintest$train))
  expect_true(is.ts(traintest$test))

  expect_true(length(traintest$train) == as.integer(0.8 * t$getNValues()))

})

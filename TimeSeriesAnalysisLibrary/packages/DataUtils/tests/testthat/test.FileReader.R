context("Testing FileReader")

test_that("initialize method not work correctly", {
  expect_error(f <- FileReader$new(a))
  expect_error(f <- FileReader$new("a"))
  f <- FileReader$new("data/test.csv")
  data <- f$read()
  data[1,1] <- 10
  f$write(data, override_file = FALSE, new_file = "data/test2.csv")
  expect_true(file.exists("data/test2.csv"))
  f2 <- FileReader$new("data/test2.csv")
  expect_true(f2$read()[1,1] == 10)
  file.remove("data/test2.csv")
})

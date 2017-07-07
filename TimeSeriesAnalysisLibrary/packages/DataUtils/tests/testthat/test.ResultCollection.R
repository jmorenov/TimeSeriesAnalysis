context("Testing ResultCollection")

test_that("initialize method not work correctly", {
  r <- ResultCollection$new(10)
  expect_is(r, "ResultCollection")
  expect_true(r$size() == 10)
  re <- Result$new()
  re$set(10.0)
  r$add(re)
  expect_true(r$size() == 11)
  expect_equal(r$get(11), re)
  expect_true(r$get(11)$get() == re$get())
})

test_that("toBasicCollection method not work correctly", {
  r <- ResultCollection$new(10)
  expect_error(r$toBasicCollection())
  re <- Result$new()
  re$set(10.0)
  r$add(re)
  re$set(5)
  r$add(re)
  expect_true(all(unlist(r$toBasicCollection()) == c(10, 5)))
})

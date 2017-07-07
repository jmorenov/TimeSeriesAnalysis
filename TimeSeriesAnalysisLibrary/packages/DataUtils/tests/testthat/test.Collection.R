context("Testing Collection")

test_that("initialize method not work correctly", {
  co <- Collection$new()
  expect_is(co <- Collection$new(), "Collection")
  expect_error(co$initialize(-1))
  expect_error(co$initialize("1"))
  expect_error(co$initialize(10, "vector"))
  expect_error(co$initialize(10, vector))
})

test_that("add method not work correctly", {
  co <- Collection$new(type = "numeric")
  expect_error(co$add())
  expect_error(co$add(TRUE))
  co$initialize(10, type = "numeric")
  expect_true(co$size() == 10)
  co$add(89, 5)
  expect_true(co$size() == 11)
  expect_true(co$get(5) == 89)
})

test_that("get method not work correctly", {
  co <- Collection$new(type = "numeric")
  expect_error(co$get())
  expect_error(co$get(1))
  co$add(1)
  try(expect_equal(co$get(1), 1))
})

test_that("set method not work correctly", {
  co <- Collection$new(type = "numeric")
  expect_error(co$set())
  expect_error(co$set(TRUE))
  co$add(1)
  co$set(2,1)
  expect_equal(co$get(1), 2)
})

test_that("removeAll method not work correctly", {
  co <- Collection$new(10, type = "numeric")
  expect_true(co$size() == 10)
  co$removeAll()
  expect_true(co$size() == 0)
  expect_error(co$removeAll())
})

test_that("toBasicCollection method not work correctly", {
  co <- Collection$new(type = "numeric")
  co$add(1)
  co$add(2)
  co$add(3)
  expect_true(all(co$toBasicCollection() == c(1,2,3)))
})

test_that("size method not work correctly", {
  co <- Collection$new(9, type = "numeric")
  expect_true(co$size() == 9)
  co$add(2)
  expect_true(co$size() == 10)
})

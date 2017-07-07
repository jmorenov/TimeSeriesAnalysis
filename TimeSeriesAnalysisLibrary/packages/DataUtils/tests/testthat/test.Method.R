context("Testing Method")

test_that("initialize method not work correctly", {
  m <- Method$new("test")
  expect_is(m, "Method")
  expect_error(m$initialize())
})

test_that("apply method not work correctly", {
  m <- Method$new("test")
  d <- DataCollection$new(10, 10)
  expect_error(m$apply())
  expect_error(m$apply(2))
  expect_is(m$apply(d), "MethodResult")
})

test_that("getName method not work correclty", {
  m <- Method$new("test")
  expect_true(m$getName() == "test")
})

test_that("getDescription method not work correclty", {
  m <- Method$new("test", "desc")
  expect_true(m$getDescription() == "desc")
})

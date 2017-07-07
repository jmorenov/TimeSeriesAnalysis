context("Testing MethodResult")

test_that("MethodResult Class not work correctly", {
  mr <- MethodResult$new("name")
  expect_is(mr, "MethodResult")
  expect_error(mr$initialize())
  mr$set(122)
  expect_true(mr$get() == 122)
})

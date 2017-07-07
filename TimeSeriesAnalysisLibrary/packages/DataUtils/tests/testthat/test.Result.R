context("Testing Result")

test_that("Result Class not work correctly", {
  r <- Result$new()
  expect_is(r, "Result")
  expect_error(r$set())
  r$set(10.2)
  expect_true(r$get() == 10.2)
})

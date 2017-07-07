context("Testing HttpService")

httpService <- HttpService$new()

test_that("Initialize", {
  expect_is(httpService, "HttpService")
})
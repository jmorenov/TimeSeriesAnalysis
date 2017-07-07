context("Testing MethodCollection")

test_that("initialize method not work correctly", {
  mc <- MethodCollection$new()
  expect_is(mc, "MethodCollection")
  m <- Method$new("test")
  mc$add(m)
  expect_is(mc$get(1), "Method")
  expect_equal(mc$get(1), m)
})

test_that("applyAll method not work correctly", {
  mc <- MethodCollection$new()
  m <- Method$new("test")
  mc$add(m)
  data <- DataCollection$new(20, 20)
  rc <- mc$applyAll(data, parallel = FALSE)
  expect_is(rc, "ResultCollection")
  expect_equal(rc$get(1), m$apply(data))
  expect_true(rc$get(1)$get() == m$apply(data)$get())
})

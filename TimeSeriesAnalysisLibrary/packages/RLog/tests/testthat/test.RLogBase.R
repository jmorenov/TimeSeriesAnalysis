context("Testing RLogBase")

rlog <- RLogBase$new()

test_that("Initialize", {
  expect_is(rlog, "RLogBase")
})

test_that("error", {
  expect_error(rlog$error("error"), "error")
})

test_that("warn", {
  expect_warning(rlog$warn("warning"), "warning")
})

test_that("info", {
  expect_message(rlog$info("info"), "INFO: info")
})

test_that("debug", {
  expect_message(rlog$debug("debug"), "DEBUG: debug")
})
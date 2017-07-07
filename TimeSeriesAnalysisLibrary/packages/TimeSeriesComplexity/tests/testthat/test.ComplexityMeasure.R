context("Testing ComplexityMeasure")

test_that("initialize method not work correctly", {
  m <- ComplexityMeasure$new("test")
  expect_is(m, "ComplexityMeasure")
})

test_that("apply method not work correctly", {
  m <- ComplexityMeasure$new("test")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("Kolmogorov not work correctly", {
  m <- Kolmogorov$new()
  expect_is(m, "Kolmogorov")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("SampleEntropy not work correctly", {
  m <- SampleEntropy$new()
  expect_is(m, "SampleEntropy")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("PracmaSampleEntropy not work correctly", {
  m <- PracmaSampleEntropy$new()
  expect_is(m, "PracmaSampleEntropy")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("PermutationEntropy not work correctly", {
  m <- PermutationEntropy$new()
  expect_is(m, "PermutationEntropy")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("AproximationEntropy not work correctly", {
  m <- AproximationEntropy$new()
  expect_is(m, "AproximationEntropy")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("LempelZiv not work correctly", {
  m <- LempelZiv$new()
  expect_is(m, "LempelZiv")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("ShannonEntropy not work correctly", {
  m <- ShannonEntropy$new()
  expect_is(m, "ShannonEntropy")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("ChaoShenEntropy not work correctly", {
  m <- ChaoShenEntropy$new()
  expect_is(m, "ChaoShenEntropy")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("DirichletEntropy not work correctly", {
  m <- DirichletEntropy$new()
  expect_is(m, "DirichletEntropy")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("MillerMadowEntropy not work correctly", {
  m <- MillerMadowEntropy$new()
  expect_is(m, "MillerMadowEntropy")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

test_that("ShrinkEntropy not work correctly", {
  m <- ShrinkEntropy$new()
  expect_is(m, "ShrinkEntropy")
  expect_error(m$apply())
  d <- matrix(1:40, ncol = 20, nrow = 20)
  t <- TimeSeriesData$new(d)
  expect_is(m$apply(t), "MethodResult")
})

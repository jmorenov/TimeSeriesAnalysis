context("Testing DataCollection")

file_name <- "data/test.csv"
fr <- FileReader$new(file_name)

test_function <- function(dc, d) {
  expect_is(dc, "DataCollection")
  expect_true(dc$is_validated())
  expect_true(all(dc$toBasicCollection() == d))

  expect_error(dc$getCol())
  expect_error(dc$getColName())
  expect_true(all(dc$getCol(1) == dc$getCol(name = "V1")))
  expect_true(all(dc$getCol(name = dc$getColName(1)) == dc$getCol(1)))
  expect_true(all(dc$getCol(1) == d[,1]))

  expect_error(dc$getCol())
  expect_error(dc$getColName())
  expect_true(all(dc$getRow(1) == dc$getRow(name = "a")))
  expect_true(all(dc$getRow(name = dc$getRowName(1)) == dc$getRow(1)))
  expect_true(all(dc$getRow(1) == d[1,]))

  dc$set(12, 1, 2)
  expect_true(dc$get(1, 2) == 12)

  expect_true(all(dc$getColNames() == colnames(d)))
  expect_true(all(dc$getRowNames() == rownames(d)))

  dc$addRow()
  expect_true(all(dc$getRow(dc$rows()) == c(0, 0, 0, 0, 0)))
  dc$addRow(6:10, name = "rowtest")
  expect_true(all(dc$getRow(dc$rows()) == 6:10))
  expect_true(all(dc$getRow(name = "rowtest") == 6:10))
  dc$addRow(6:10, 2, name = "rowtest2")
  expect_true(all(dc$getRow(2) == 6:10))
  expect_true(all(dc$getRow(name = "rowtest2") == dc$getRow(2)))
  dc$setRow(10:14, 2, name = "rowtest3")
  expect_true(all(dc$getRow(2) == 10:14))
  expect_true(all(dc$getRow(name = "rowtest3") == dc$getRow(2)))
  expect_error(dc$addRow(1:6))
  expect_error(dc$addRow(1:5, dc$rows() + 2))
  row <- dc$getRow(4)
  dc$removeRow(3)
  expect_true(all(dc$getRow(3) == row))
  expect_error(dc$removeRow())
  expect_error(dc$removeRow(dc$rows() + 1))

  dc$addCol()
  expect_true(all(dc$getCol(dc$cols()) == c(0, 0, 0, 0)))
  dc$addCol(1:4, name = "coltest")
  expect_true(all(dc$getCol(dc$cols()) == 1:4))
  expect_true(all(dc$getCol(name = "coltest") == 1:4))
  dc$addCol(1:4, 2, name = "coltest2")
  expect_true(all(dc$getCol(2) == 1:4))
  expect_true(all(dc$getCol(name = "coltest2") == dc$getCol(2)))
  dc$setCol(10:13, 2, name = "coltest3")
  expect_true(all(dc$getCol(2) == 10:13))
  expect_true(all(dc$getCol(name = "coltest3") == dc$getCol(2)))
  expect_error(dc$addCol(1:5))
  expect_error(dc$addCol(1:4, dc$cols() + 2))
  col <- dc$getCol(2)
  dc$removeCol(1)
  expect_true(all(dc$getCol(1) == col))
  expect_error(dc$removeCol())
  expect_error(dc$removeCol(dc$cols() + 1))

  expect_true(all(dc$subdata(1, 2, 1, 2) == dc$toBasicCollection()[1:2, 1:2]))

  dc$invalidate()
  dc$get(1, 1)
  expect_true(dc$is_validated())

  file.create("data/test3.csv")
  dc$export("data/test3.csv")
  dc1 <- DataCollection$new("data/test3.csv")
  expect_true(all(dc$toBasicCollection() == dc1$toBasicCollection()))
  file.remove("data/test3.csv")

  dc$clear()
  expect_true(dc$empty())
}

test_that("DataCollection build from file path", {
  d <- fr$read()
  dc <- DataCollection$new(file_name)
  test_function(dc, d)
})

test_that("DataCollection build from FileReader", {
  d <- fr$read()
  dc <- DataCollection$new(fr)
  test_function(dc, d)
})

test_that("DataCollection build from another DataCollection", {
  d <- fr$read()
  dd <- DataCollection$new(fr)
  dc <- DataCollection$new(dd)
  test_function(dc, d)
})

test_that("DataCollection build from matrix", {
  d <- as.matrix(fr$read())
  dc <- DataCollection$new(d)
  test_function(dc, d)
})

test_that("DataCollection build from nrows, ncols and type", {
  d <- as.matrix(fr$read())
  dc <- DataCollection$new(nrows = nrow(d), ncols = ncol(d), type = "numeric")
  for (i in 1:dc$rows()) {
    for (j in 1:dc$cols()) {
      dc$set(d[i,j], i, j)
    }
  }
  dc$setColNames(colnames(d))
  dc$setRowNames(rownames(d))
  test_function(dc, d)
})

test_that("DataCollection normalize and denormalize data.", {
  d <- DataCollection$new(file_name)
  d.init <- d$toBasicCollection()
  d$normalize()
  d.norm <- d$toBasicCollection()
  d$denormalize()
  d.denorm <- d$toBasicCollection()
  expect_true(all(d.init == d.denorm))
})

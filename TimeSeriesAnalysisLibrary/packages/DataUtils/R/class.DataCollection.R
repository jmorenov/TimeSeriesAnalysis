#' DataCollection
#'
#' Clase que almacena datos en forma de matrices e implementa metodos genericos para gestionarlos.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A DataCollection Class of type \code{\link{R6Class}}.
#' @section Warning: Comprobacion de tipos sin implementar.
#'  No se comprueba al add una columna o fila si su tam es menor al de la matriz,
#'   solo si es superior.
#'
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#'
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
DataCollection <- R6Class("DataCollection",
                             private = list(
                               nrows = 0,
                               ncols = 0,
                               data = NULL,
                               valid_data = FALSE,
                               sreader = NULL,
                               file_temp = NULL,
                               edited = FALSE,
                               normalized = FALSE,
                               normalize_min = 0,
                               normalize_max = 1,
                               normalize_range = NA,
                               big_matrix = FALSE,
                               check_index = function(index, n) {
                                 assert(is.numeric(index), CRITICAL_ERROR)
                                 index <- as.integer(index)
                                 assert(index > 0 && index <= n, CRITICAL_ERROR)
                                 return(index)
                               },
                               delete = function(e) {
                                 private$data <<- NULL
                                 private$sreader <<- NULL
                                 if (!is.null(private$file_temp)) {
                                   if (file.exists(private$file_temp$getFileName())) {
                                     tryCatch({
                                       #file.remove(private$file_temp$getFileName())
                                     }, error = function () {
                                       unlink(private$file_temp$getFileName(), recursive=TRUE)
                                     })
                                   }
                                   if (file.exists(paste0(private$file_temp$getName(), ".desc"))) {
                                      tryCatch({
                                        #file.remove(paste0(private$file_temp$getName(), ".desc"))
                                      }, error = function () {
                                        unlink(paste0(private$file_temp$getName(), ".desc"), recursive=TRUE)
                                      })
                                   }
                                   private$file_temp <<- NULL
                                 }
                               }
                               ),
                          public = list(
                               initialize = function(data = NULL, nrows = 0, ncols = 0, init = NA, type = "double", big_matrix = FALSE) {
                                 if (is.character(data) && !is.matrix(data)) data <- FileReader$new(data)
                                 if ("StreamReader" %in% class(data)) private$sreader <<- data
                                 else if ("DataCollection" %in% class(data)) {
                                   private$data <<- data$toBasicCollection()
                                   private$sreader <<- data$getSReader()
                                 }
                                 else if (is.array(data) || is.matrix(data) || is.list(data) || is.data.frame(data) || is.vector(data) || is.ts(data)) {
                                   if (big_matrix) {
                                     private$file_temp <<- FileReader$new()
                                     private$data <<- bigmemory::as.big.matrix(data,
                                                                            type = typeof(data),
                                                                            backingfile = private$file_temp$getName(),
                                                                            descriptorfile = paste0(private$file_temp$getName(), ".desc"),
                                                                            backingpath = private$file_temp$getPath())
                                     private$big_matrix <<- TRUE
                                     private$nrows <<- nrow(private$data)
                                     private$ncols <<- ncol(private$data)
                                   } else {
                                      private$data <<- as.matrix(data)
                                   }
                                 }
                                 else if (bigmemory::is.big.matrix(data)) {
                                   private$data <<- data
                                   private$big_matrix <<- TRUE
                                   private$nrows <<- nrow(private$data)
                                   private$ncols <<- ncol(private$data)
                                 }
                                 else {
                                   # if (nrows >= 10000) big_matrix <- TRUE
                                   if (!big_matrix) {
                                     if (!is.na(init))
                                       private$data <<- matrix(replicate(n = nrows * ncols, init), nrow = nrows, ncol = ncols)
                                     else private$data <<- matrix(nrow = nrows, ncol = ncols)
                                   } else {
                                     private$big_matrix <<- TRUE
                                     private$file_temp <<- FileReader$new()
                                     options(bigmemory.allow.dimnames = TRUE)
                                     # CHECK!!
                                     file.remove(paste0(paste0(private$file_temp$getPath(), "/"), private$file_temp$getName()))
                                     private$data <<- bigmemory::big.matrix(nrow = nrows, ncol = ncols, init = init,
                                                                            type = type,
                                                                            backingfile = private$file_temp$getName(),
                                                                            descriptorfile = paste0(private$file_temp$getName(), ".desc"),
                                                                            backingpath = private$file_temp$getPath())
                                     private$nrows <<- nrow(private$data)
                                     private$ncols <<- ncol(private$data)
                                   }
                                   if (ncols > 0) colnames(private$data) <<- as.character(1:ncols)
                                   if (nrows > 0) rownames(private$data) <<- as.character(1:nrows)
                                 }
                                 self$validate()
                                 reg.finalizer(self, private$delete, onexit = TRUE)
                               },
                               set = function(value, nrow, ncol) {
                                 assert(!missing(value) && !missing(nrow) && !missing(ncol), CRITICAL_ERROR)
                                 nrow <- private$check_index(nrow, self$rows())
                                 ncol <- private$check_index(ncol, self$cols())
                                 self$validate()
                                 private$data[nrow, ncol] <<- value
                                 private$edited <<- TRUE
                               },
                               get = function(nrow, ncol) {
                                 assert(!missing(nrow) && !missing(ncol), CRITICAL_ERROR)
                                 nrow <- private$check_index(nrow, self$rows())
                                 ncol <- private$check_index(ncol, self$cols())
                                 self$validate()
                                 private$data[nrow, ncol]
                               },
                               getCol = function(ncol, name) {
                                 assert(!missing(ncol) || !missing(name), CRITICAL_ERROR)
                                 self$validate()
                                 if (!missing(ncol)) ncol <- private$check_index(ncol, self$cols())
                                 else {
                                   assert(name %in% colnames(private$data), CRITICAL_ERROR)
                                   ncol <- name
                                 }
                                 private$data[, ncol]
                               },
                               getRow = function(nrow, name) {
                                 assert(!missing(nrow) || !missing(name), CRITICAL_ERROR)
                                 self$validate()
                                 if (!missing(nrow)) nrow <- private$check_index(nrow, self$rows())
                                 else {
                                   assert(name %in% rownames(private$data), CRITICAL_ERROR)
                                   nrow <- name
                                 }
                                 private$data[nrow, ]
                               },
                               addCol = function(col = vector(length = self$rows()),
                                                 ncol = self$cols() + 1, name = as.character(ncol)) {
                                 self$setCol(col, ncol, name, TRUE)
                               },
                               setCol = function(col, ncol, name, add = FALSE) {
                                 assert(!missing(ncol) && !missing(col), CRITICAL_ERROR)
                                 col <- as.vector(col)
                                 assert(length(col) <= self$rows(), CRITICAL_ERROR)
                                 self$validate()
                                 if (add) {
                                   ncol <- private$check_index(ncol, self$cols() + 1)
                                   if (ncol == 1) private$data <<- cbind(col, private$data)
                                   else if (ncol == self$cols() + 1) private$data <<- cbind(private$data, col)
                                   else private$data <<- cbind(private$data[,1:(ncol - 1)],
                                                               cbind(col, private$data[,ncol:self$cols()]))
                                 } else {
                                   ncol <- private$check_index(ncol, self$cols())
                                   private$data[, ncol] <<- col
                                 }
                                 if (!missing(name)) colnames(private$data)[ncol] <<- as.character(name)
                                 private$edited <<- TRUE
                               },
                               addRow = function(row = vector(length = self$cols()),
                                                 nrow = self$rows() + 1, name = as.character(nrow)) {
                                 self$setRow(row, nrow, name, TRUE)
                               },
                               setRow = function(row, nrow, name, add = FALSE) {
                                 assert(!missing(nrow) && !missing(row), CRITICAL_ERROR)
                                 row <- as.vector(row)
                                 assert(length(row) <= self$cols(), CRITICAL_ERROR)
                                 self$validate()
                                 if (add) {
                                  nrow <- private$check_index(nrow, self$rows() + 1)
                                  if (nrow == 1) private$data <<- rbind(row, private$data)
                                  else if (nrow == self$rows() + 1) private$data <<- rbind(private$data, row)
                                  else private$data <<- rbind(private$data[1:(nrow - 1),],
                                                              rbind(row, private$data[nrow:self$rows(),]))
                                 } else {
                                   nrow <- private$check_index(nrow, self$rows())
                                   private$data[nrow, ] <<- row
                                 }
                                 if (!missing(name)) rownames(private$data)[nrow] <<- as.character(name)
                                 private$edited <<- TRUE
                               },
                               getColName = function(ncol) {
                                 assert(!missing(ncol), CRITICAL_ERROR)
                                 ncol <- private$check_index(ncol, self$cols())
                                 colnames(private$data)[ncol]
                               },
                               getRowName = function(nrow) {
                                 assert(!missing(nrow), CRITICAL_ERROR)
                                 nrow <- private$check_index(nrow, self$rows())
                                 rownames(private$data)[nrow]
                               },
                               subdata = function(fromrow, torow, fromcol, tocol) {
                                 assert(!missing(fromrow) && !missing(tocol)
                                        && !missing(fromcol) && !missing(tocol), CRITICAL_ERROR)
                                 fromrow <- private$check_index(fromrow, self$rows())
                                 torow <- private$check_index(torow, self$rows())
                                 fromcol <- private$check_index(fromcol, self$cols())
                                 tocol <- private$check_index(tocol, self$cols())
                                 self$validate()
                                 private$data[fromrow:torow, fromcol:tocol]
                               },
                               removeCol = function(ncol) {
                                 assert(!missing(ncol), CRITICAL_ERROR)
                                 ncol <- private$check_index(ncol, self$cols())
                                 self$validate()
                                 if (self$cols() > 2) {
                                   private$data <<- private$data[,-ncol]
                                 } else {
                                   private$data <<- matrix(private$data[,-ncol], nrow = self$rows(), ncol = 1)
                                 }
                                 private$edited <<- TRUE
                               },
                               removeRow = function(nrow) {
                                 assert(!missing(nrow), CRITICAL_ERROR)
                                 nrow <- private$check_index(nrow, self$rows())
                                 self$validate()
                                 private$data <<- private$data[-nrow,]
                                 private$edited <<- TRUE
                               },
                               cols = function() {
                                 if (self$is_validated()) ncol(private$data)
                                 else private$ncols
                               },
                               rows = function() {
                                 if (self$is_validated()) nrow(private$data)
                                 else private$nrows
                               },
                               dim = function() { self$rows() * self$cols() },
                               toBasicCollection = function() {
                                 self$validate()
                                 private$data
                               },
                               clear = function() {
                                 if (!self$empty()) {
                                   private$nrows <<- 0
                                   private$ncols <<- 0
                                   private$data <<- NA
                                   private$sreader <<- NULL
                                   private$valid_data <<- FALSE
                                   private$edited <<- TRUE
                                 }
                               },
                               empty = function() { return(self$rows() == 0 && self$cols() == 0) },
                               export = function(file_name) {
                                 if (missing(file_name)) {
                                   assert("FileReader" %in% class(private$sreader), CRITICAL_ERROR)
                                   private$sreader$write(private$data, override_file = TRUE)
                                 }
                                 else {
                                   if (is.null(private$sreader)) {
                                     file.create(file_name)
                                     private$sreader <<- FileReader$new(file_name)
                                   }
                                   private$sreader$write(private$data, override_file = FALSE, new_file = file_name)
                                 }

                               },
                               invalidate = function() {
                                 if (self$is_bigmatrix()) {
                                   # Falta por implementar.
                                 } else if (self$is_validated()) {
                                   if (!is.null(private$sreader) && !private$edited) private$data <<- NULL
                                   else {
                                     private$file_temp <<- FileReader$new()
                                     private$file_temp$write(private$data, override_file = TRUE)
                                   }
                                   private$valid_data <<- FALSE
                                 }
                               },
                               validate = function() {
                                 if (self$is_bigmatrix()) {
                                   # Falta por implementar.
                                 } else if (!self$is_validated()) {
                                   if (!private$edited && !is.null(private$sreader) && is.null(private$data)) private$data <<- private$sreader$read()
                                   else if (!is.null(private$file_temp) && is.null(private$data)) private$data <<- private$file_temp$read()
                                   private$valid_data <<- TRUE
                                   private$nrows <<- nrow(private$data)
                                   private$ncols <<- ncol(private$data)
                                 }
                               },
                               is_validated = function() { private$valid_data },
                               getSReader = function() {
                                 if (!is.null(private$sreader)) private$sreader$clone(deep = TRUE)
                                 else NULL
                               },
                               setColNames = function(names) {
                                 assert(!missing(names) && length(names) == self$cols(), CRITICAL_ERROR)
                                 colnames(private$data) <<- names
                               },
                               setRowNames = function(names) {
                                 assert(!missing(names) && length(names) == self$rows(), CRITICAL_ERROR)
                                 rownames(private$data) <<- names
                               },
                               getColNames = function() {
                                 colnames(private$data)
                               },
                               getRowNames = function() {
                                 rownames(private$data)
                               },
                               normalize = function(min_scale = 0, max_scale = 1) {
                                 if (!self$is_normalized()) {
                                   assert(is.numeric(min_scale) && is.numeric(max_scale), CRITICAL_ERROR)
                                   data.norm <- self$toBasicCollection()
                                   # range.data <- t(colRanges(data.norm))
                                   range.data <- matrix(nrow = 2, ncol = self$cols())
                                   for (i in 1:self$cols()) {
                                     range.data[[1, i]] <- min(self$getCol(i))
                                     range.data[[2, i]] <- max(self$getCol(i))
                                   }

                                   # normalize all data on each column
                                   for (j in 1:self$cols()) {
                                     min.data <- range.data[[1, j]]
                                     max.data <- range.data[[2, j]]
                                     data.norm[, j] <- min_scale + (self$getCol(j) - min.data) *
                                       (max_scale - min_scale) / (max.data - min.data)
                                   }
                                   private$data <<- data.norm
                                   private$normalize_range <<- range.data
                                   private$normalize_min <<- min_scale
                                   private$normalize_max <<- max_scale
                                   private$normalized <<- TRUE
                                 }
                               },
                               denormalize = function() {
                                 if (self$is_normalized()) {
                                   data.denorm <- self$toBasicCollection()
                                   # denormalize all data on each column
                                   for (j in 1:self$cols()) {
                                     min.data <- private$normalize_range[[1, j]]
                                     max.data <- private$normalize_range[[2, j]]
                                     data.denorm[, j] <- min.data + (self$getCol(j) - private$normalize_min) *
                                       (max.data - min.data) / (private$normalize_max - private$normalize_min)
                                   }
                                   private$data <<- data.denorm
                                   private$normalized <<- FALSE
                                 }
                               },
                               is_normalized = function() {
                                 return(private$normalized)
                               },
                               is_bigmatrix = function() {
                                 return(private$big_matrix)
                               },
                               print = function(...) {
                                 cat("<DataCollection> of dimension ", self$dim(), "\n", sep = "")
                               },
                               distance = function() {
                                 if (self$is_bigmatrix()) {
                                   distance_matrix <- DataCollection$new(nrows = 1,
                                                                         ncols = self$rows() * (self$rows() - 1) / 2,
                                                                         big_matrix = TRUE)
                                   dist_(private$data@address, distance_matrix$toBasicCollection()@address)
                                   distance_matrix <- distance_matrix$toBasicCollection()[]
                                   attributes(distance_matrix) <- NULL
                                   if (!is.null(self$getRowNames()))
                                     attr(distance_matrix,"Labels") <- self$getRowNames()
                                   else if (!is.null(self$getColNames()))
                                     attr(distance_matrix,"Labels") <- self$getColNames()
                                   attr(distance_matrix,"Size") <- as.integer(self$rows())
                                   attr(distance_matrix, "call") <- match.call()
                                   class(distance_matrix) <- "dist"
                                   attr(distance_matrix,"Diag") <- FALSE
                                   attr(distance_matrix,"Upper") <- FALSE
                                 }
                                 else {
                                   distance_matrix <- dist(private$data)
                                 }
                                 return(distance_matrix)
                               }
                             ))

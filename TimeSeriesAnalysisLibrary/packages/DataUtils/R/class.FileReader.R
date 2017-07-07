#' StreamReader
#'
#' Clase almacena resultados de complejidad sobre series temporales en
#' forma de matrix usando la clase \code{\link{DataCollection}}
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A StreamReader Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
FileReader <- R6Class("FileReader", inherit = StreamReader,
                        private = list(
                        ),
                        public = list(
                          initialize = function(filename) {
                            if (missing(filename)) {
                              if (!dir.exists(tempdir()))
                                assert(dir.create(tempdir()), RLog::CRITICAL_ERROR)
                              filename <- tempfile()
                              assert(file.create(filename), RLog::CRITICAL_ERROR)
                            }
                            assert(is.character(filename), RLog::CRITICAL_ERROR)
                            assert(file.exists(filename), RLog::CRITICAL_ERROR)
                            super$initialize(filename)
                          },
                          read = function(rownames = TRUE) {
                            if (rownames) rownames <- 1
                            else rownames <- NULL
                            as.matrix(read.csv(self$getStreamName(), stringsAsFactors = FALSE, row.names = 1))
                          },
                          write = function(x, rownames = TRUE, override_file = FALSE, new_file) {
                            if (!override_file) {
                              if (missing(new_file)) {
                                file <- file_name(self$getStreamName())
                                ext <- file_ext(self$getStreamName())
                                new_file <- paste0(file, "_", date(), ".", ext)
                              }
                            } else new_file <- self$getStreamName()
                            write.csv(x = x, file = new_file, row.names = rownames)
                          },
                          getName = function() {
                            return(basename(self$getStreamName()))
                          },
                          getPath = function() {
                            return(dirname(self$getStreamName()))
                          },
                          getFileName = function() {
                            return(self$getStreamName())
                          }
                        ))

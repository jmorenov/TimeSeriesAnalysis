#' Devuelve la extension de un archivo.
#'
#' @export
#'
#' @param file_name the name of a file.
#'
#' @return The extension of a file.
#'
#' @examples
#' file_ext("test.csv")
#'
file_ext <- function(file_name) {
  names <- strsplit(file_name, "\\.")[[1]]
  return(names[length(names)])
}

#' Devuelve el nombre de un archivo sin su extension.
#'
#' @export
#'
#' @param file the name of a file.
#'
#' @return The name of a file without it extension.
#'
#' @examples
#' file_name("test.csv")
#'
file_name <- function(file) {
  names <- strsplit(file, "\\.")[[1]]
  return(names[1])
}

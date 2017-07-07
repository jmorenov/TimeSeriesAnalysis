#' Evalua una expresion devolviendo error si falla.
#'
#' @export
#'
#' @param expr A logical expression.
#' @param error_msg A error message.
#' @param call logical if True print the call of the expression with error too.
#'
#' @return error if expr is FALSE.
#'
#' @examples
#' \dontrun{
#'  assert(1 < 0, "1 no es menor que 0.")
#' }
#'
assert <- function(expr, error_msg, call = TRUE) {
  if (any(is.na(expr)) || !all(expr)) {
    stop(error_msg, call. = call)
  }
}

#' Object of type RLog to send messages.
#'
#' @export
rlog <- NULL

.onLoad <- function(libname, pkgname) {
  if (requireNamespace("futile.logger", quietly = TRUE)) {
    rlog <<- RLogFutile$new()
  } else {
    rlog <<- RLogBase$new()
    rlog$info(LOG_PACKAGE_NOT_FOUND)
  }
}

#' Package not found error message
#'
#' @export
PACKAGE_NOT_FOUND <- "Paquete no encontrado."

#' Log package not found error message
#'
#' @export
LOG_PACKAGE_NOT_FOUND <- "Paquete de log no encontrado."

#' Index out of range error message
#'
#' @export
INDEX_OUT_OF_RANGE <- "Indice fuera de rango."

#' Value type error message
#'
#' @export
VALUE_TYPE_ERROR <- "Tipo del elemento erroneo."

#' Collection empty error message
#'
#' @export
COLLECTION_EMPTY <- "Coleccion vacia."

#' Collection size error message
#'
#' @export
COLLECTION_SIZE_ERROR <- "Size definida erronea."

#' Type not allowed error message
#'
#' @export
TYPE_NOT_ALLOWED <- "Tipo no permitido."

#' Value undefined error message
#'
#' @export
VALUE_UNDEFINED <- "Valor no definido."

#' Critical error message
#'
#' @export
CRITICAL_ERROR <- "Error!!"

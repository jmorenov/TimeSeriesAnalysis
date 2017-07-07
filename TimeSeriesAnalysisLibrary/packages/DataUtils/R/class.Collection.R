#' Collection
#'
#' Clase que almacena colecciones de objetos e implementa metodos genericos para gestionarlas.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A Collection Class of type \code{\link{R6Class}}.
#' @section Warning: Metodo get devuelve referencia a objeto, no copia.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
#'
Collection <- R6Class("Collection",
                      private = list(
                        data = NA,
                        n = 0,
                        type_allowed = c("logical", "numeric", "double", "integer", "environment", "character"),
                        type = "logical",
                        check_value = function(value) {
                          assert(typeof(value) %in% private$type_allowed, CRITICAL_ERROR)
                          if ("numeric" %in% class(value))
                            assert(private$type %in% c("numeric", "double", "integer"), CRITICAL_ERROR)
                          else
                            assert((class(value) == private$type) || (typeof(value) == private$type), CRITICAL_ERROR)
                        },
                        check_index = function(index) {
                          assert(class(index) %in% c("double", "numeric", "integer"), CRITICAL_ERROR)
                          index <- as.integer(index)
                          assert(index > 0 && index <= private$n, CRITICAL_ERROR)
                          return(index)
                        }
                      ),
                      public = list(
                        initialize = function(n = 0, type="logical") {
                          # Check arguments. Exceptions:
                          assert(class(n) %in% c("numeric", "double", "integer"), CRITICAL_ERROR)
                          n <- as.integer(n)
                          assert(n >= 0, COLLECTION_SIZE_ERROR)
                          if (!is.character(type)) type <- typeof(type)
                          assert(type %in% private$type_allowed, TYPE_NOT_ALLOWED)

                          # Build collection:
                          private$type <<- type
                          private$n <<- n
                          if (private$type == "environment") private$data <<- list()
                          else private$data <<- vector(length = private$n, mode = private$type)
                        },
                        add = function(value, index) {
                          # Check arguments. Exceptions:
                          assert(!missing(value), VALUE_UNDEFINED)
                          private$check_value(value)
                          if (typeof(value) == "environment") {
                            if (!missing(index)) {
                              index <- private$check_index(index)
                              if (index == 1) private$data <<- c(value$clone(deep = T), private$data)
                              else private$data <<- c(private$data[1:(index - 1)], value$clone(deep = T), private$data[index:private$n])
                            }
                            else private$data[[private$n + 1]] <<- value$clone(deep = T)
                          } else {
                            if (!missing(index)) {
                              index <- private$check_index(index)
                              if (index == 1) private$data <<- c(value, private$data)
                              else private$data <<- c(private$data[1:(index - 1)], value, private$data[index:private$n])
                            }
                            else private$data[[private$n + 1]] <<- value
                          }
                          private$n <<- private$n + 1
                        },
                        remove = function(index) {
                          # Check arguments. Exceptions:
                          assert(!missing(index), CRITICAL_ERROR)
                          index <- private$check_index(index)

                          if (is.list(private$data)) private$data[[index]] <<- NULL
                          else private$data <<- private$data[-index]
                          private$n <<- private$n - 1
                        },
                        get = function(index) { #### !! Devuelve referencia a objeto, no copia !! ##
                          # Check arguments. Exceptions:
                          assert(!missing(index), CRITICAL_ERROR)
                          index <- private$check_index(index)
                          private$data[[index]]
                        },
                        set = function(value, index) {
                          # Check arguments. Exceptions:
                          assert(!missing(index), CRITICAL_ERROR)
                          index <- private$check_index(index)
                          assert(!missing(value), VALUE_UNDEFINED)
                          private$check_value(value)
                          if (typeof(value) == "environment") private$data[[index]] <<- value$clone(deep = T)
                          else private$data[[index]] <<- value
                        },
                        removeAll = function() {
                          assert(private$n > 0, COLLECTION_EMPTY)
                          private$data <<- NA
                          private$n <<- 0
                          private$type <<- "logical"
                        },
                        size = function() {
                          private$n
                        },
                        toBasicCollection = function() {
                          if (is.list(private$data))
                            return(private$data)
                          else
                            return(as.vector(private$data))
                        }
                      ))

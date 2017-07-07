#' Messages
#'
#' Messages defined for use by log.
#'
#' @export
#' @format A list of messages.
#' \describe{
#'   \item{ID}{ID of the message}
#'   \item{content}{content of the message}
#' }
Messages <- R6Class("Messages",
                    private = list(
                      list_msg = NA
                    ),
                    public = list(
                      initialize = function() {
                        private$list_msg <<- list()
                      },
                      add = function(name, msg) {
                        name <- as.name(name)
                        private$list_msg$name <<- msg
                      },
                      get = function(name) {
                        name <- as.name(name)
                        private$list_msg$name
                      }
                    ))

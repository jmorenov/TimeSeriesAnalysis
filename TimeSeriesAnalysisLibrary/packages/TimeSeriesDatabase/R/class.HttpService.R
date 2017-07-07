#' HttpService
#'
#' Clase que implementa metodos basicos para realizar peticiones http.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A HttpService Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
HttpService <- R6::R6Class("HttpService",
   private = list(),
   public = list(
     initialize = function() {},
     
     get = function(url) {
       con <- httr::GET(url)
       data <-  jsonlite::fromJSON(httr::content(con, "text", encoding = "UTF-8"))
       
       return(data)
     },
     
     post = function(url, params, files) {
       if (!missing(files)) {
         for (file in files) {
           params[[file$name]] <- httr::upload_file(file$path)
         }
       }
       
       con <- httr::POST(url, body = params, encode = "multipart")
       data <-  jsonlite::fromJSON(httr::content(con, "text", encoding = "UTF-8"))
       
       return(data)
     }
  )
)

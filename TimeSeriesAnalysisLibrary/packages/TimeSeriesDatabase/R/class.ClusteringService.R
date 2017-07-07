#' ClusteringService
#'
#' Clase que implementa metodos basicos para aplicar y obtener clustering
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A ComplexityMeasuresService Class of type \code{\link{R6Class}}.
#' @section Warning: Advertencias.
#' @section Methods:
#' \describe{
#'   \item{\code{example_method(parameter_1 = 3)}}{This method uses \code{parameter_1} to ...}
#' }
#' @author Javier Moreno <javmorenov@@gmail.com>
ClusteringService <- R6::R6Class("ClusteringService", 
  private = list(
   httpService = NA,
   baseUrl = NA,
   username = NA,
   password = NA
  ),
  public = list(
   initialize = function(username, password) {
     private$httpService <<- HttpService$new()
     private$baseUrl <<- paste0(Config$API_HOST, "/analysis/clustering")
     private$username <<- username
     private$password <<- password
   },
   get = function() {
     clusteringResults <- private$httpService$get(paste0(private$baseUrl, "/"))
     
     return(clusteringResults)
   },
   
   insert = function(centers) {
     assert(!missing(centers), 
            "Error inserting clustering: missing fields")
     
     params <- list(username = private$username, 
                    password = private$password,
                    centers = jsonlite::toJSON(centers))
     
     clusteringResult <- private$httpService$post(paste0(private$baseUrl, "/"), params)
     
     return(clusteringResult)
   }
  )
)
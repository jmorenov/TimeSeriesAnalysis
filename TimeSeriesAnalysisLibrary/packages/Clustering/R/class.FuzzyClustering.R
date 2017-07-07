#' @description Clase que define el metodo FuzzyClustering usando standard fkm algorithm.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClustering
#' @export
FuzzyClustering <- R6::R6Class("FuzzyClustering", inherit = NHierarchical,
                  private = list(
                  ),
                  public = list(
                    initialize = function() {
                      super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                    },
                    apply = function(data, ...) {
                      result <- super$apply(data, ...)
                      assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                      k <- result$ncenters()
                      if (k > ceiling(data$rows()/2)) k <- 2
                      groups <- fclust::FKM(data$toBasicCollection(), k)$clus[,1]
                      return(self$computeGroups(groups, result))
                    }
                  ))

#' @description Clase que define el metodo FuzzyClustering usando Gustafson and Kessel extension of fkm.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClusteringGK
FuzzyClusteringGK <- R6Class("FuzzyClusteringGK", inherit = NHierarchical,
                           private = list(),
                           public = list(
                             initialize = function() {
                               super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                             },
                             apply = function(data, ...) {
                               result <- super$apply(data, ...)
                               assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                               k <- result$ncenters()
                               if (k > ceiling(data$rows()/2)) k <- 2
                               groups <- fclust::FKM.gk(data$toBasicCollection(), k)$clus[,1]
                               return(self$computeGroups(groups, result))
                             }
                           ))

#' @description Clase que define el metodo FuzzyClustering usando fkm with entropy regularization.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClusteringENT
FuzzyClusteringENT <- R6Class("FuzzyClusteringENT", inherit = NHierarchical,
                             private = list(
                             ),
                             public = list(
                               initialize = function() {
                                 super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                               },
                               apply = function(data, ...) {
                                 result <- super$apply(data, ...)
                                 assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                                 k <- result$ncenters()
                                 if (k > ceiling(data$rows()/2)) k <- 2
                                 groups <- fclust::FKM.ent(data$toBasicCollection(), k)$clus[,1]
                                 return(self$computeGroups(groups, result))
                               }
                             ))

#' @description Clase que define el metodo FuzzyClustering usando Gustafson and Kessel extension of fkm with entropy regularization.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClusteringGKENT
FuzzyClusteringGKENT <- R6Class("FuzzyClusteringGKENT", inherit = NHierarchical,
                              private = list(
                              ),
                              public = list(
                                initialize = function() {
                                  super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                                },
                                apply = function(data, ...) {
                                  result <- super$apply(data, ...)
                                  assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                                  k <- result$ncenters()
                                  if (k > ceiling(data$rows()/2)) k <- 2
                                  groups <- fclust::FKM.gk.ent(data$toBasicCollection(), k)$clus[,1]
                                  return(self$computeGroups(groups, result))
                                }
                              ))

#' @description Clase que define el metodo FuzzyClustering usando fuzzy k-medoids algorithm.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClusteringMED
FuzzyClusteringMED <- R6Class("FuzzyClusteringMED", inherit = NHierarchical,
                                private = list(
                                ),
                                public = list(
                                  initialize = function() {
                                    super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                                  },
                                  apply = function(data, ...) {
                                    result <- super$apply(data, ...)
                                    assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                                    k <- result$ncenters()
                                    if (k > ceiling(data$rows()/2)) k <- 2
                                    groups <- fclust::FKM.med(data$toBasicCollection(), k)$clus[,1]
                                    return(self$computeGroups(groups, result))
                                  }
                                ))

#' @description Clase que define el metodo FuzzyClustering usando fkm with noise cluster.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClusteringNOISE
FuzzyClusteringNOISE <- R6Class("FuzzyClusteringNOISE", inherit = NHierarchical,
                              private = list(
                              ),
                              public = list(
                                initialize = function() {
                                  super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                                },
                                apply = function(data, ...) {
                                  result <- super$apply(data, ...)
                                  assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                                  k <- result$ncenters()
                                  if (k > ceiling(data$rows()/2)) k <- 2
                                  groups <- fclust::FKM.noise(data$toBasicCollection(), k)$clus[,1]
                                  return(self$computeGroups(groups, result))
                                }
                              ))

#' @description Clase que define el metodo FuzzyClustering usando Gustafson and Kessel extension of fkm with noise cluster.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClusteringGKNOISE
FuzzyClusteringGKNOISE <- R6Class("FuzzyClusteringGKNOISE", inherit = NHierarchical,
                                private = list(
                                ),
                                public = list(
                                  initialize = function() {
                                    super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                                  },
                                  apply = function(data, ...) {
                                    result <- super$apply(data, ...)
                                    assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                                    k <- result$ncenters()
                                    if (k > ceiling(data$rows()/2)) k <- 2
                                    groups <- fclust::FKM.gk.noise(data$toBasicCollection(), k)$clus[,1]
                                    return(self$computeGroups(groups, result))
                                  }
                                ))

#' @description Clase que define el metodo FuzzyClustering usando fkm with entropy regularization and noise cluster.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClusteringENTNOISE
FuzzyClusteringENTNOISE <- R6Class("FuzzyClusteringENTNOISE", inherit = NHierarchical,
                                private = list(
                                ),
                                public = list(
                                  initialize = function() {
                                    super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                                  },
                                  apply = function(data, ...) {
                                    result <- super$apply(data, ...)
                                    assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                                    k <- result$ncenters()
                                    if (k > ceiling(data$rows()/2)) k <- 2
                                    groups <- fclust::FKM.ent.noise(data$toBasicCollection(), k)$clus[,1]
                                    return(self$computeGroups(groups, result))
                                  }
                                ))

#' @description Clase que define el metodo FuzzyClustering usando Gustafson and Kessel extension of fkm with entropy regularization and noise cluster.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClusteringGKENTNOISE
FuzzyClusteringGKENTNOISE <- R6Class("FuzzyClusteringGKENTNOISE", inherit = NHierarchical,
                                   private = list(
                                   ),
                                   public = list(
                                     initialize = function() {
                                       super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                                     },
                                     apply = function(data, ...) {
                                       result <- super$apply(data, ...)
                                       assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                                       k <- result$ncenters()
                                       if (k > ceiling(data$rows()/2)) k <- 2
                                       groups <- fclust::FKM.gk.ent.noise(data$toBasicCollection(), k)$clus[,1]
                                       return(self$computeGroups(groups, result))
                                     }
                                   ))

#' @description Clase que define el metodo FuzzyClustering usando fuzzy clustering with polynomial fuzzifier.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClusteringPF
FuzzyClusteringPF <- R6Class("FuzzyClusteringPF", inherit = NHierarchical,
                                     private = list(
                                     ),
                                     public = list(
                                       initialize = function() {
                                         super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                                       },
                                       apply = function(data, ...) {
                                         result <- super$apply(data, ...)
                                         assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                                         k <- result$ncenters()
                                         if (k > ceiling(data$rows()/2)) k <- 2
                                         groups <- fclust::FKM.pf(data$toBasicCollection(), k)$clus[,1]
                                         return(self$computeGroups(groups, result))
                                       }
                                     ))

#' @description Clase que define el metodo FuzzyClustering usando fuzzy clustering with polynomial fuzzifier and noise cluster.
#' @template template.FuzzyClustering
#' @templateVar class_name FuzzyClusteringPFNOISE
FuzzyClusteringPFNOISE <- R6Class("FuzzyClusteringPFNOISE", inherit = NHierarchical,
                             private = list(
                             ),
                             public = list(
                               initialize = function() {
                                 super$initialize("FuzzyClustering", "FuzzyClustering method of clustering.")
                               },
                               apply = function(data, ...) {
                                 result <- super$apply(data, ...)
                                 assert(requireNamespace("fclust", quietly = TRUE), CRITICAL_ERROR)
                                 k <- result$ncenters()
                                 if (k > ceiling(data$rows()/2)) k <- 2
                                 groups <- fclust::FKM.pf.noise(data$toBasicCollection(), k)$clus[,1]
                                 return(self$computeGroups(groups, result))
                               }
                             ))

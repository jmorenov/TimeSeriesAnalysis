#' Devuelve una lista con todas las transformaciones.
#'
#' @export
#'
#'
#' @return A MethodCollection object with all Transformations methods.
#'
#'@examples
#' getTransformationMethods()
#'
getTransformationMethods <- function() {
  mc <- DataUtils::MethodCollection$new()

  mc$add(LogarithmicTransformation$new())
  mc$add(CubicTransformation$new())
  mc$add(LogarithmicBase10Transformation$new())
  mc$add(LogarithmicBase2Transformation$new())
  mc$add(ExponentialTransformation$new())
  mc$add(SquareRootTransformation$new())
  mc$add(AbsoluteValueTransformation$new())
  mc$add(SineTransformation$new())
  mc$add(CosineTransformation$new())
  mc$add(ArcCosineTransformation$new())

  return(mc)
}

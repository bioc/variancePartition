#' Sort variance partition statistics
#'
#' Sort columns returned by \code{extractVarPart()} or \code{fitExtractVarPartModel()}
#'
#' @param x object returned by \code{extractVarPart()} or \code{fitExtractVarPartModel()}
#' @param FUN function giving summary statistic to sort by.  Defaults to median
#' @param decreasing  logical.  Should the sorting be increasing or decreasing?
#' @param last columns to be placed on the right, regardless of values in these columns
#' @param ... other arguments to sort
#'
#' @return
#' data.frame with columns sorted by mean value, with Residuals in last column
#'
#' @examples
#' # library(variancePartition)
#'
#' library(BiocParallel)
#'
#' # load simulated data:
#' # geneExpr: matrix of gene expression values
#' # info: information/metadata about each sample
#' data(varPartData)
#'
#' # Specify variables to consider
#' # Age is continuous so we model it as a fixed effect
#' # Individual and Tissue are both categorical, so we model them as random effects
#' form <- ~ Age + (1 | Individual) + (1 | Tissue)
#'
#' # Step 1: fit linear mixed model on gene expression
#' # If categorical variables are specified, a linear mixed model is used
#' # If all variables are modeled as continuous, a linear model is used
#' # each entry in results is a regression model fit on a single gene
#' # Step 2: extract variance fractions from each model fit
#' # for each gene, returns fraction of variation attributable to each variable
#' # Interpretation: the variance explained by each variable
#' # after correction for all other variables
#' varPart <- fitExtractVarPartModel(geneExpr, form, info)
#'
#' # violin plot of contribution of each variable to total variance
#' # sort columns by median value
#' plotVarPart(sortCols(varPart))
#'
#' @export
#' @docType methods
#' @rdname sortCols-method
setGeneric("sortCols",
  signature = "x",
  function(x, FUN = median, decreasing = TRUE, last = c("Residuals", "Measurement.error"), ...) {
    standardGeneric("sortCols")
  }
)

#' @export
#' @rdname sortCols-method
#' @aliases sortCols,matrix-method
setMethod(
  "sortCols", "matrix",
  function(x, FUN = median, decreasing = TRUE, last = c("Residuals", "Measurement.error"), ...) {
    .sortCols(x, FUN, decreasing, last, ...)
  }
)

#' @export
#' @rdname sortCols-method
#' @aliases sortCols,data.frame-method
setMethod(
  "sortCols", "data.frame",
  function(x, FUN = median, decreasing = TRUE, last = c("Residuals", "Measurement.error"), ...) {
    .sortCols(x, FUN, decreasing, last, ...)
  }
)

#' @export
#' @rdname sortCols-method
#' @aliases sortCols,varPartResults-method
setMethod(
  "sortCols", "varPartResults",
  function(x, FUN = median, decreasing = TRUE, last = c("Residuals", "Measurement.error"), ...) {
    # df = suppressWarnings(as.data.frame(x, check.names=FALSE))

    df <- as.data.frame(x@.Data)
    colnames(df) <- names(x)
    rownames(df) <- x@row.names

    res <- .sortCols(df, FUN, decreasing, last, ...)

    # res = as.data.frame( res )

    vp <- new("varPartResults", res, type = x@type, method = x@method)

    return(vp)
  }
)

# internal driver function
.sortCols <- function(x, FUN = median, decreasing = TRUE, last = c("Residuals", "Measurement.error"), ...) {
  # sort by column mean
  i <- order(apply(x, 2, FUN), decreasing = decreasing)

  # apply sorting
  x <- x[, i, drop = FALSE]

  # find column with Residuals
  idx <- match(last, colnames(x))

  if (any(!is.na(idx))) {
    i <- idx[!is.na(idx)]

    res <- cbind(x[, -i, drop = FALSE], x[, i, drop = FALSE])
  } else {
    res <- x[, , drop = FALSE]
  }

  return(res)
}

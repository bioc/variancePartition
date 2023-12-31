# Gabriel Hoffman
# April 18, 2016

#' plotCorrMatrix
#'
#' Plot correlation matrix
#'
#' @param C correlation matrix: R or R^2 matrix
#' @param dendrogram character string indicating whether to draw 'both' or none'
#' @param sort sort rows and columns based on clustering
#' @param margins spacing of plot
#' @param key.xlab label of color gradient
#' @param ... additional arguments to heatmap.2
#'
#' @details
#' Plots image of correlation matrix using customized call to heatmap.2
#'
#' @return
#' Image of correlation matrix
#'
#' @examples
#'
#' # simulate simple matrix of 10 variables
#' mat <- matrix(rnorm(1000), ncol = 10)
#'
#' # compute correlation matrix
#' C <- cor(mat)
#'
#' # plot correlations
#' plotCorrMatrix(C)
#'
#' # plot squared correlations
#' plotCorrMatrix(C^2, dendrogram = "none")
#'
#' @importFrom gplots heatmap.2
#' @export
plotCorrMatrix <- function(C, dendrogram = "both", sort = TRUE, margins = c(13, 13), key.xlab = "correlation", ...) {
  # if( any(is.na(C)) ){
  # 	stop("Matrix most not have NA entries")
  # }

  C <- round(C, digits = 5)

  if (max(C, na.rm = TRUE) > 1) {
    stop("max value is greater than 1")
  }
  if (min(C, na.rm = TRUE) < -1) {
    stop("min value is less than -1")
  }

  # keep only columns that have more than 1 non-NA value
  keep <- apply(C, 2, function(x) sum(!is.na(x)) > 1)

  # avoid error when distances are Inf because all entries are NA
  if (sum(!keep) > 0) {
    txt <- paste(sum(!keep), "variables only have NA values and were omitted from plot:\n ", paste0(rownames(C)[!keep], collapse = "\n  "))

    warning(txt)

    rownames(C)[!keep]
    C <- C[keep, keep]
  }

  if (min(C, na.rm = TRUE) < 0) {
    pal <- colorRampPalette(c("blue", "white", "red"))
    lim <- c(-1, 1)
  } else {
    pal <- colorRampPalette(c("white", "red"))
    lim <- c(0, 1)
  }
  ncolors <- 100

  # Rowv=FALSE, Colv=FALSE,
  heatmap.2(C, symm = TRUE, col = pal(ncolors), dendrogram = dendrogram, trace = "none", keysize = .8, density.info = "none", margins = margins, key.title = "", key.xlab = key.xlab, key.par = list(mgp = c(1.5, 0.5, 0), mar = c(2, 2.5, 1, 0), fig = c(0.7, 0.9, 0.1, 0.2), new = TRUE), breaks = seq(lim[1], lim[2], length.out = ncolors + 1), key.xtickfun = function() {
    at <- seq(0, 1, length.out = 5)
    lab <- seq(lim[1], lim[2], length.out = 5)
    list(at = at, labels = lab)
  }, Rowv = sort, Colv = sort, na.color = "grey80", ...)
}

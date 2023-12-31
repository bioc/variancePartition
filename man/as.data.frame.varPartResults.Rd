% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/misc.R
\name{as.data.frame.varPartResults}
\alias{as.data.frame.varPartResults}
\title{Convert to data.frame}
\usage{
\method{as.data.frame}{varPartResults}(x, row.names = NULL, optional = FALSE, ...)
}
\arguments{
\item{x}{varPartResults}

\item{row.names}{pass thru to generic}

\item{optional}{pass thru to generic}

\item{...}{other arguments.}
}
\value{
data.frame
}
\description{
Convert varPartResults to data.frame
}
\examples{
# load library
# library(variancePartition)

# load simulated data:
# geneExpr: matrix of gene expression values
# info: information/metadata about each sample
data(varPartData)

# Specify variables to consider
# Age is continuous so we model it as a fixed effect
# Individual and Tissue are both categorical, so we model them as random effects
form <- ~ Age + (1 | Individual) + (1 | Tissue)

# Fit model
varPart <- fitExtractVarPartModel(geneExpr[1:5, ], form, info)

# convert to matrix
as.data.frame(varPart)

}

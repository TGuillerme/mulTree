\name{summary.mulTree}
\alias{summary.mulTree}

\title{Summarise "mulTree" data}

\description{Summarise MCMCglmm by performing the hdr function on mulTree data and outputs a list of hdr for each fixed and random terms.}

\usage{
## S3 method for class 'mulTree'
summary(mulTree.mcmc, CI=95, use.hdr=TRUE, ...)
}

\arguments{
\item{mulTree.mcmc}{A "mulTree" object obtained from \code{read.mulTree()} function.}

\item{CI}{A value for the lower and upper credibility intervals (default=95).}

\item{use.hdr}{Logical. Whether to use the \code{hdrcde::hdr} (\code{TRUE}) or \code{stats::quantile} (\code{FALSE}) functions for summarising the data.}

\item{...}{Any optional arguments to be passed to the \code{hdrcde::hdr} or \code{stats::quantile} function (if \code{use.hdr = FALSE}).}
}

\details{
    Note that the results maybe vary when using \code{use.hdr = FALSE} or \code{TRUE}.
    We recommend to use \code{use.hdr = TRUE} when possible.

    When \code{use.hdr = FALSE}, the computation is faster but the quantiles are calculated and not estimated.
    The given estimates central tendency is calculated as the median.
    
    When \code{use.hdr = TRUE}, the computation is slower but the quantiles are estimated using the highest density regions.
    The given estimates central tendency is calculated as the mode of the estimated highest density region.
}

\seealso{\link{read.mulTree}, \link{plot.mulTree}}

\examples{
## Read in the data
data(lifespan.mcmc)

## Summarizing all the chains
summary(lifespan.mcmc)

## Modyfing the CI
summary(lifespan.mcmc, CI=95) == summary(lifespan.mcmc, CI=10) #Is mainly FALSE

## Using use.hdr = FALSE
summary(lifespan.mcmc, use.hdr=FALSE)

## Difference in results
round(summary(lifespan.mcmc) - summary(lifespan.mcmc, use.hdr=FALSE), digit = 3)

## Difference in time
system.time(summary(lifespan.mcmc))
system.time(summary(lifespan.mcmc, use.hdr = FALSE))
}

\author{Thomas Guillerme}